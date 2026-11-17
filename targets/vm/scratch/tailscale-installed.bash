#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables used inside snippet

depends_on vm-started pacman-keyring-initialized

VM_NAME=scratch
snippet vm-tailscale-installed
