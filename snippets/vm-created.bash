# create an incus virtual machine

depends_on vm/incus-initialized vm/networks-created

VM_NAME="${VM_NAME:?must specify vm name at least}"
CPU_COUNT="${CPU_COUNT:-2}"
MEMORY="${MEMORY:-2GiB}"
ROOT_DISK_SIZE="${ROOT_DISK_SIZE:-30GiB}"
INCUS_IMAGE="${INCUS_IMAGE:-images:archlinux}"
NIC_NETWORK="${NIC_NETWORK:-}"

satisfied_if() {
  incus info "${VM_NAME}"
}

apply() {
  local extra_args=()
  # a local eth0 from `--network` shadows the profile-inherited device
  if [ -n "${NIC_NETWORK}" ]; then
    extra_args=(--network "${NIC_NETWORK}")
  fi
  incus create "${INCUS_IMAGE}" "${VM_NAME}" \
    --vm \
    --config limits.cpu="${CPU_COUNT}" \
    --config limits.memory="${MEMORY}" \
    --config security.secureboot=false \
    --device root,size="${ROOT_DISK_SIZE}" \
    "${extra_args[@]}"
}
