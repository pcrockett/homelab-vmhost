#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables appear unused, but are used inside snippet

PACKAGES=(
  bridge-utils
  dnsmasq-base
  incus
  libspice-server1
  libvirt-daemon-system
  qemu-system-modules-spice
  qemu-system-x86
  qemu-utils # for qemu-img tool, which allows creating qcow2 volumes
)

snippet "packages-installed"
