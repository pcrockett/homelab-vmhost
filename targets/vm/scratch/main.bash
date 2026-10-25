#!/usr/bin/env blarg

targets=(
  tailscale-provisioned
  sudoers-configured
)

depends_on "${targets[@]}"
