#!/usr/bin/env bash
set -euo pipefail

# -t: allocate tty for interactivity
tailscale ssh "${SSH_DEST}" -t -- "$@"
