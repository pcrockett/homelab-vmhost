#!/usr/bin/env blarg

depends_on packages-installed

GROUP_NAME=incus-admin

satisfied_if() {
  groups | grep --word-regexp "${GROUP_NAME}"
}

apply() {
  as_root adduser "${USER}" "${GROUP_NAME}"
  newgrp "${GROUP_NAME}"
}
