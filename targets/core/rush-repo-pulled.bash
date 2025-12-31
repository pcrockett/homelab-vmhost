#!/usr/bin/env blarg

depends_on rush-repo-cloned

apply() {
  rush pull
}
