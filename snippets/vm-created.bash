# create an incus virtual machine

depends_on vm/incus-initialized

VM_NAME="${VM_NAME:?must specify vm name at least}"
CPU_COUNT="${CPU_COUNT:-2}"
MEMORY="${MEMORY:-2GiB}"
ROOT_DISK_SIZE="${ROOT_DISK_SIZE:-15GiB}"
INCUS_IMAGE="${INCUS_IMAGE:-images:archlinux}"

satisfied_if() {
  incus info "${VM_NAME}"
}

apply() {
  incus create "${INCUS_IMAGE}" "${VM_NAME}" \
    --vm \
    --config limits.cpu="${CPU_COUNT}" \
    --config limits.memory="${MEMORY}" \
    --config security.secureboot=false \
    --device root,size="${ROOT_DISK_SIZE}"
}
