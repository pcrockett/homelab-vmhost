#!/usr/bin/env blarg

depends_on vm-started pacman-keyring-initialized

satisfied_if() {
  coolify_run pacman --query tailscale
}

apply() {
  coolify_run pacman -Syu --needed --noconfirm tailscale
}

coolify_run() {
  incus exec coolify -- "$@"
}
