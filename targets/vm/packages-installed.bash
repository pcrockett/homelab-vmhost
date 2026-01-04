#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables appear unused, but are used inside snippet

PACKAGES=(
  qemu-system-x86
  libvirt-daemon-system
  bridge-utils
  dnsmasq-base
  qemu-utils  # for qemu-img tool, which allows creating qcow2 volumes
  libspice-server1
  qemu-system-modules-spice
)

snippet "packages-installed"
