#!/usr/bin/env blarg

depends_on packages-installed

REPO_CONFIG="${REPO_CONFIG_DIR}/libvirt/network.conf"
SYSTEM_CONFIG=/etc/libvirt/network.conf

satisfied_if() {
  files_are_same "${REPO_CONFIG}" "${SYSTEM_CONFIG}"
}

apply() {
  as_root install --mode=u=rw,g=r,o=r "${REPO_CONFIG}" "${SYSTEM_CONFIG}"
  # Restart libvirtd to pick up the new firewall backend
  as_root systemctl restart libvirtd
}
