# shellcheck shell=bash

install_package() {
  # if you call this function, make sure your target depends on [ref:core/apt-updated]
  as_root apt-get install --yes --no-install-recommends "${@}"
}

package_is_installed() {
  dpkg --status "${@}" &>/dev/null
}
