#!/usr/bin/env blarg

targets=(
  tree-installed
  net-tools-installed
)

depends_on "${targets[@]}"
