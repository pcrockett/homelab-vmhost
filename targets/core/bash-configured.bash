#!/usr/bin/env blarg

LINE_TO_ADD="source '${BLARG_CWD}/config/bash/bashrc'"

satisfied_if() {
  grep --quiet --fixed-strings "${LINE_TO_ADD}" ~/.bashrc
}

apply() {
  echo "${LINE_TO_ADD}" >>~/.bashrc
  echo "Bash successfully configured. Source ~/.bashrc or logout and back in again."
}

