#!/usr/bin/env blarg

export VM_NAME=scratch

targets=(
  tailscale-provisioned
  sudoers-configured
)

depends_on "${targets[@]}"
