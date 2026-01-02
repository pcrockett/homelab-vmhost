#!/usr/bin/env blarg

# shellcheck disable=SC2034  # PACKAGE is used in `rush-package-installed` snippet
PACKAGE="backup-cli"

satisfied_if() {
  command -v backup
}

snippet rush-package-installed
