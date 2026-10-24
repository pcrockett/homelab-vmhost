#!/usr/bin/env blarg

depends_on vm-started

satisfied_if() {
  scratch_run id --user "${USER}"
  scratch_run test -d "/home/${USER}"
}

apply() {
  scratch_run useradd --create-home "${USER}"
}

scratch_run() {
  incus exec scratch -- "$@"
}
