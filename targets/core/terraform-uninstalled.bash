#!/usr/bin/env blarg

satisfied_if() {
  ! command -v terraform
}

apply() {
  uninstall_package terraform
}
