#!/usr/bin/env blarg

depends_on tailscale-installed

satisfied_if() {
  coolify_run tailscale status
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.coolify
  TS_AUTH_KEY="$(bw_value tailscale.auth-key)"

  coolify_run systemctl enable --now tailscaled.service
  coolify_run tailscale up --ssh --auth-key="${TS_AUTH_KEY}"
}

coolify_run() {
  incus exec coolify -- "$@"
}
