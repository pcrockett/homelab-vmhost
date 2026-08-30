#!/usr/bin/env blarg

UNIT="firewalld.service"

depends_on firewalld-configured

satisfied_if() {
  test "$(systemctl is-enabled "${UNIT}")" = "enabled" \
    && test "$(systemctl is-active "${UNIT}")" = "active"
}

apply() {
  as_root systemctl enable --now "${UNIT}"
}
