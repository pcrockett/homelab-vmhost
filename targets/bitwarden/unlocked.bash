#!/usr/bin/env blarg

depends_on logged-in core/bash-configured

satisfied_if() {
  bw unlock --check
}

apply() {
  panic "As of right now, this step is manual. Please run \`bwu\` and try again."
}
