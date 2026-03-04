#!/usr/bin/env bash

wallet_impl_suffix() {
  case "${COINBASE_WALLET_API_VERSION:-v1}" in
    v1|v2)
      printf '%s\n' "${COINBASE_WALLET_API_VERSION:-v1}"
      ;;
    *)
      fail "Unsupported COINBASE_WALLET_API_VERSION: ${COINBASE_WALLET_API_VERSION}"
      ;;
  esac
}

wallet_dispatch() {
  local action="$1"
  shift
  local suffix
  suffix="$(wallet_impl_suffix)"
  local fn="${action}_${suffix}"
  if ! declare -F "${fn}" >/dev/null 2>&1; then
    fail "Wallet action ${action} is not available for ${suffix}"
  fi
  "${fn}" "$@"
}

