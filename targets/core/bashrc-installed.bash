#!/usr/bin/env blarg

REPO_PATH="${REPO_CONFIG_DIR}/bash/bashrc"
SYSTEM_PATH="${HOME}/.config/homelab/bashrc"

satisfied_if() {
  files_are_same "${REPO_PATH}" "${SYSTEM_PATH}"
}

apply() {
  mkdir -p "$(dirname "${SYSTEM_PATH}")"
  rm -f "${SYSTEM_PATH}"
  install --mode u=rw,g=r,o=r "${REPO_PATH}" "${SYSTEM_PATH}"
}
