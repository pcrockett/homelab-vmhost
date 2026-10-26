#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  host-isolated
  coolify-vm-started
  scratch/main
)

depends_on "${targets[@]}"
