#!/usr/bin/env blarg

targets=(
  backup-cli-installed
  backup-configured
)

depends_on "${targets[@]}"
