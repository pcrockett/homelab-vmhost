#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables used inside snippet
#
# provision a disposable VM
#

VM_NAME=scratch
NIC_NETWORK="${VM_SCRATCH_NETWORK}"
snippet vm-created
