#!/usr/bin/env bash

runtime_ready=0

load_json_config_defaults() {
  local config_file="${COINBASE_SKILL_CONFIG_FILE:-${OPENCLAW_SKILL_CONFIG_FILE:-}}"
  if [[ -z "${config_file}" || ! -f "${config_file}" ]]; then
    return 0
  fi

  local skill_json
  skill_json="$(jq -c '
    .skills.entries["coinbase-cdp-bash"] // .["coinbase-cdp-bash"] // .
  ' "${config_file}")"

  local config_api_base_url config_default_network config_allowed_hosts config_timeout
  config_api_base_url="$(jq -r '.config.apiBaseUrl // empty' <<<"${skill_json}")"
  config_default_network="$(jq -r '.config.defaultNetwork // empty' <<<"${skill_json}")"
  config_allowed_hosts="$(jq -r '(.config.allowedHosts // []) | join(",")' <<<"${skill_json}")"
  config_timeout="$(jq -r '.config.requestTimeoutSeconds // empty' <<<"${skill_json}")"

  local env_api_key_id env_api_key_secret env_wallet_secret
  env_api_key_id="$(jq -r '.env.CDP_API_KEY_ID // empty' <<<"${skill_json}")"
  env_api_key_secret="$(jq -r '.env.CDP_API_KEY_SECRET // empty' <<<"${skill_json}")"
  env_wallet_secret="$(jq -r '.env.CDP_WALLET_SECRET // empty' <<<"${skill_json}")"

  : "${COINBASE_API_BASE_URL:=${config_api_base_url}}"
  : "${COINBASE_DEFAULT_NETWORK:=${config_default_network}}"
  : "${COINBASE_ALLOWED_HOSTS:=${config_allowed_hosts}}"
  : "${COINBASE_REQUEST_TIMEOUT_SECONDS:=${config_timeout}}"
  : "${CDP_API_KEY_ID:=${env_api_key_id}}"
  : "${CDP_API_KEY_SECRET:=${env_api_key_secret}}"
  : "${CDP_WALLET_SECRET:=${env_wallet_secret}}"
}

init_runtime() {
  if [[ "${runtime_ready}" == "1" ]]; then
    return 0
  fi

  load_json_config_defaults

  CDP_API_KEY_ID="${CDP_API_KEY_ID:-}"
  CDP_API_KEY_SECRET="${CDP_API_KEY_SECRET:-}"
  CDP_WALLET_SECRET="${CDP_WALLET_SECRET:-}"
  COINBASE_API_BASE_URL="$(trim_trailing_slash "${COINBASE_API_BASE_URL:-https://api.cdp.coinbase.com}")"
  COINBASE_DEFAULT_NETWORK="${COINBASE_DEFAULT_NETWORK:-base-sepolia}"
  COINBASE_ALLOWED_HOSTS="${COINBASE_ALLOWED_HOSTS:-api.cdp.coinbase.com}"
  COINBASE_REQUEST_TIMEOUT_SECONDS="${COINBASE_REQUEST_TIMEOUT_SECONDS:-30}"

  validate_non_empty "CDP_API_KEY_ID" "${CDP_API_KEY_ID}"
  validate_non_empty "CDP_API_KEY_SECRET" "${CDP_API_KEY_SECRET}"
  validate_non_empty "COINBASE_API_BASE_URL" "${COINBASE_API_BASE_URL}"
  validate_network "${COINBASE_DEFAULT_NETWORK}"

  COINBASE_API_HOST="$(COINBASE_API_BASE_URL="${COINBASE_API_BASE_URL}" node -e 'console.log(new URL(process.env.COINBASE_API_BASE_URL).host)')"
  validate_allowed_host "${COINBASE_API_HOST}" "${COINBASE_ALLOWED_HOSTS}"
  runtime_ready=1
}

config_as_sanitized_json() {
  jq -cn \
    --arg apiKeyId "${CDP_API_KEY_ID}" \
    --arg apiKeySecret "[REDACTED]" \
    --arg walletSecret "$( [[ -n "${CDP_WALLET_SECRET}" ]] && printf '[REDACTED]' || printf '' )" \
    --arg apiBaseUrl "${COINBASE_API_BASE_URL}" \
    --arg apiHost "${COINBASE_API_HOST}" \
    --arg defaultNetwork "${COINBASE_DEFAULT_NETWORK}" \
    --arg allowedHosts "${COINBASE_ALLOWED_HOSTS}" \
    --arg timeout "${COINBASE_REQUEST_TIMEOUT_SECONDS}" \
    '{
      apiKeyId: $apiKeyId,
      apiKeySecret: $apiKeySecret,
      walletSecret: $walletSecret,
      apiBaseUrl: $apiBaseUrl,
      apiHost: $apiHost,
      defaultNetwork: $defaultNetwork,
      allowedHosts: ($allowedHosts | split(",")),
      timeoutSeconds: ($timeout | tonumber)
    }'
}
