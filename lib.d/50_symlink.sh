# shellcheck shell=bash

test_symlink() {
  # Test that a symbolic link at DEST points to a file or directory at SOURCE.
  #
  # Usage: test_symlink SOURCE DEST
  #
  # Example: test_symlink ./my/actual/file ~/the/link/path
  #
  # !!!! Assumes running with `set -Eeuo pipefail` !!!!
  #
  # Will account for relative file paths and canonicalize them before testing.
  #
  # Exit code 0 if the link exists and points to the correct path.
  # Exit code non-zero if the link doesn't exist or points to the wrong path.
  #
  local source="${1}"
  local source_canonical
  source_canonical="$(readlink --canonicalize-existing "${source}")"

  local dest="${2}"
  local dest_canonical
  dest_canonical="$(readlink --canonicalize-existing "${dest}")"

  test -L "${dest}" \
    && test "${source_canonical}" == "${dest_canonical}"
}
