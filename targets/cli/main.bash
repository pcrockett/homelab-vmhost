#!/usr/bin/env blarg

targets=(
  tree-installed
  net-tools-installed
  btop-installed
  screen-installed
  bat-installed
  bat-symlink-created
  # helix-installed
)

depends_on "${targets[@]}"
