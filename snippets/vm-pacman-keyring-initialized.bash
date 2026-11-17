# define the following before rendering this snippet:
#
# * VM_NAME: name of the incus virtual machine
#

MARKER_FILE="/opt/pacman-keyring-initialized"

satisfied_if() {
  vm_run test -f "${MARKER_FILE}"
}

apply() {
  vm_run pacman -Sy --needed --noconfirm archlinux-keyring
  vm_run pacman-key --populate archlinux
  vm_run touch "${MARKER_FILE}"
}
