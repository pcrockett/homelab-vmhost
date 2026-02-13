#!/usr/bin/env blarg

targets=(
  tailscale-installed
  wlan-driver-installed
  wlan-connection-configured
  nftables-enabled
)

depends_on "${targets[@]}"
