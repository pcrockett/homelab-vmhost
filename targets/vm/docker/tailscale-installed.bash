#!/usr/bin/env blarg

depends_on vm-started pacman-keyring-initialized

satisfied_if() {
  docker_run pacman --query tailscale
}

apply() {
  docker_run pacman -Syu --needed --noconfirm tailscale
}

docker_run() {
  incus exec docker -- "$@"
}
