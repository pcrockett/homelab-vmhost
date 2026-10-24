#!/usr/bin/env blarg

depends_on logged-in core/bash-configured

satisfied_if() {
  bw unlock --check
}

apply() {
  bw_unlock
}
