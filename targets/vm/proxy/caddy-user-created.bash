#!/usr/bin/env blarg

# dedicated restricted account that runs caddy: system user, no login shell,
# no sudoers entry

depends_on vm-started

satisfied_if() {
  proxy_run id caddy
}

apply() {
  proxy_run useradd --system --home-dir /var/lib/caddy --shell /usr/sbin/nologin caddy
}

proxy_run() {
  incus exec proxy -- "$@"
}
