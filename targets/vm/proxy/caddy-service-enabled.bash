#!/usr/bin/env blarg

depends_on caddyfile-configured

UNIT="caddy.service"

satisfied_if() {
  files_are_same "${REPO_CONFIG_DIR}/caddy/${UNIT}" "/etc/systemd/system/${UNIT}" \
    && test "$(systemctl is-enabled "${UNIT}")" = "enabled" \
    && test "$(systemctl is-active "${UNIT}")" = "active"
}

apply() {
  # the caddy binary delivery is still an open question (caddy-binary-delivered
  # stub, doc/PROXY.md); fail loudly rather than enabling a broken unit
  test -x /usr/local/bin/caddy \
    || panic "caddy binary missing at /usr/local/bin/caddy -- see doc/PROXY.md open questions"
  as_root cp "${REPO_CONFIG_DIR}/caddy/${UNIT}" "/etc/systemd/system/${UNIT}"
  as_root systemctl daemon-reload
  as_root systemctl enable --now "${UNIT}"
}
