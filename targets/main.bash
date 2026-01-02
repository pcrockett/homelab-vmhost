#!/usr/bin/env blarg

targets=(
  core/main
  network/main
  boot/main
  backup/main
  misc/main
  cli/main
)

depends_on "${targets[@]}"
