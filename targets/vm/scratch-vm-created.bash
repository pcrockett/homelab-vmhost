#!/usr/bin/env blarg

depends_on incus-initialized

# provision a disposable VM
VM_NAME=scratch

satisfied_if() {
  incus info "${VM_NAME}"
}

apply() {
  incus create images:archlinux "${VM_NAME}" --vm
}
