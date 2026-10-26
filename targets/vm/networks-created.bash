#!/usr/bin/env blarg
#
# every incus bridge the VMs get provisioned on: one per VM, so VMs can
# only reach each other through routing, which the network-isolation ACL
# drops. IPv6 is disabled on these bridges: the ACL drops it anyway, and
# this way the VMs never get a v6 address.

depends_on incus-initialized

satisfied_if() {
  local ipv4 ipv6
  ipv4="$(incus network get "${VM_SCRATCH_NETWORK}" ipv4.address)" || return 1
  [ -n "${ipv4}" ] || return 1
  ipv6="$(incus network get "${VM_SCRATCH_NETWORK}" ipv6.address)" || return 1
  [ "${ipv6}" = "none" ]
}

apply() {
  # `auto` resolves to a concrete subnet at create time, and everything
  # downstream detects the subnet at runtime, so the fallback only
  # re-asserts the IPv6 disable
  incus network create "${VM_SCRATCH_NETWORK}" ipv4.address=auto ipv6.address=none \
    || incus network set "${VM_SCRATCH_NETWORK}" ipv6.address=none
}
