# shellcheck shell=bash

snippet() {
  local snippet_name="${1:?must specify snippet name}"

  # shellcheck source=/dev/null
  source "${BLARG_CWD}/snippets/${snippet_name}.bash"
}
