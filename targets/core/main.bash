#!/usr/bin/env blarg

targets=(
  bash-configured
  curl-installed
  git-installed
  make-installed
)

depends_on "${targets[@]}"
