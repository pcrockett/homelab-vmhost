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

The trusted reverse proxy VM (Caddy, `tag:trusted`, Let's Encrypt wildcard via
Porkbun DNS challenge, serving `*.internal.<apex>`) is documented in
`[ref:proxy-overview]` and implemented under `targets/vm/proxy/`. Once it exists,
this plan's Coolify VM routes all `*.internal.<apex>` requests to it via the
Tailscale interface.

## Untrusted Coolify VM

- No HTTPS setup, no Traefik setup
- Needs to only route certain HTTP hostnames to the correct app
