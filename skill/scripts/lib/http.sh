#!/usr/bin/env bash

build_jwt() {
  local method="$1"
  local path="$2"
  local body="${3:-}"
  local mode="${4:-api}"
  local args=(
    "${BASE_DIR}/helpers/cdp-auth.mjs"
    "--kind" "${mode}"
    "--request-method" "${method}"
    "--request-host" "${COINBASE_API_HOST}"
    "--request-path" "${path}"
  )
  if [[ -n "${body}" ]]; then
    args+=("--request-body" "${body}")
  fi
  node "${args[@]}"
}

cdp_request() {
  local method="$1"
  local path="$2"
  local body="${3:-}"
  local require_wallet_auth="${4:-false}"

  local bearer_jwt
  bearer_jwt="$(build_jwt "${method}" "${path}" "${body}" "api")"

  local wallet_header=()
  if [[ "${require_wallet_auth}" == "true" ]]; then
    validate_non_empty "CDP_WALLET_SECRET" "${CDP_WALLET_SECRET}"
    local wallet_jwt
    wallet_jwt="$(build_jwt "${method}" "${path}" "${body}" "wallet")"
    wallet_header=(-H "X-Wallet-Auth: ${wallet_jwt}")
  fi

  local url="${COINBASE_API_BASE_URL}${path}"
  local response_file http_code
  local curl_args=()
  response_file="$(mktemp)"
  log_debug "Request ${method} ${url}"

  curl_args=(
    --silent
    --show-error
    --output "${response_file}"
    --write-out '%{http_code}'
    --max-time "${COINBASE_REQUEST_TIMEOUT_SECONDS}"
    --request "${method}"
    --url "${url}"
    --header "Authorization: Bearer ${bearer_jwt}"
    --header "Accept: application/json"
  )

  if [[ "${#wallet_header[@]}" -gt 0 ]]; then
    curl_args+=("${wallet_header[@]}")
  fi

  if [[ -n "${body}" ]]; then
    curl_args+=(
      --header "Content-Type: application/json"
      --data "${body}"
    )
  fi

  http_code="$(
    curl "${curl_args[@]}"
  )"

  if [[ "${http_code}" -lt 200 || "${http_code}" -ge 300 ]]; then
    log_info "Coinbase API request failed with HTTP ${http_code}"
    cat "${response_file}" | redact_text >&2
    rm -f "${response_file}"
    exit 1
  fi

  cat "${response_file}"
  rm -f "${response_file}"
}
