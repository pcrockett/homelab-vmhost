#!/usr/bin/env blarg

depends_on vm-started

satisfied_if() {
  proxy_run id --user "${USER}"
  proxy_run test -d "/home/${USER}"
}

apply() {
  proxy_run useradd --create-home "${USER}"
}

proxy_run() {
  incus exec proxy -- "$@"
}
