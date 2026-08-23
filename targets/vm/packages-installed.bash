#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables appear unused, but are used inside snippet

PACKAGES=(
  bridge-utils
  dnsmasq-base
  gdisk # incus uses this to adjust GPT disks
  incus
  libspice-server1
  libvirt-daemon-system
  ovmf # uefi firmware for vms, incus requires it
  qemu-system-modules-spice
  qemu-system-x86
  qemu-utils # for qemu-img tool, which allows creating qcow2 volumes
)

snippet "packages-installed"
