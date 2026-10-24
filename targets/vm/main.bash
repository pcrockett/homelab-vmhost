#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  scratch/tailscale-provisioned
  scratch/sudoers-configured
  coolify-vm-started
)

depends_on "${targets[@]}"
