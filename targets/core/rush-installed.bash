#!/usr/bin/env blarg

depends_on curl-installed git-installed bash-configured

satisfied_if() {
  command -v rush
}

apply() {
  curl -SsfL https://philcrockett.com/yolo/v1.sh \
    | bash -s -- rush
}
