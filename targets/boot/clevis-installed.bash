#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables appear unused, but are used inside snippet

PACKAGES=(
  clevis
  clevis-tpm2
  clevis-luks
  clevis-initramfs
  initramfs-tools
)

snippet "packages-installed"
