# Server Wallet V2 Plan

## Why This Exists

As of March 4, 2026, Coinbase marks Server Wallet v1 concept docs deprecated effective February 2, 2026, while the current REST reference still exposes `/platform/v1/wallets` routes. This skill therefore keeps the current wallet commands narrow and treats broader write support as a migration-gated area.

## Current Command Classification

- Likely stable across migration:
  - `config show-sanitized`
  - `auth check`
  - `balance address`
- Likely to need endpoint or payload review:
  - `wallet list`
  - `wallet get`
  - `wallet addresses`
  - `balance wallet`
  - `balance wallet-address`
  - `wallet create`

## Migration Plan

1. Confirm the canonical Server Wallet v2 REST surface and auth requirements.
2. Compare v1 and v2 resource models:
   - wallet identifiers
   - network identifiers
   - address resources
   - balance resources
   - write operation semantics
3. Keep the CLI verbs stable where possible.
   - Prefer changing backend adapters over changing top-level shell commands.
4. Introduce an internal API-version router.
   - Add `COINBASE_WALLET_API_VERSION=v1|v2`
   - Default new installs to `v2` once verified.
5. Gate any new transaction, signing, or broadcast commands on v2 verification.
6. Maintain read-only compatibility mode if Coinbase continues serving v1 during transition.

## Proposed Internal Refactor

- Keep `coinbase-cli` as the user-facing command.
- Split wallet operations into versioned libraries:
  - `lib/wallet_v1.sh`
  - `lib/wallet_v2.sh`
- Route commands through a thin dispatcher based on configured wallet API version.
- Keep common validation, logging, auth, and HTTP code shared.

## Immediate Rule

Do not add transaction submission or signing flows until the v2 auth and endpoint contract are confirmed against the current Coinbase docs and SDK.
