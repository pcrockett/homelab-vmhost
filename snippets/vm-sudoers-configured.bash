# define the following before rendering this snippet:
#
# * VM_NAME: name of the incus virtual machine
#

SUDOERS_FILE="/etc/sudoers.d/00_${USER}"
SUDOERS_RULE="${USER} ALL=(ALL) NOPASSWD: ALL"

satisfied_if() {
  vm_run grep --quiet --fixed-strings "${SUDOERS_RULE}" "${SUDOERS_FILE}"
}

apply() {
  printf '%s\n' "${SUDOERS_RULE}" | vm_run tee "${SUDOERS_FILE}"
  vm_run chmod 0440 "${SUDOERS_FILE}"
  vm_run visudo --check --file "${SUDOERS_FILE}"
  # tee exits cleanly even if nothing comes through the incus stdin pipe, so
  # verify the rule actually landed
  vm_run grep --quiet --fixed-strings "${SUDOERS_RULE}" "${SUDOERS_FILE}"
}
