#!/usr/bin/env blarg

depends_on core/with-umask-installed

FILE_NAME="TODO.conf"
REPO_CONFIG_DIR="${BLARG_CWD}/config/TODO"
SYSTEM_CONFIG_DIR="/etc/TODO"

satisfied_if() {
  template_was_rendered "${REPO_CONFIG_DIR}/${FILE_NAME}.template" \
    && files_are_same "${REPO_CONFIG_DIR}/${FILE_NAME}" "${SYSTEM_CONFIG_DIR}/${FILE_NAME}"
}

apply() {
  template_render "${REPO_CONFIG_DIR}/${FILE_NAME}.template"
  as_root with-umask u=rwx,g=rx,o=rx mkdir --parent "${SYSTEM_CONFIG_DIR}"
  as_root with-umask u=rw,g=r,o=r cp "${REPO_CONFIG_DIR}/${FILE_NAME}" "${SYSTEM_CONFIG_DIR}"
}
