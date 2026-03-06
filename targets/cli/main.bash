#!/usr/bin/env blarg

targets=(
  tree-installed
  net-tools-installed
  btop-installed
  @pcrockett:helix/main
)

depends_on "${targets[@]}"
