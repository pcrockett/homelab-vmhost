#!/usr/bin/env blarg

targets=(
  tree-installed
  net-tools-installed
  btop-installed
  screen-installed
  bat-installed
  bat-symlink-created
  bat-configured
  helix-installed
)

depends_on "${targets[@]}"
