#!/usr/bin/env blarg

targets=(
  bash-configured
  curl-installed
  git-installed
)

depends_on "${targets[@]}"
