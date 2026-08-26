VM_NAME="${VM_NAME:?must specify vm name}"

depends_on "${VM_NAME}-vm-created"

satisfied_if() {
  incus info "${VM_NAME}" | grep --fixed-strings --line-regexp "Status: RUNNING"
}

apply() {
  incus start "${VM_NAME}"
  sleep 5 # TODO: poll until it's up and ready?
}
