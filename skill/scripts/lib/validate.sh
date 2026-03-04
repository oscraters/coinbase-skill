#!/usr/bin/env bash

validate_non_empty() {
  local name="$1"
  local value="${2:-}"
  [[ -n "${value}" ]] || fail "${name} is required"
}

validate_network() {
  local network="${1:-}"
  [[ "${network}" =~ ^[a-z0-9-]+$ ]] || fail "Invalid network: ${network}"
}

validate_evm_address() {
  local address="${1:-}"
  [[ "${address}" =~ ^0x[0-9a-fA-F]{40}$ ]] || fail "Invalid EVM address: ${address}"
}

validate_allowed_host() {
  local host="${1:-}"
  local allowed_list="${2:-}"
  local allowed
  IFS=',' read -r -a allowed <<<"${allowed_list}"
  for allowed in "${allowed[@]}"; do
    if [[ "${host}" == "${allowed}" ]]; then
      return 0
    fi
  done
  fail "Host ${host} is not in COINBASE_ALLOWED_HOSTS"
}

