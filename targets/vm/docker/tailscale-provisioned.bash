#!/usr/bin/env blarg

depends_on tailscale-installed

satisfied_if() {
  docker_run tailscale status
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.docker
  TS_AUTH_KEY="$(bw_value tailscale.auth-key)"

  docker_run systemctl enable --now tailscaled.service
  docker_run tailscale up --ssh --auth-key="${TS_AUTH_KEY}"
}

docker_run() {
  incus exec docker -- "$@"
}
