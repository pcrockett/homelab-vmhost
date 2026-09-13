#!/usr/bin/env blarg

INSTALL_LOCATION="${HOME}/.config/homelab/bashrc"
LINE_TO_ADD="source '${INSTALL_LOCATION}'"

depends_on bashrc-installed

satisfied_if() {
  grep --quiet --fixed-strings "${LINE_TO_ADD}" ~/.bashrc
}

apply() {
  echo "${LINE_TO_ADD}" >>~/.bashrc
  echo "Bash successfully configured. Source ~/.bashrc or logout and back in again."
}
