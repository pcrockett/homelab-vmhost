#!/usr/bin/env blarg

SYSTEM_BLARG="/usr/local/bin/blarg"
REPO_BLARG="${REPO_BIN_DIR}/blarg"

satisfied_if() {
  files_are_same "${REPO_BLARG}" "${SYSTEM_BLARG}"
}

apply() {
  as_root install "${REPO_BLARG}" "${SYSTEM_BLARG}"
}
