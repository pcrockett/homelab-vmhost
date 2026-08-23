#!/usr/bin/env blarg
#
# provision a disposable VM
#

depends_on incus-initialized

VM_NAME=scratch
CPU_COUNT=2
MEMORY=2GiB
MEMORY_ENFORCE=soft
ROOT_DISK_SIZE=30GiB

satisfied_if() {
  incus info "${VM_NAME}"
}

apply() {
  incus create images:archlinux "${VM_NAME}" \
    --vm \
    --config limits.cpu="${CPU_COUNT}" \
    --config limits.memory="${MEMORY}" \
    --config limits.memory.enforce="${MEMORY_ENFORCE}" \
    --config security.secureboot=false \
    --device root,size="${ROOT_DISK_SIZE}"
}
