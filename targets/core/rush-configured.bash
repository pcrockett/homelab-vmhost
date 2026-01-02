#!/usr/bin/env blarg

depends_on bash-configured

satisfied_if() {
  test -d "${RUSH_ROOT}" && test -f "${RUSH_CONFIG}"
}

apply() {
  mkdir --parent "${RUSH_ROOT}"
  mkdir --parent "$(dirname "${RUSH_CONFIG}")"
  touch "${RUSH_CONFIG}"
}
