# shellcheck shell=bash

if [ "$(id --user)" -eq 0 ]; then
  panic "Don't run this as root."
fi

HOMELAB_HOSTNAME=lab01
if [ "$(hostnamectl hostname)" != "${HOMELAB_HOSTNAME}" ]; then
  panic "Don't run this on any machine except ${HOMELAB_HOSTNAME}!"
fi
