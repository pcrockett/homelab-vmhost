#!/usr/bin/env blarg

depends_on core/with-umask-installed bitwarden/cli-installed

MARKER_FILE="${STATE_DIR}/${BLARG_TARGET_NAME}"
FILE_NAME="wlan-interface"
REPO_CONFIG_DIR="${BLARG_CWD}/config/network"
SYSTEM_CONFIG_DIR="/etc/network/interfaces.d"

satisfied_if() {
  test -f "${MARKER_FILE}"
  marker_timestamp="$(file_timestamp "${MARKER_FILE}")"
  [ "${marker_timestamp}" -gt "$(file_timestamp "${BLARG_TARGET_PATH}")" ] \
    && [ "${marker_timestamp}" -gt "$(file_timestamp "${REPO_CONFIG_DIR}/${FILE_NAME}.template")" ]
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.lab01

  WLAN_SSID="$(bw_value wlan.ssid)" \
  WLAN_PASSWORD="$(bw_value wlan.password)" \
    template_render "${REPO_CONFIG_DIR}/${FILE_NAME}.template"
  as_root with-umask u=rw,g=,o= cp "${REPO_CONFIG_DIR}/${FILE_NAME}" "${SYSTEM_CONFIG_DIR}"
  rm "${REPO_CONFIG_DIR}/${FILE_NAME}"
  mkdir --parent "$(dirname "${MARKER_FILE}")"
  touch "${MARKER_FILE}"
}
