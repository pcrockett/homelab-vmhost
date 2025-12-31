# shellcheck shell=bash

if [ "$(id --user)" -eq 0 ]; then
  panic "Don't run this as root."
fi
