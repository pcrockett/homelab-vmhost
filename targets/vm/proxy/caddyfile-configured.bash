#!/usr/bin/env blarg
#
# guest-side: place the committed Caddyfile. it only contains {$ENV_VAR}
# placeholders, which caddy resolves at runtime from /etc/caddy/proxy.env
# (see caddy.service), so the repo never needs the domain or any secrets.

FILE=/etc/caddy/Caddyfile

satisfied_if() {
  files_are_same "${REPO_CONFIG_DIR}/caddy/Caddyfile" "${FILE}"
}

apply() {
  as_root mkdir --parent "$(dirname "${FILE}")"
  as_root cp "${REPO_CONFIG_DIR}/caddy/Caddyfile" "${FILE}"
}
