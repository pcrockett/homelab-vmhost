#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  networks-isolated
  scratch/main
  coolify/main
)

depends_on "${targets[@]}"
