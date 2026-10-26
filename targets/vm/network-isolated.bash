#!/usr/bin/env blarg
#
# default-deny network policy for every managed incus bridge: VMs get the
# internet and tailscale, nothing else. attached at the network level, so
# every VM on the bridge is covered with no per-NIC config; VMs on
# different bridges can't reach each other because cross-bridge traffic is
# routed, which these egress drops filter.
#
# incus evaluates ACL drops before allows, so the tailscale carve-out is a
# narrowed drop and the internet allowances are protocol-scoped allows over
# a drop-by-default action — which also catches v4 protocols the ACL
# vocabulary can't express. DHCP and DNS to the VM's own bridge gateway are
# incus "baseline service rules" that run before ACL rules, so they keep
# working.

depends_on networks-created

ACL_NAME="network-isolation"
ACL_FILE="${REPO_CONFIG_DIR}/incus/network-isolation.yaml"
# every managed incus bridge gets the policy
INCUS_NETWORKS=(incusbr0 "${VM_SCRATCH_NETWORK}")

satisfied_if() {
  checkpoint_is_current "${ACL_FILE}"
}

apply() {
  local network
  # `create` and `edit` both read the rules from stdin; `edit` doubles as
  # the already-exists case
  incus network acl create "${ACL_NAME}" <"${ACL_FILE}" \
    || incus network acl edit "${ACL_NAME}" <"${ACL_FILE}"

  for network in "${INCUS_NETWORKS[@]}"; do
    incus network set "${network}" \
      "security.acls=${ACL_NAME}" \
      "security.acls.default.ingress.action=drop" \
      "security.acls.default.egress.action=drop"
  done

  checkpoint_success
}
