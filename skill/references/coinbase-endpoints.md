# Coinbase Endpoints

The CLI currently targets these Coinbase CDP endpoints:

- `GET /platform/v1/wallets`
- `GET /platform/v1/wallets/{wallet_id}`
- `GET /platform/v1/wallets/{wallet_id}/addresses`
- `GET /platform/v1/wallets/{wallet_id}/balances`
- `GET /platform/v1/wallets/{wallet_id}/addresses/{address_id}/balances`
- `POST /platform/v1/wallets`
- `GET /platform/v2/data/evm/token-balances/{network}/{address}`

As of March 4, 2026, Coinbase documentation marks Server Wallet v1 concept docs deprecated as of February 2, 2026. The REST API reference still documents the `/platform/v1/wallets` endpoints used here, but future expansion should be checked against Server Wallet v2 migration guidance.

For the migration approach and command-level impact, see [`server-wallet-v2-plan.md`](/home/noir/enna/skills/coinbase-individual/skill/references/server-wallet-v2-plan.md).

Base URL is not hardcoded in each command. The CLI reads `COINBASE_API_BASE_URL` and validates the resolved host against `COINBASE_ALLOWED_HOSTS`.

Default values:

- `COINBASE_API_BASE_URL=https://api.cdp.coinbase.com`
- `COINBASE_ALLOWED_HOSTS=api.cdp.coinbase.com`
- `COINBASE_DEFAULT_NETWORK=base-sepolia`
