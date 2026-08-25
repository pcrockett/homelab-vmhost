#!/usr/bin/env blarg

targets=(
  core/main
  kernel/main
  network/main
  boot/main
  backup/main
  misc/main
  cli/main
  vm/main
)

depends_on "${targets[@]}"
