#!/usr/bin/env blarg

# shellcheck disable=SC2034  # PACKAGE is used in `rush-package-installed` snippet
PACKAGE="with-umask"

satisfied_if() {
  command -v "${PACKAGE}"
}

snippet rush-package-installed
