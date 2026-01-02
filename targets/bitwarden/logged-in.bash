#!/usr/bin/env blarg

depends_on cli-installed

satisfied_if() {
  bw login --check
}

apply() {
  panic "As of right now, this step is manual. Please run \`bw login\` and try again."
}
