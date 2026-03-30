#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables appear unused, but are used inside snippet

# an important tool for safely running commands like `apt upgrade` via SSH. if the
# connection dies, the process will live on.
#
# use `screen -R` to reconnect to a previously started session.

PACKAGES=(
  screen
)

snippet "packages-installed"
