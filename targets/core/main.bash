#!/usr/bin/env blarg

targets=(
  make-installed
  # TODO: uninstall terraform
)

depends_on "${targets[@]}"
