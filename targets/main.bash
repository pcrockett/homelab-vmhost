#!/usr/bin/env blarg

targets=(
  core/main
  network/main
  boot/main
  backup/main
  misc/main
)

depends_on "${targets[@]}"
