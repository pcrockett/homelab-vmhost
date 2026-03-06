#!/usr/bin/env blarg

REPO_PATH="${BLARG_MODULE_DIR}/config/TODO"
SYSTEM_PATH=~/.config/TODO

satisfied_if() {
  test_symlink "${REPO_PATH}" "${SYSTEM_PATH}"
}

apply() {
  rm -rf "${SYSTEM_PATH}"
  ln --symbolic "${REPO_PATH}" "${SYSTEM_PATH}"
}
