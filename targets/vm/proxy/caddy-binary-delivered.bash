#!/usr/bin/env blarg
#
# OPEN QUESTION (see doc/PROXY.md): how the porkbun-enabled caddy binary gets
# built off the VM (xcaddy build on the control machine, a CI artifact, or the
# official custom build from caddyserver.com/download) and delivered here with
# `incus file push` (root-owned, 0755), verified by sha256.
#
# deliberately not wired into main.bash yet. when implemented, add it to
# main.bash before guest-applied -- until then, caddy-service-enabled fails
# loudly because /usr/local/bin/caddy does not exist.

apply() {
  panic "caddy binary delivery is not implemented yet -- see doc/PROXY.md open questions"
}
