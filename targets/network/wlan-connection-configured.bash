#!/usr/bin/env blarg

depends_on core/with-umask-installed bitwarden/cli-installed

FILE_NAME="wlan-interface"
REPO_CONFIG_DIR="${BLARG_CWD}/config/network"
SYSTEM_CONFIG_DIR="/etc/network/interfaces.d"

satisfied_if() {
  template_was_rendered "${REPO_CONFIG_DIR}/${FILE_NAME}.template" \
    && files_are_same "${REPO_CONFIG_DIR}/${FILE_NAME}" "${SYSTEM_CONFIG_DIR}/${FILE_NAME}"
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.lab01

  WLAN_SSID="$(bw_value wlan.ssid)" \
  WLAN_PASSWORD="$(bw_value wlan.password)" \
    template_render "${REPO_CONFIG_DIR}/${FILE_NAME}.template"
  as_root with-umask u=rw,g=,o= cp "${REPO_CONFIG_DIR}/${FILE_NAME}" "${SYSTEM_CONFIG_DIR}"
  rm "${REPO_CONFIG_DIR}/${FILE_NAME}"
}
