#!/usr/bin/env blarg

depends_on cli-installed

satisfied_if() {
  bw login --check
}

apply() {
  bw login </dev/tty
}
