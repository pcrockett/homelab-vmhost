# shellcheck shell=bash

TARGET_CHECKPOINT_FILE="${STATE_DIR}/checkpoints/${BLARG_TARGET_NAME}"

# checks whether this target's checkpoint timestamp is greater than the target file's
# own timestamp. ALSO checks if the checkpoint file's timestamp is greater than any
# other file path that you may have passed in as a parameter.
#
# example usage:
#
#     ```bash
#     # need this target to run any time it has been modified, but only needs to run once
#     satisfied_if() {
#       checkpoint_is_current
#     }
#
#     apply() {
#       # do your work here...
#
#       checkpoint_success
#     }
#     ```
#
#     ```
#     # need this target to be run whenever this target, or other files are modified
#     satisfied_if() {
#       checkpoint_is_current some_file.toml some_other_file.conf
#     }
#     ```
#
# to be used in conjunction with `checkpoint_success` below.
checkpoint_is_current() {
  local paths_to_check=("$@")

  test -f "${TARGET_CHECKPOINT_FILE}"
  checkpoint_timestamp="$(file_timestamp "${TARGET_CHECKPOINT_FILE}")"
  test "${checkpoint_timestamp}" -gt "$(file_timestamp "${BLARG_TARGET_PATH}")"

  for path in "${paths_to_check[@]}"
  do
    test "${checkpoint_timestamp}" -gt "$(file_timestamp "${path}")"
  done
}

# set a successful checkpoint
checkpoint_success() {
  mkdir --parent "$(dirname "${TARGET_CHECKPOINT_FILE}")"
  touch "${TARGET_CHECKPOINT_FILE}"
}

# unset a checkpoint
checkpoint_clear() {
  rm -f "${TARGET_CHECKPOINT_FILE}"
}
