#!/usr/bin/env blarg
#
# apply the guest-side targets inside the proxy VM over tailscale ssh: blarg
# tars this repo to a temp dir on the VM and runs guest.bash there natively.
#
# no satisfied_if on purpose -- the guest targets are individually idempotent,
# so re-running this is cheap.

depends_on tailscale-provisioned caddy-user-created proxy-env-configured

apply() {
  # blarg --ssh re-extracts the repo at a different temp dir on the target, so
  # the script path must be relative to the current working dir
  local rel_target
  rel_target="${BLARG_TARGET_PATH#"${BLARG_MODULE_DIR}/"}"

  # lets lib.d/00_checks.sh know this run is inside a guest VM, not the vmhost
  mkdir -p "${BLARG_MODULE_DIR}/.blarg"
  touch "${BLARG_MODULE_DIR}/.blarg/guest-vm"

  "${BLARG_MODULE_DIR}/bin/blarg" --ssh "${SSH_PROXY_DEST:?set SSH_PROXY_DEST in .envrc}" \
    --verbose "$(dirname "${rel_target}")/guest.bash"
}
