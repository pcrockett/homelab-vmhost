#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  scratch/tailscale-provisioned
  coolify-vm-started
)

depends_on "${targets[@]}"
