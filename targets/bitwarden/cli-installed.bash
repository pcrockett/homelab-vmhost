#!/usr/bin/env blarg

# shellcheck disable=SC2034  # PACKAGE is used in `rush-package-installed` snippet
PACKAGE="bw-cli"

depends_on core/unzip-installed

satisfied_if() {
  command -v bw
}

snippet rush-package-installed
