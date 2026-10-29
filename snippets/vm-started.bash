VM_NAME="${VM_NAME:?must specify vm name}"

is_up() {
  incus exec "${VM_NAME}" -- true &>/dev/null
}

satisfied_if() {
  is_up
}

apply() {
  incus start "${VM_NAME}"

  local state="waiting"
  for _ in $(seq 30); do
    sleep 1
    if is_up; then
      state="up"
      break
    fi
  done

  test "${state}" == "up" || panic "${VM_NAME} startup timed out."
}
