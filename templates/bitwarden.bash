#!/usr/bin/env blarg

depends_on core/with-umask-installed bitwarden/cli-installed

FILE_NAME="TODO"
REPO_CONFIG_DIR="${BLARG_CWD}/config/TODO"
SYSTEM_CONFIG_DIR="${HOME}/.config/TODO"

satisfied_if() {
  template_was_rendered "${REPO_CONFIG_DIR}/${FILE_NAME}.template" \
    && files_are_same "${REPO_CONFIG_DIR}/${FILE_NAME}" "${SYSTEM_CONFIG_DIR}/${FILE_NAME}"
}

apply() {
  satisfy bitwarden/synced
  load_bw_item lab01.backup

  SECRET_VALUE="$(bw_value secret-attribute)" \
    template_render "${REPO_CONFIG_DIR}/${FILE_NAME}.template"
  with-umask u=rw,g=,o= cp "${REPO_CONFIG_DIR}/${FILE_NAME}" "${SYSTEM_CONFIG_DIR}"
}
