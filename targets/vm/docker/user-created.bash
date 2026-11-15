#!/usr/bin/env blarg

depends_on vm-started

satisfied_if() {
  docker_run id --user "${USER}"
  docker_run test -d "/home/${USER}"
}

apply() {
  docker_run useradd --create-home "${USER}"
}

docker_run() {
  incus exec docker -- "$@"
}
