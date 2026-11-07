#!/usr/bin/env blarg

targets=(
  vm-started
  user-created
  sudoers-configured
  caddy-user-created
  tailscale-provisioned
  proxy-env-configured
  dns-record-configured
  guest-applied
)

depends_on "${targets[@]}"
