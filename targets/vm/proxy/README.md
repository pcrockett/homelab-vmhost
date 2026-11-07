# proxy vm

high-trust reverse proxy VM. see [doc/PROXY.md](../../../doc/PROXY.md) for the full
design.

- incus VM `proxy` on its own bridge (`proxybr0`), auto-isolated by the existing
  network ACL targets: egress is internet + tailscale only
- tailnet only, advertises `tag:trusted`
- runs Caddy as a dedicated restricted system user (`caddy`, no admin rights),
  serving `*.internal.${INTERNAL_APEX_DOMAIN}` with a Let's Encrypt wildcard cert
  via the Porkbun DNS challenge

## apply flow

`just apply` from the control machine does everything:

1. host-side targets here create/start the VM and configure it via `incus exec`
2. `guest-applied` then runs `blarg --ssh "${SSH_PROXY_DEST}"` into the VM, which
   applies `guest.bash` (caddyfile + service) natively inside the VM

## prerequisites (manual, one-time)

- tailscale admin console: create `tag:trusted` and an auth key pre-authorized for it
- bitwarden item `machine.proxy` with fields `tailscale.auth-key`,
  `porkbun.api-key`, `porkbun.api-secret-key` (Porkbun key scoped to the apex
  domain only)
- `.envrc`: `SSH_PROXY_DEST` and `INTERNAL_APEX_DOMAIN` (gitignored, so the domain
  never enters this public repo)

## open question

how the porkbun-enabled caddy binary is built off-VM and delivered — stub at
`caddy-binary-delivered.bash`, not wired into `main.bash` yet. until then,
`just apply` fails at the guest-side `caddy-service-enabled` target (no
`/usr/local/bin/caddy`); everything before it applies fine.
