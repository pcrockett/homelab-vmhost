#!/usr/bin/env blarg

depends_on packages-installed

GROUP_NAME=libvirt

satisfied_if() {
  groups | grep --word-regexp "${GROUP_NAME}"
}

apply() {
  as_root adduser "${USER}" "${GROUP_NAME}"
  panic "User successfully added to ${GROUP_NAME} group. However you need to log out and back in to continue."
}
