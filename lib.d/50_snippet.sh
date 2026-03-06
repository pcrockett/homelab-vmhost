# shellcheck shell=bash

snippet() {
  local snippet_name="${1:?must specify snippet name}"

  # shellcheck source=/dev/null
  source "${BLARG_MODULE_DIR}/snippets/${snippet_name}.bash"
}
