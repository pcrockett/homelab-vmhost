#!/usr/bin/env blarg
#
# see [ref:zabbly-readme]
#

depends_on core/with-umask-installed

KEY_REPO_PATH="${REPO_CONFIG_DIR}/zabbly/zabbly.asc"
KEY_SYSTEM_PATH=/etc/apt/keyrings/zabbly.asc
SOURCE_SYSTEM_PATH="/etc/apt/sources.list.d/zabbly-kernel-stable.sources"

satisfied_if() {
  files_are_same "${KEY_REPO_PATH}" "${KEY_SYSTEM_PATH}" \
    && test "$(cat "${SOURCE_SYSTEM_PATH}")" == "$(render_source)"
}

apply() {
  as_root mkdir --parents \
    "$(dirname "${KEY_SYSTEM_PATH}")" \
    "$(dirname "${SOURCE_SYSTEM_PATH}")"

  as_root install --mode u=rw,g=r,o=r "${KEY_REPO_PATH}" "${KEY_SYSTEM_PATH}"
  render_source | as_root with-umask u=rw,g=r,o=r dd of="${SOURCE_SYSTEM_PATH}" status=none
  satisfy core/apt-updated
}

render_source() {
  cat <<EOF
Enabled: yes
Types: deb
URIs: https://pkgs.zabbly.com/kernel/stable
Suites: $(. /etc/os-release && echo "${VERSION_CODENAME}")
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: ${KEY_SYSTEM_PATH}
EOF
}
