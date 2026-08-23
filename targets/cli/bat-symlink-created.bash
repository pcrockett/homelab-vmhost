#!/usr/bin/env blarg

depends_on bat-installed

USR_BIN="/usr/bin/batcat"
USR_LOCAL_BIN="/usr/local/bin/bat"

satisfied_if() {
  test_symlink "${USR_BIN}" "${USR_LOCAL_BIN}"
}

apply() {
  as_root rm -f "${USR_LOCAL_BIN}"
  as_root ln --symbolic "${USR_BIN}" "${USR_LOCAL_BIN}"
}
