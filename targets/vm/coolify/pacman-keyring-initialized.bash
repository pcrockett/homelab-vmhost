#!/usr/bin/env blarg

depends_on vm-started

MARKER_FILE="/opt/pacman-keyring-initialized"

satisfied_if() {
  coolify_run test -f "${MARKER_FILE}"
}

apply() {
  coolify_run pacman -Sy --needed --noconfirm archlinux-keyring
  coolify_run pacman-key --populate archlinux
  coolify_run touch "${MARKER_FILE}"
}

coolify_run() {
  incus exec coolify -- "$@"
}
