# shellcheck shell=bash

BW_SESSION_FILE="${BLARG_RUN_DIR}/.bw-session"

bw_unlock() {
  # interactively unlock the bitwarden vault
  bw unlock --raw </dev/tty >"${BW_SESSION_FILE}"
  BW_SESSION="$(cat "${BW_SESSION_FILE}")"
  if [ "${BW_SESSION}" == "" ]; then
    rm -f "${BW_SESSION_FILE}"
    panic "Unlock failed."
  fi
  export BW_SESSION
}

bw_session() {
  if [ ! -f "${BW_SESSION_FILE}" ]; then
    panic "Call \`bw_unlock\` first."
  fi

  BW_SESSION="$(cat "${BW_SESSION_FILE}")"
  export BW_SESSION
}

load_bw_item() {
  # load a bitwarden entry into memory, to get values out of with `bw_value`
  # needs these targets to work:
  #
  # * bitwarden/synced
  #
  # see `email/aerc-configured` for example how to use this
  bw_session
  BITWARDEN_ITEM_JSON="$(bw get item "${1}")"
}

bw_value() {
  # get values out of a previously-loaded bitwarden item.
  #
  # assumes you've already called `load_bw_item`
  #
  # needs these targets to work:
  #
  # * core/jq-installed
  #
  # see `email/aerc-configured` for example how to use this
  key="${1}"
  echo "${BITWARDEN_ITEM_JSON}" | jq --raw-output "
    .fields | map(
      select(.name == \"${key}\")
    )[].value"
}

bw_username() {
  # get login username out of a previously-loaded bitwarden item.
  #
  # assumes you've already called `load_bw_item`
  #
  # needs these targets to work:
  #
  # * core/jq-installed
  #
  echo "${BITWARDEN_ITEM_JSON}" | jq --raw-output ".login.username"
}

bw_password() {
  # get login password out of a previously-loaded bitwarden item.
  #
  # assumes you've already called `load_bw_item`
  #
  # needs these targets to work:
  #
  # * core/jq-installed
  #
  echo "${BITWARDEN_ITEM_JSON}" | jq --raw-output ".login.password"
}
