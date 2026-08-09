#!/usr/bin/env blarg

depends_on curl-installed git-installed rush-configured

satisfied_if() {
  command -v rush
}

apply() {
  curl -SsfL https://philcrockett.com/yolo/v2.sh \
    | bash -s -- rush
}
