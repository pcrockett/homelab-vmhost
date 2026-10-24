#!/usr/bin/env blarg

depends_on tailscale-installed

satisfied_if() {
  scratch_run tailscale status
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.scratch
  TS_AUTH_KEY="$(bw_value tailscale.auth-key)"

  scratch_run systemctl enable --now tailscaled.service
  scratch_run tailscale up --ssh --auth-key="${TS_AUTH_KEY}"
}

scratch_run() {
  incus exec scratch -- "$@"
}
