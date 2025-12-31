# shellcheck shell=bash

as_root() {
  command=("$@")
  if [ "$(id -u)" -ne 0 ]; then
    command=(sudo -- "${command[@]}")
    echo "Running \`${command[*]}\`"
  fi
  "${command[@]}"
}
