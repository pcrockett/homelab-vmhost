#!/usr/bin/env blarg
#
# every scripted way into this host goes through tailscale ssh, so sshd has no
# reason to listen — least of all on the VM-facing bridges. in an emergency:
# use the console, then `systemctl enable --now ssh.service`.

depends_on tailscale-provisioned

satisfied_if() {
  ! systemctl is-enabled --quiet ssh.service && ! systemctl is-active --quiet ssh.service
}

apply() {
  as_root systemctl disable --now ssh.service
}
