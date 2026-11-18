#!/usr/bin/env blarg

export VM_NAME=docker

targets=(
  tailscale-provisioned
  sudoers-configured
)

depends_on "${targets[@]}"
