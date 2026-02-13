#!/usr/bin/env blarg

SOURCE_FILE="${REPO_CONFIG_DIR}/network/nftables.conf"
DEST_FILE="/etc/nftables.conf"

satisfied_if() {
  files_are_same "${DEST_FILE}" "${SOURCE_FILE}"
}

apply() {
  if [ ! -f "${DEST_FILE}.original" ]; then
    as_root cp "${DEST_FILE}" "${DEST_FILE}.original"
  fi
  as_root cp "${SOURCE_FILE}" "${DEST_FILE}"
}
