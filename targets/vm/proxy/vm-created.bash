#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables used inside snippet
#
# high-trust reverse proxy VM. see doc/PROXY.md

VM_NAME=proxy
CPU_COUNT=2
MEMORY=1GiB
ROOT_DISK_SIZE=20GiB
NIC_NETWORK="${VM_PROXY_NETWORK}"
snippet vm-created
