#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables appear unused, but are used inside snippet

PACKAGES=(
  qemu-system-x86
  libvirt-daemon-system
  bridge-utils
  dnsmasq-base
)

snippet "packages-installed"
