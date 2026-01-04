#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
)

depends_on "${targets[@]}"
