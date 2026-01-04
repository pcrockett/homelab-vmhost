#!/usr/bin/env blarg

# shellcheck disable=SC2034  # PACKAGE is used in `rush-package-installed` snippet
PACKAGE="deb/terraform"

satisfied_if() {
  command -v terraform
}

snippet rush-package-installed
