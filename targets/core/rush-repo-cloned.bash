#!/usr/bin/env blarg

depends_on bash-configured rush-installed

satisfied_if() {
  test -d "${RUSH_ROOT}/pcrockett/rush-repo/.git"
}

apply() {
  rush clone pcrockett --default
}
