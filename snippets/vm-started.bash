VM_NAME="${VM_NAME:?must specify vm name}"

satisfied_if() {
  incus info "${VM_NAME}" | grep --fixed-strings --line-regexp "Status: RUNNING"
}

apply() {
  incus start "${VM_NAME}"
  sleep 10 # TODO: poll until it's up and ready?
}
