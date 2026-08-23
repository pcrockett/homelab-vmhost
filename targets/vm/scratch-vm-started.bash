#!/usr/bin/env blarg

depends_on scratch-vm-created

VM_NAME=scratch

satisfied_if() {
  incus info "${VM_NAME}" | grep --fixed-strings --line-regexp "Status: RUNNING"
}

apply() {
  incus start "${VM_NAME}"
}
