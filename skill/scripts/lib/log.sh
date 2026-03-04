#!/usr/bin/env bash

redact_text() {
  sed -E \
    -e 's/(Authorization:[[:space:]]*Bearer[[:space:]]+)[^"[:space:]]+/\1[REDACTED]/Ig' \
    -e 's/(X-Wallet-Auth:[[:space:]]*)[^"[:space:]]+/\1[REDACTED]/Ig' \
    -e 's/(CDP_API_KEY_SECRET=)[^[:space:]]+/\1[REDACTED]/g' \
    -e 's/(CDP_WALLET_SECRET=)[^[:space:]]+/\1[REDACTED]/g' \
    -e 's/(apiKeySecret["=:][[:space:]]*)[^",[:space:]]+/\1[REDACTED]/Ig' \
    -e 's/(walletSecret["=:][[:space:]]*)[^",[:space:]]+/\1[REDACTED]/Ig' \
    -e 's/(jwt["=:][[:space:]]*)[^",[:space:]]+/\1[REDACTED]/Ig'
}

log_info() {
  printf '%s\n' "$*" | redact_text >&2
}

log_debug() {
  if [[ "${COINBASE_DEBUG:-0}" == "1" ]]; then
    printf 'DEBUG: %s\n' "$*" | redact_text >&2
  fi
}

