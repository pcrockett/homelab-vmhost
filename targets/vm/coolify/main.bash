#!/usr/bin/env blarg

export VM_NAME=coolify

targets=(
  tailscale-provisioned
)

depends_on "${targets[@]}"
