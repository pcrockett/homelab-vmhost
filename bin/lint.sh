#!/usr/bin/env bash
set -euo pipefail

EXIT_STATUS=0

report_lint() {
  EXIT_STATUS=1
  echo "lint: ${*}"
}

all_files() {
  rg --files
}

ignore() {
  # expects stdin to be a newline-delimited list
  # filters out any lines that match the parameters given
  # parameters should be regular expressions
  #
  # ex:
  #
  #     ignore foo <<EOF
  #     hello
  #     foo
  #     bar
  #     EOF
  #
  # outputs:
  #
  #     hello
  #     bar
  #
  command=(rg --invert-match --line-regexp)
  for f in "${@}"; do
    command+=(-e "${f}")
  done
  "${command[@]}"
}

rule:no_raw_sudo() {
  ! all_files \
    | ignore "bin/lint\.sh" "lib\.d/50_as_root\.sh" "config/bash/bashrc" \
    | xargs rg --regexp '[^(?:vi)]sudo '
}

rule:no_core_main() {
  ! all_files \
    | ignore "bin/lint\.sh" "targets/main.bash" "AGENTS\.md" \
    | xargs rg --word-regexp --fixed-strings 'core/main'
}

main() {
  rule:no_raw_sudo || report_lint "don't use raw \`sudo\` -- use \`as_root\` instead."
  rule:no_core_main || report_lint "don't depend on core/main."
  pre-commit run --all --show-diff-on-failure --color=always || report_lint "pre-commit failed"

  if [ "${EXIT_STATUS}" -eq 0 ]; then
    echo "no lint found"
  fi
  exit "${EXIT_STATUS}"
}

main "${@}"
