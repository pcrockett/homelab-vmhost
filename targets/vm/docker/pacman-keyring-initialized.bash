#!/usr/bin/env blarg

depends_on vm-started

MARKER_FILE="/opt/pacman-keyring-initialized"

satisfied_if() {
  docker_run test -f "${MARKER_FILE}"
}

apply() {
  docker_run pacman -Sy --needed --noconfirm archlinux-keyring
  docker_run pacman-key --populate archlinux
  docker_run touch "${MARKER_FILE}"
}

docker_run() {
  incus exec docker -- "$@"
}
