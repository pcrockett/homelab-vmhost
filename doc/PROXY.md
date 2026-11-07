# Trusted Reverse Proxy VM

<!-- [tag:proxy-overview] -->

A single high-trust VM that terminates TLS for `*.internal.<apex>` and will
reverse-proxy to other VMs over the tailnet. See `[ref:coolify-overview]` for how
this relates to the Coolify experiment.

- incus VM `proxy` on its own bridge (`proxybr0`), created and auto-isolated by
  the existing network targets (`[ref:vm/networks-created]`,
  `[ref:vm/networks-isolated]`): egress is internet + tailscale only, no private
  subnets
- tailnet only, advertises `tag:trusted`
- public wildcard DNS record `*.internal.<apex>` pointing at the VM's tailscale
  IP, which is detected at runtime — never hardcode IPs in this repo
- Let's Encrypt wildcard cert via the Porkbun DNS challenge
- domain and secrets never appear in tracked files: the domain comes from the
  gitignored `.envrc` (`INTERNAL_APEX_DOMAIN`), secrets from the Bitwarden item
  `machine.proxy`

## DNS

`targets/vm/proxy/dns-record-configured.bash` keeps a wildcard A record
`*.internal.${INTERNAL_APEX_DOMAIN}` pointing at `tailscale ip -4 proxy` via the
Porkbun API, using `porkbun.api-key` / `porkbun.api-secret-key` from
`machine.proxy`. Porkbun API keys can only be scoped per _registered domain_,
not per subdomain, so the accepted blast radius of a compromised VM is the whole
apex zone — the key is created scoped to that one domain only.

## TLS

Caddy's `acme_dns porkbun` block reads `{$PORKBUN_API_KEY}` /
`{$PORKBUN_API_SECRET_KEY}` from its process environment. The host-side
`proxy-env-configured` target renders those plus `INTERNAL_APEX_DOMAIN` into
`/etc/caddy/proxy.env` (root:caddy, 0640) on the VM, and `caddy.service` loads
it via `EnvironmentFile=`. The committed `config/caddy/Caddyfile` therefore
only contains `{$...}` placeholders.

## Caddy runtime

Caddy runs as a dedicated restricted system user `caddy` (no login shell, no
sudo), created by `caddy-user-created`. The unit grants only
`CAP_NET_BIND_SERVICE` for ports 80/443 and keeps certs under `/var/lib/caddy`
(`StateDirectory=caddy` + `XDG_DATA_HOME`).

## Config flow

One repo, two apply modes:

- host-side targets in `targets/vm/proxy/` run on the vmhost and configure the
  VM via `incus exec` (lifecycle, user accounts, tailscale, secrets, DNS record)
- `guest-applied` then runs `blarg --ssh "${SSH_PROXY_DEST}"` into the VM, which
  applies `guest.bash` natively inside the VM (Caddyfile + systemd unit) — same
  mechanism as the ai-sandbox repo's `apply-ssh`, but no separate repo needed

## Manual prerequisites

- tailscale admin console: `tag:trusted` + an auth key pre-authorized for it
- Bitwarden item `machine.proxy`: `tailscale.auth-key`, `porkbun.api-key`,
  `porkbun.api-secret-key`
- Porkbun API key scoped to the apex domain
- `.envrc`: `SSH_PROXY_DEST=phil@proxy`, `INTERNAL_APEX_DOMAIN=<apex>`

## Verify

From any tailnet device: `curl https://anything.internal.<apex>` returns the
hello page over a valid Let's Encrypt wildcard cert.

## Open questions

- how/where the porkbun-plugin caddy binary is built off-VM and delivered
  (stub: `targets/vm/proxy/caddy-binary-delivered.bash`, deliberately not wired
  into `main.bash` yet). until that lands, `just apply` fails at the guest-side
  `caddy-service-enabled` target because `/usr/local/bin/caddy` does not exist
  yet — everything before it (VM, tailscale, secrets, DNS record, Caddyfile)
  applies fine
- memory: starts at 1GiB; try 512MiB and see if arch + tailscaled + caddy fit
