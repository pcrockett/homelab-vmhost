#!/usr/bin/env blarg
#
# connect the host to the tailnet with the tailscale ssh server enabled.
# sshd-disabled depends on this: with sshd off, tailscale ssh is the only
# remote way in.

depends_on tailscale-installed core/jq-installed

satisfied_if() {
  # daemon down: `debug prefs` fails entirely. logged out, `tailscale down`,
  # or up without `--ssh`: the jq expression evaluates false
  tailscale debug prefs \
    | jq --exit-status '.RunSSH == true and .WantRunning == true and .LoggedOut == false'
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.lab01
  TS_AUTH_KEY="$(bw_value tailscale.auth-key)"

  as_root systemctl enable --now tailscaled.service
  as_root tailscale up --ssh --auth-key="${TS_AUTH_KEY}"
}
