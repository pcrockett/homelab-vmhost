#!/usr/bin/env blarg
#
# firewall the VM host away from the VMs: block all VM traffic to the host's
# bridge-facing addresses (the incus bridge gateway and the libvirt default
# network gateway, v4 and v6).
#
# DHCP and DNS (and IPv6 router advertisements) to the host are incus
# "baseline service rules" that run before ACL rules, so a blanket block
# leaves the network fully functional.
#
# the ACL is attached to the incus network itself, not to any VM's NIC:
# network-level ACL chains apply to every VM on the bridge, coexist with
# per-NIC ACLs like scratch-isolation, and re-render live without
# restarting VMs.

depends_on incus-initialized libvirtd-enabled

ACL_NAME="host-isolation"
ACL_TEMPLATE="${REPO_CONFIG_DIR}/incus/host-isolation-acl.yaml.template"
ACL_RENDERED="${REPO_CONFIG_DIR}/incus/host-isolation-acl.yaml"

incus_host() {
  # `ipv4.address` and `ipv6.address` are the bridge's own (gateway)
  # addresses, like 10.154.100.1/24; narrow to the single host address
  local ip_version="${1}" host_bits="${2}"
  incus network get incusbr0 "ipv${ip_version}.address" \
    | awk -F/ -v host_bits="/${host_bits}" '
        NF == 2 {
          print $1 host_bits
          count++
        }
        END {
          exit count != 1
        }
      '
}

libvirt_host() {
  # virbr0 is the bridge libvirt's default network runs on
  ip -4 -o addr show dev virbr0 scope global \
    | awk '
        $3 == "inet" {
          split($4, parts, "/")
          print parts[1] "/32"
          count++
        }
        END {
          exit count != 1
        }
      '
}

satisfied_if() {
  local incus_v4 incus_v6 libvirt_v4 acl_yaml pattern
  incus_v4="$(incus_host 4 32)" || return 1
  incus_v6="$(incus_host 6 128)" || return 1
  libvirt_v4="$(libvirt_host)" || return 1
  acl_yaml="$(incus network acl show "${ACL_NAME}")"
  for pattern in \
    "destination: ${incus_v4}" \
    "destination: ${incus_v6}" \
    "destination: ${libvirt_v4}" \
    "protocol: tcp" \
    "protocol: udp" \
    "protocol: icmp4" \
    "protocol: icmp6"; do
    printf '%s\n' "${acl_yaml}" | grep --quiet --fixed-strings "${pattern}" || return 1
  done
  # the ACL must also be attached to the network. the default actions are
  # required: an unset default action rejects all other VM traffic
  [ "$(incus network get incusbr0 security.acls)" = "${ACL_NAME}" ] || return 1
  [ "$(incus network get incusbr0 security.acls.default.ingress.action)" = "allow" ] || return 1
  [ "$(incus network get incusbr0 security.acls.default.egress.action)" = "allow" ] || return 1
}

apply() {
  local incus_v4 incus_v6 libvirt_v4
  incus_v4="$(incus_host 4 32)" \
    || panic "could not detect the incus bridge IPv4 host address"
  incus_v6="$(incus_host 6 128)" \
    || panic "could not detect the incus bridge IPv6 host address"
  libvirt_v4="$(libvirt_host)" \
    || panic "could not unambiguously detect the libvirt host address on virbr0"

  # `create` and `edit` both read the rules from stdin; `edit` doubles as
  # the already-exists case
  INCUS_V4="${incus_v4}" INCUS_V6="${incus_v6}" LIBVIRT_V4="${libvirt_v4}" \
    template_render "${ACL_TEMPLATE}"
  incus network acl create "${ACL_NAME}" <"${ACL_RENDERED}" \
    || incus network acl edit "${ACL_NAME}" <"${ACL_RENDERED}"
  rm "${ACL_RENDERED}"

  incus network set incusbr0 \
    "security.acls=${ACL_NAME}" \
    "security.acls.default.ingress.action=allow" \
    "security.acls.default.egress.action=allow"
}
