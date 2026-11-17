# define the following before rendering this snippet:
#
# * VM_NAME: name of the incus virtual machine
#

satisfied_if() {
  vm_run pacman --query tailscale
}

apply() {
  vm_run pacman -Syu --needed --noconfirm tailscale
}
