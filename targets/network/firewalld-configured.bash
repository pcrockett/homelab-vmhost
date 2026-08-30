#!/usr/bin/env blarg

depends_on firewalld-installed

SYSTEM_FIREWALLD_CONF=/etc/firewalld/firewalld.conf
SYSTEM_ZONES_DIR=/etc/firewalld/zones
REPO_FIREWALLD_DIR="${REPO_CONFIG_DIR}/network/firewalld"

# Zone files to install
ZONE_FILES=(
  trusted
  home
  libvirt
  incus
  tailscale
)

satisfied_if() {
  files_are_same "${REPO_FIREWALLD_DIR}/firewalld.conf" "${SYSTEM_FIREWALLD_CONF}" || return 1
  for zone in "${ZONE_FILES[@]}"; do
    files_are_same "${REPO_FIREWALLD_DIR}/zones/${zone}.xml" "${SYSTEM_ZONES_DIR}/${zone}.xml" || return 1
  done
}

apply() {
  as_root install --mode=u=rw,g=r,o=r "${REPO_FIREWALLD_DIR}/firewalld.conf" "${SYSTEM_FIREWALLD_CONF}"
  for zone in "${ZONE_FILES[@]}"; do
    as_root install --mode=u=rw,g=r,o=r "${REPO_FIREWALLD_DIR}/zones/${zone}.xml" "${SYSTEM_ZONES_DIR}/${zone}.xml"
  done

  # Reload firewalld if running, otherwise it will pick up config on start
  if as_root systemctl is-active --quiet firewalld.service; then
    as_root firewall-cmd --reload
  fi
}
