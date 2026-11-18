#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  networks-isolated
  scratch/main
  coolify/main
  docker/main
  proxy/main
)

depends_on "${targets[@]}"
