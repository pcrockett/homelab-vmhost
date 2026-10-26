#!/usr/bin/env blarg
#
# keep the scratch VM off the physical wifi network, and off IPv6, with one
# carve-out: tailscale's direct peer connections (UDP 41641).
#
# incus evaluates ACL drop rules before allow rules, so the carve-out can't
# be an allow rule alongside a broad drop. it's expressed as protocol-scoped
# drops that don't match UDP 41641, letting it fall through to the NIC's
# default egress action (allow). incus's ACL protocol vocabulary is only
# tcp/udp/icmp4/icmp6, so other v4 protocols can't be dropped without also
# blocking the carve-out.
#
# enforced with an incus network ACL attached to the VM's NIC; incus renders
# the corresponding nftables rules on the host.

depends_on vm-created

VM_NAME=scratch
ACL_NAME="scratch-isolation"
ACL_TEMPLATE="${REPO_CONFIG_DIR}/incus/isolation-acl.yaml.template"
ACL_RENDERED="${REPO_CONFIG_DIR}/incus/isolation-acl.yaml"
# keep in sync with [ref:interface-config]
WIFI_IFACE="wlp2s0"

wifi_subnet() {
  # don't filter on `proto kernel` / `proto dhcp`: that label depends on
  # which component installed the route, and differs between DHCP clients.
  # host routes like the gateway print without a slash, so the slash filter
  # excludes them.
  ip -4 route show dev "${WIFI_IFACE}" scope link \
    | awk '
      $1 ~ /\// {
        count++
        subnet = $1
      }
      END {
        if (count == 1) {
          print subnet
        } else {
          exit 1
        }
      }
    '
}

satisfied_if() {
  local subnet acl_yaml pattern
  subnet="$(wifi_subnet)"
  acl_yaml="$(incus network acl show "${ACL_NAME}")"
  for pattern in \
    "destination: ${subnet}" \
    "protocol: tcp" \
    "protocol: icmp4" \
    "protocol: udp" \
    "0-41640" \
    "41642-65535" \
    "destination: ::/0" \
    "source: ::/0"; do
    printf '%s\n' "${acl_yaml}" | grep --quiet --fixed-strings "${pattern}" || return 1
  done
  # the ACL must also be attached to the VM's NIC. `incus config device get`
  # fails for profile-inherited devices, so grep the instance's local device
  # override instead.
  incus config show "${VM_NAME}" | grep --quiet --fixed-strings "security.acls: ${ACL_NAME}"
}

apply() {
  local subnet acl_keys
  subnet="$(wifi_subnet)" \
    || panic "could not unambiguously detect the wifi subnet on ${WIFI_IFACE}"

  # `create` and `edit` both read the rules from stdin; `edit` doubles as
  # the already-exists case (e.g. the VM was destroyed and recreated).
  WIFI_SUBNET="${subnet}" template_render "${ACL_TEMPLATE}"
  incus network acl create "${ACL_NAME}" <"${ACL_RENDERED}" \
    || incus network acl edit "${ACL_NAME}" <"${ACL_RENDERED}"
  rm "${ACL_RENDERED}"

  # the default actions are required: for bridged NICs they default to
  # `drop`, which would cut the VM off from everything else
  acl_keys=(
    "security.acls=${ACL_NAME}"
    "security.acls.default.ingress.action=allow"
    "security.acls.default.egress.action=allow"
  )
  # `override` only works the first time (the device is otherwise inherited
  # from the default profile); `set` re-asserts an existing override
  incus config device override "${VM_NAME}" eth0 "${acl_keys[@]}" \
    || incus config device set "${VM_NAME}" eth0 "${acl_keys[@]}"

  # ACL rules are only rendered when the NIC starts
  if incus info "${VM_NAME}" | grep --fixed-strings --line-regexp "Status: RUNNING"; then
    echo "WARNING: ${VM_NAME} is running; the ACL won't apply until it is restarted" >&2
  fi
}
