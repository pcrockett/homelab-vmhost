#!/usr/bin/env blarg

targets=(
  tree-installed
  net-tools-installed
  btop-installed
)

depends_on "${targets[@]}"
