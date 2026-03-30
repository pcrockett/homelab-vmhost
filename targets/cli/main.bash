#!/usr/bin/env blarg

targets=(
  tree-installed
  net-tools-installed
  btop-installed
  screen-installed
  # helix-installed
)

depends_on "${targets[@]}"
