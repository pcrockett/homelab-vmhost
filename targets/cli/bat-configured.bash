#!/usr/bin/env blarg

REPO_PATH="${BLARG_MODULE_DIR}/config/bat/config"
SYSTEM_PATH=~/.config/bat/config

satisfied_if() {
  files_are_same "${REPO_PATH}" "${SYSTEM_PATH}"
}

apply() {
  rm -rf "${SYSTEM_PATH}"
  mkdir -p "$(dirname "${SYSTEM_PATH}")"
  install --mode u=rw,g=r,o=r "${REPO_PATH}" "${SYSTEM_PATH}"
}
