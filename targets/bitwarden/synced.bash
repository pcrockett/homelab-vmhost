#!/usr/bin/env blarg

depends_on unlocked

apply() {
  # the unlock session is stored in a temp file so that it can be shared
  # between targets, since each target runs in its own process. if the vault
  # was already unlocked via an inherited BW_SESSION env var, there is no
  # session file and `bw sync` will use the env var directly.
  if [ -f "${BW_SESSION_FILE}" ]; then
    bw_session
  fi
  bw sync
}
