#!/usr/bin/env blarg

depends_on core/rush-installed

PACKAGE_NAME="tailscale"

satisfied_if() {
  command -v "${PACKAGE_NAME}"
}

apply() {
  satisfy core/rush-repo-pulled
  rush get "${PACKAGE_NAME}"
}
