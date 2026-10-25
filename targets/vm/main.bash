#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  coolify-vm-started
  scratch/main
)

depends_on "${targets[@]}"
