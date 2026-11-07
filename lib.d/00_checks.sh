# shellcheck shell=bash

if [ "$(id --user)" -eq 0 ]; then
  panic "Don't run this as root."
fi

HOMELAB_HOSTNAME=lab01
# guest VM applies (see targets/vm/proxy/guest-applied.bash) drop this marker
# into the tarred repo tree before running blarg inside the VM, where the
# hostname check does not apply
if [ ! -f "${BLARG_MODULE_DIR}/.blarg/guest-vm" ] \
  && [ "$(hostnamectl hostname)" != "${HOMELAB_HOSTNAME}" ]; then
  panic "Don't run this on any machine except ${HOMELAB_HOSTNAME}!"
fi
