#!/usr/bin/env blarg
# [tag:vm/networks-isolated]
#
# See [ref:vm/networking-strategy]

depends_on networks-created

ACL_NAME="network-isolation"
ACL_FILE="${REPO_CONFIG_DIR}/incus/network-isolation.yaml"

satisfied_if() {
  checkpoint_is_current "${ACL_FILE}"
}

apply() {
  local network
  # `create` and `edit` both read the rules from stdin; `edit` doubles as
  # the already-exists case
  incus network acl create "${ACL_NAME}" <"${ACL_FILE}" \
    || incus network acl edit "${ACL_NAME}" <"${ACL_FILE}"

  for network in "${VM_ALL_NETWORKS[@]}"; do
    incus network set "${network}" \
      "security.acls=${ACL_NAME}" \
      "security.acls.default.ingress.action=drop" \
      "security.acls.default.egress.action=drop"
  done

  checkpoint_success
}
