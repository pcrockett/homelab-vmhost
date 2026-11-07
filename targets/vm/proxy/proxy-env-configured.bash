#!/usr/bin/env blarg

depends_on vm-started caddy-user-created bitwarden/cli-installed core/jq-installed core/with-umask-installed

FILE_NAME="proxy.env"
REPO_CONFIG_DIR="${BLARG_MODULE_DIR}/config/caddy"
ENV_FILE="/etc/caddy/${FILE_NAME}"

satisfied_if() {
  checkpoint_is_current "${REPO_CONFIG_DIR}/${FILE_NAME}.template" \
    && proxy_run test -s "${ENV_FILE}" \
    && test "$(proxy_run stat --format '%U:%G %a' "${ENV_FILE}")" = "root:caddy 640"
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.proxy

  PORKBUN_API_KEY="$(bw_value porkbun.api-key)" \
  PORKBUN_API_SECRET_KEY="$(bw_value porkbun.api-secret-key)" \
  INTERNAL_APEX_DOMAIN="${INTERNAL_APEX_DOMAIN:?set INTERNAL_APEX_DOMAIN in .envrc}" \
    template_render "${REPO_CONFIG_DIR}/${FILE_NAME}.template"

  proxy_run mkdir --parent "$(dirname "${ENV_FILE}")"
  cat "${REPO_CONFIG_DIR}/${FILE_NAME}" | proxy_run tee "${ENV_FILE}"
  proxy_run chown root:caddy "${ENV_FILE}"
  proxy_run chmod 0640 "${ENV_FILE}"
  # tee exits cleanly even if nothing comes through the incus stdin pipe, so
  # verify the file actually landed
  proxy_run test -s "${ENV_FILE}"

  # remove the generated file, just to reduce the amount of secrets lying around
  rm "${REPO_CONFIG_DIR}/${FILE_NAME}"

  checkpoint_success
}

proxy_run() {
  incus exec proxy -- "$@"
}
