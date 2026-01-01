#!/usr/bin/env blarg

UNIT="screensaver.service"
REPO_PATH="${BLARG_CWD}/config/screensaver/${UNIT}"
SYSTEM_PATH="/etc/systemd/system/${UNIT}"

satisfied_if() {
  files_are_same "${REPO_PATH}" "${SYSTEM_PATH}" \
    && test "$(systemctl is-enabled "${UNIT}")" = "enabled" \
    && test "$(systemctl is-active "${UNIT}")" = "active"
}

apply() {
  as_root cp "${REPO_PATH}" "${SYSTEM_PATH}"
  as_root systemctl daemon-reload
  as_root systemctl enable --now screensaver
}
