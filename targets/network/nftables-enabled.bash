#!/usr/bin/env blarg

UNIT="nftables.service"

depends_on nftables-installed firewall-configured

satisfied_if() {
  test "$(systemctl is-enabled "${UNIT}")" = "enabled" \
    && test "$(systemctl is-active "${UNIT}")" = "active"
}

apply() {
  as_root systemctl enable --now "${UNIT}"
}
