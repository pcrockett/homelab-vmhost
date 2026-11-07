#!/usr/bin/env blarg
#
# guest-side entry point for the proxy VM. applied from the vmhost by
# guest-applied via `blarg --ssh`, so these targets run natively inside the VM
# (as the admin user, with as_root available for system files).

targets=(
  caddyfile-configured
  caddy-service-enabled
)

depends_on "${targets[@]}"
