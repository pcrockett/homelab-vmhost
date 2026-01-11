#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  latest-arch-iso-downloaded
)

depends_on "${targets[@]}"
