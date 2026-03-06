# shellcheck shell=bash

test "${HOMELAB_VHMOST_BASH_CONFIGURED:-}" = "1" \
  || source "${BLARG_MODULE_DIR}/config/bash/bashrc"
