#!/usr/bin/env bash
#
# open an SSH session on the server, wrapped in `screen` to protect from unexpected
# network errors. logs the session at `~/screenlog.0` on the server.
#
# if logging the session is not desired, set HOMELAB_SCREEN_LOGGING=disabled
#
set -euo pipefail

# -U: run in unicode mode
SCREEN_ARGS=(-U)
if [ "${HOMELAB_SCREEN_LOGGING:-enabled}" = "enabled" ]; then
  # -L: turn on output logging (saves output on server to ~/screenlog.0)
  SCREEN_ARGS+=(-L)
fi

./bin/tailscale-ssh.sh screen "${SCREEN_ARGS[@]}" "$@"
