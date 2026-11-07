#!/usr/bin/env blarg

depends_on user-created

SUDOERS_FILE="/etc/sudoers.d/00_${USER}"
SUDOERS_RULE="${USER} ALL=(ALL) NOPASSWD: ALL"

satisfied_if() {
  proxy_run grep --quiet --fixed-strings "${SUDOERS_RULE}" "${SUDOERS_FILE}"
}

apply() {
  printf '%s\n' "${SUDOERS_RULE}" | proxy_run tee "${SUDOERS_FILE}"
  proxy_run chmod 0440 "${SUDOERS_FILE}"
  proxy_run visudo --check --file "${SUDOERS_FILE}"
  # tee exits cleanly even if nothing comes through the incus stdin pipe, so
  # verify the rule actually landed
  proxy_run grep --quiet --fixed-strings "${SUDOERS_RULE}" "${SUDOERS_FILE}"
}

proxy_run() {
  incus exec proxy -- "$@"
}
