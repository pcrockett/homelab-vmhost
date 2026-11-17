# define the following before rendering this snippet:
#
# * VM_NAME: name of the incus virtual machine
#

satisfied_if() {
  vm_run tailscale status
}

apply() {
  satisfy bitwarden/synced
  load_bw_item "machine.${VM_NAME}"
  TS_AUTH_KEY="$(bw_value tailscale.auth-key)"

  vm_run systemctl enable --now tailscaled.service
  vm_run tailscale up --ssh --auth-key="${TS_AUTH_KEY}"
}
