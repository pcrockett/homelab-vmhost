#!/usr/bin/env blarg

depends_on core/with-umask-installed bitwarden/cli-installed

MARKER_FILE="${STATE_DIR}/${BLARG_TARGET_NAME}"
FILE_NAME="config.sh"
REPO_CONFIG_DIR="${BLARG_CWD}/config/backup"
SYSTEM_CONFIG_DIR="/etc/backup"

satisfied_if() {
  test -f "${MARKER_FILE}"
  marker_timestamp="$(file_timestamp "${MARKER_FILE}")"
  [ "${marker_timestamp}" -gt "$(file_timestamp "${BLARG_TARGET_PATH}")" ] \
    && [ "${marker_timestamp}" -gt "$(file_timestamp "${REPO_CONFIG_DIR}/${FILE_NAME}.template")" ]
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.lab01

  RESTIC_E2EE_PASSWORD="$(bw_value backup.e2ee-password)" \
  AWS_ACCESS_KEY_ID="$(bw_value backup.aws-access-key.id)" \
  AWS_SECRET_ACCESS_KEY="$(bw_value backup.aws-access-key.secret)" \
  S3_REPOSITORY_URL="$(bw_value backup.s3-repository-url)" \
  EXTERNAL_FILESYSTEM_UUID="$(bw_value backup.external-fs-uuid)" \
    template_render "${REPO_CONFIG_DIR}/${FILE_NAME}.template"

  as_root with-umask u=rwx,g=,o= mkdir --parent "${SYSTEM_CONFIG_DIR}"
  as_root with-umask u=rw,g=,o= cp "${REPO_CONFIG_DIR}/${FILE_NAME}" "${SYSTEM_CONFIG_DIR}"

  # remove the generated file, just to reduce the amount of secrets lying around
  rm "${REPO_CONFIG_DIR}/${FILE_NAME}"

  mkdir --parent "$(dirname "${MARKER_FILE}")"
  touch "${MARKER_FILE}"
}
