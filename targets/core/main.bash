#!/usr/bin/env blarg

targets=(
  curl-installed
  git-installed
)

depends_on "${targets[@]}"
