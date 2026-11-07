# shellcheck shell=bash

# .envrc is loaded by direnv on the machine blarg runs on, but `blarg --ssh`
# does not forward env vars to remote machines. the repo (including .envrc) is
# tarred to those remotes, so evaluate the plain `export` lines here as well.
# direnv directives in .envrc (strict_env, PATH_add, ...) are not valid bash
# and are skipped.
if [ -f "${BLARG_MODULE_DIR}/.envrc" ]; then
  if exports="$(grep --line-regexp '^export ' "${BLARG_MODULE_DIR}/.envrc")"; then
    printf '%s\n' "${exports}" | source /dev/stdin
  fi
fi
