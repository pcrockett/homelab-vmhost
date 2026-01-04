#!/usr/bin/env blarg

targets=(
  make-installed
  terraform-installed
)

depends_on "${targets[@]}"
