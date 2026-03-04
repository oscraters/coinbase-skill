#!/usr/bin/env bash

wallet_api_version_v1() {
  printf 'v1\n'
}

wallet_auth_check_v1() {
  local response
  response="$(cdp_request "GET" "/platform/v1/wallets" "" false)"
  jq '{status:"ok", walletApiVersion:"v1", wallet_count:(.total_count // (.data | length // 0))}' <<<"${response}"
}

wallet_list_v1() {
  cdp_request "GET" "/platform/v1/wallets" "" false
}

wallet_get_v1() {
  local wallet_id="$1"
  cdp_request "GET" "/platform/v1/wallets/${wallet_id}" "" false
}

wallet_addresses_v1() {
  local wallet_id="$1"
  cdp_request "GET" "/platform/v1/wallets/${wallet_id}/addresses" "" false
}

wallet_create_v1() {
  local network="$1"
  local body
  body="$(jq -cn --arg network "${network}" '{wallet:{network_id:$network,use_server_signer:true}}')"
  cdp_request "POST" "/platform/v1/wallets" "${body}" false
}

wallet_balance_v1() {
  local wallet_id="$1"
  cdp_request "GET" "/platform/v1/wallets/${wallet_id}/balances" "" false
}

wallet_address_balance_v1() {
  local wallet_id="$1"
  local address_id="$2"
  cdp_request "GET" "/platform/v1/wallets/${wallet_id}/addresses/${address_id}/balances" "" false
}

