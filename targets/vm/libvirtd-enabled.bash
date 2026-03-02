#!/usr/bin/env blarg

UNIT="libvirtd.service"

depends_on packages-installed libvirt-network-configured

satisfied_if() {
  test "$(systemctl is-enabled "${UNIT}")" = "enabled" \
    && test "$(systemctl is-active "${UNIT}")" = "active"
}

apply() {
  as_root systemctl enable --now "${UNIT}"
}
