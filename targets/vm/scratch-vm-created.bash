#!/usr/bin/env blarg
#
# provision a disposable VM
#

depends_on incus-initialized

VM_NAME=scratch
CPU_COUNT=2
MEMORY=2GiB
ROOT_DISK_SIZE=50GiB

satisfied_if() {
  incus info "${VM_NAME}"
}

apply() {
  incus create images:archlinux "${VM_NAME}" \
    --vm \
    --config limits.cpu="${CPU_COUNT}" \
    --config limits.memory="${MEMORY}" \
    --config security.secureboot=false \
    --device root,size="${ROOT_DISK_SIZE}"
}
