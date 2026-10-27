#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  networks-isolated
  coolify-vm-started
  scratch/main
)

depends_on "${targets[@]}"
