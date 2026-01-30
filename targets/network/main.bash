#!/usr/bin/env blarg

targets=(
  tailscale-installed
  wlan-driver-installed
  wlan-connection-configured
  nftables-installed
)

depends_on "${targets[@]}"
