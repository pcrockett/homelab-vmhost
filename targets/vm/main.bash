#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  latest-arch-iso-downloaded
  incus-initialized
)

depends_on "${targets[@]}"
