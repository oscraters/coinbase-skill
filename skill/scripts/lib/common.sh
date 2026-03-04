#!/usr/bin/env bash

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_bins() {
  local bin
  for bin in "$@"; do
    command -v "${bin}" >/dev/null 2>&1 || fail "Missing required binary: ${bin}"
  done
}

trim_trailing_slash() {
  local input="${1:-}"
  while [[ "${input}" == */ ]]; do
    input="${input%/}"
  done
  printf '%s\n' "${input}"
}

json_escape() {
  jq -Rsc '.' <<<"${1:-}"
}

