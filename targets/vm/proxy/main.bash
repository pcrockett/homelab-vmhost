#!/usr/bin/env blarg

export VM_NAME=proxy

targets=(
  tailscale-provisioned
  sudoers-configured
)

depends_on "${targets[@]}"
