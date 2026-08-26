#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  scratch-vm-started
  coolify-vm-started
)

depends_on "${targets[@]}"
