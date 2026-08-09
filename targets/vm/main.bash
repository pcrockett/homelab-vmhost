#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  latest-arch-iso-downloaded
  incus-group-configured
)

depends_on "${targets[@]}"
