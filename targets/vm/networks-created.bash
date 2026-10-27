#!/usr/bin/env blarg
# [tag:vm/networks-created]
#
# See [ref:vm/networking-strategy]

depends_on incus-initialized

satisfied_if() {
  local ipv4 ipv6 net_name
  for net_name in "${VM_ALL_NETWORKS[@]}"; do
    ipv4="$(incus network get "${net_name}" ipv4.address)" || return 1
    [ -n "${ipv4}" ] || return 1
    ipv6="$(incus network get "${net_name}" ipv6.address)" || return 1
    [ "${ipv6}" = "none" ] || return 1
  done
}

apply() {
  local net_name
  for net_name in "${VM_ALL_NETWORKS[@]}"; do
    incus network create "${net_name}" ipv4.address=auto ipv6.address=none \
      || incus network set "${net_name}" ipv6.address=none
  done
}
