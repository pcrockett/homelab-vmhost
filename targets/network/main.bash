#!/usr/bin/env blarg

targets=(
  tailscale-installed
  wlan-driver-installed
)

depends_on "${targets[@]}"
