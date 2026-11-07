#!/usr/bin/env blarg

depends_on tailscale-installed

satisfied_if() {
  proxy_run tailscale status
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.proxy
  TS_AUTH_KEY="$(bw_value tailscale.auth-key)"

  proxy_run systemctl enable --now tailscaled.service
  # tag:trusted must exist and the auth key must be pre-authorized for it in the
  # tailscale admin console
  proxy_run tailscale up --ssh --auth-key="${TS_AUTH_KEY}" --advertise-tags=tag:trusted
}

proxy_run() {
  incus exec proxy -- "$@"
}
