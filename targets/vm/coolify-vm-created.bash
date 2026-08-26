#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables used inside snippet

VM_NAME=coolify
CPU_COUNT=2
MEMORY=4GiB
ROOT_DISK_SIZE=50GiB
INCUS_IMAGE=images:archlinux

snippet vm-created
