#!/usr/bin/env blarg

targets=(
  tailscale-installed
  wlan-driver-installed
  wlan-connection-configured
)

depends_on "${targets[@]}"
