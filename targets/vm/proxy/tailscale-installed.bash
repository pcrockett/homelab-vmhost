#!/usr/bin/env blarg

depends_on vm-started

satisfied_if() {
  proxy_run pacman --query tailscale
}

apply() {
  proxy_run pacman -Syu --needed --noconfirm tailscale
}

proxy_run() {
  incus exec proxy -- "$@"
}
