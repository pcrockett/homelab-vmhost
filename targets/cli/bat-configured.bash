#!/usr/bin/env blarg

REPO_PATH="${BLARG_MODULE_DIR}/config/bat"
SYSTEM_PATH=~/.config/bat

satisfied_if() {
  files_are_same "${REPO_PATH}" "${SYSTEM_PATH}"
}

apply() {
  rm -rf "${SYSTEM_PATH}"
  install "${REPO_PATH}" "${SYSTEM_PATH}"
}
