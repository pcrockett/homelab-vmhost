#!/usr/bin/env blarg

POOL_DIR=/srv/incus # must match [ref:incus-pool-config]

satisfied_if() {
  test -d "${POOL_DIR}"
}

apply() {
  as_root mkdir --mode 0711 -p "${POOL_DIR}"
}
