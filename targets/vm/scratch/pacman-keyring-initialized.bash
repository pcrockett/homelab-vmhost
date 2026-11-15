#!/usr/bin/env blarg

depends_on vm-started

MARKER_FILE="/opt/pacman-keyring-initialized"

satisfied_if() {
  scratch_run test -f "${MARKER_FILE}"
}

apply() {
  scratch_run pacman -Sy --needed --noconfirm archlinux-keyring
  scratch_run pacman-key --populate archlinux
  scratch_run touch "${MARKER_FILE}"
}

scratch_run() {
  incus exec scratch -- "$@"
}
