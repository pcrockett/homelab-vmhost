#!/usr/bin/env blarg

depends_on clevis-installed

MARKER_FILE="${STATE_DIR}/${BLARG_TARGET_NAME}"

satisfied_if() {
  # there's no way to detect that tpm unlock has been setup without root privileges.
  # requiring root in `satisfied_if` is bad practice, so we use a "marker file" /
  # timestamp approach to determine if this has been setup or not.
  test -f "${MARKER_FILE}" \
    && [ "$(file_timestamp "${MARKER_FILE}")" -gt "$(file_timestamp "${BLARG_TARGET_PATH}")" ]
}

apply() {
  lsblk --filter 'TYPE == "crypt"' --output PKNAME --noheadings \
    | sort --unique \
    | while IFS= read -r device_name; do
      echo "${DISK_ENCRYPTION_PASSWORD}" | as_root clevis luks bind -k - -d "/dev/${device_name}" tpm2 '{}'
    done

  as_root update-initramfs -u -k all

  mkdir --parent "$(dirname "${MARKER_FILE}")"
  touch "${MARKER_FILE}"
}
