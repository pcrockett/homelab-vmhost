#!/usr/bin/env blarg

depends_on vm-started

satisfied_if() {
  scratch_run pacman --query tailscale
}

apply() {
  scratch_run pacman -Syu --needed --noconfirm tailscale
}

scratch_run() {
  incus exec scratch -- "$@"
}
