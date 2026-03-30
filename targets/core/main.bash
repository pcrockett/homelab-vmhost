#!/usr/bin/env blarg

targets=(
  make-installed
  terraform-uninstalled
)

depends_on "${targets[@]}"
