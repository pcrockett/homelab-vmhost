#!/usr/bin/env blarg

PACKAGE="tailscale"

satisfied_if() {
  command -v "${PACKAGE}"
}

snippet rush-package-installed
