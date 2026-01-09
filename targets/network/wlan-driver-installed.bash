#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables appear unused, but are used inside snippet

# this is a laptop with no ethernet port. the usb hub i'm currently using does provide
# an ethernet port, and i use it during OS installation, but it SUCKS in comparison to
# 5GHz wifi. wifi has way better performance and (probably) reliability.

PACKAGES=(
  firmware-iwlwifi
)

snippet "packages-installed"
