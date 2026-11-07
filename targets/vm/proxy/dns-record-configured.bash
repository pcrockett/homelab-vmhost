#!/usr/bin/env blarg
#
# public wildcard A record *.internal.${INTERNAL_APEX_DOMAIN} pointing at the
# proxy VM's tailscale IP, which is detected at runtime (never hardcode IPs)

depends_on tailscale-provisioned bitwarden/cli-installed core/jq-installed core/curl-installed

PORKBUN_API_BASE="https://api.porkbun.com/api/v3"
RECORD_NAME="*.internal"
RECORD_TYPE="A"
RECORD_TTL="600"

satisfied_if() {
  # the vault may be locked (e.g. during dry-runs); only check when unlocked
  [ -f "${BW_SESSION_FILE}" ] || return 1
  [ -n "${INTERNAL_APEX_DOMAIN:-}" ] || return 1
  bw_session
  load_bw_item machine.proxy
  load_api_credentials

  local ts_ip
  ts_ip="$(tailscale ip -4 proxy)" || return 1
  [ -n "${ts_ip}" ] || return 1

  list_records | jq --exit-status \
    --arg fqdn "${RECORD_NAME}.${INTERNAL_APEX_DOMAIN}" \
    --arg ip "${ts_ip}" \
    '.status == "SUCCESS" and ([.records[] | select(.name == $fqdn and .type == "A" and .content == $ip)] | length > 0)'
}

apply() {
  INTERNAL_APEX_DOMAIN="${INTERNAL_APEX_DOMAIN:?set INTERNAL_APEX_DOMAIN in .envrc}"
  satisfy bitwarden/synced
  load_bw_item machine.proxy
  load_api_credentials

  local ts_ip record_id
  ts_ip="$(tailscale ip -4 proxy)"
  [ -n "${ts_ip}" ] || panic "could not determine tailscale IP of proxy"

  record_id="$(list_records | jq --raw-output \
    --arg fqdn "${RECORD_NAME}.${INTERNAL_APEX_DOMAIN}" \
    '[.records[] | select(.name == $fqdn and .type == "A")][0].id // ""')"

  if [ -n "${record_id}" ]; then
    porkbun_api "/dns/edit/${INTERNAL_APEX_DOMAIN}/${record_id}" "${ts_ip}"
  else
    porkbun_api "/dns/create/${INTERNAL_APEX_DOMAIN}" "${ts_ip}"
  fi
}

load_api_credentials() {
  PORKBUN_API_KEY="$(bw_value porkbun.api-key)"
  PORKBUN_API_SECRET_KEY="$(bw_value porkbun.api-secret-key)"
}

list_records() {
  local payload
  payload="$(jq --null-input \
    --arg apikey "${PORKBUN_API_KEY}" \
    --arg secret "${PORKBUN_API_SECRET_KEY}" \
    '{apikey: $apikey, secretapikey: $secret}')"
  # --data @- keeps the api keys out of the process list
  printf '%s' "${payload}" | curl --proto '=https' --tlsv1.2 --silent --show-error --fail \
    --request POST \
    --header 'Content-Type: application/json' \
    --data @- \
    "${PORKBUN_API_BASE}/dns/list/${INTERNAL_APEX_DOMAIN}"
}

porkbun_api() {
  # $1 = endpoint path, $2 = record content (IP)
  local payload
  payload="$(jq --null-input \
    --arg apikey "${PORKBUN_API_KEY}" \
    --arg secret "${PORKBUN_API_SECRET_KEY}" \
    --arg name "${RECORD_NAME}" \
    --arg type "${RECORD_TYPE}" \
    --arg content "${2}" \
    --arg ttl "${RECORD_TTL}" \
    '{apikey: $apikey, secretapikey: $secret, name: $name, type: $type, content: $content, ttl: $ttl}')"
  printf '%s' "${payload}" | curl --proto '=https' --tlsv1.2 --silent --show-error --fail \
    --request POST \
    --header 'Content-Type: application/json' \
    --data @- \
    "${PORKBUN_API_BASE}${1}" \
    | jq --exit-status '.status == "SUCCESS"'
}
