#!/usr/bin/env blarg

targets=(
  tailscale-installed
  tailscale-provisioned
  wlan-driver-installed
  wlan-connection-configured
  sshd-disabled
  # nftables-enabled
)

depends_on "${targets[@]}"
