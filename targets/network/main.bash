#!/usr/bin/env blarg

targets=(
  tailscale-installed
  wlan-driver-installed
  wlan-connection-configured
  firewalld-enabled
)

depends_on "${targets[@]}"
