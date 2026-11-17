# define the following before rendering this snippet:
#
# * VM_NAME: name of the incus virtual machine
#

satisfied_if() {
  vm_run id --user "${USER}"
  vm_run test -d "/home/${USER}"
}

apply() {
  vm_run useradd --create-home "${USER}"
}
