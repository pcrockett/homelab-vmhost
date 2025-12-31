#!/usr/bin/env blarg
# [tag:core/apt-updated]

apply() {
  as_root apt-get update
}
