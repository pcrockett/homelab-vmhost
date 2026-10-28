# Coolify Overview

<!-- [tag:coolify-overview] -->

_Not implemented yet: This is the next version of the Coolify experiment. Need to tear
down my current coolify VM still and rebuild it._

- a Coolify instance to run arbitrary services
- accessible via tailnet only
- using nice domain names via a wildcard certificate: `*.internal.example.com`
- with proper HTTPS
- considered "untrusted," outgoing connections to private subnets and tailnet are
  forbidden

## Trusted reverse proxy VM

- Run Caddy in a trusted VM, Tailscale tag `trusted`.
- Does not receive traffic from the Internet; only accessible via tailnet.
- No access to private subnets. Just needs tailnet access.
- Does TLS termination, uses Let's Encrypt plus DNS challenge to get a wildcard cert.
- Routes all `*.internal.example.com` requests to Coolify VM, via Tailscale interface.
- Porkbun API key stored in Bitwarden, scoped to just the internal domain.
- Domain name is a setting configured in `.envrc`

Caddy Dockerfile should look _roughly_ like:

```dockerfile
FROM caddy:2-builder AS builder
RUN xcaddy build --with github.com/caddy-dns/porkbun

FROM caddy:2
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
```

Caddy config should look _roughly_ like:

```caddyfile
{
	acme_dns porkbun {
		api_key {$PORKBUN_API_KEY}
		api_secret_key {$PORKBUN_API_SECRET_KEY}
	}
}

*.internal.{$APEX_DOMAIN} {
	reverse_proxy 100.x.y.z:80
}
```

## Untrusted Coolify VM

- No HTTPS setup, no Traefik setup
- Needs to only route certain HTTP hostnames to the correct app
