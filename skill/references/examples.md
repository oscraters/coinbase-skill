# Examples

Local development with direct environment variables:

```bash
export CDP_API_KEY_ID="your-api-key-id"
export CDP_API_KEY_SECRET="your-api-key-secret"
export COINBASE_API_BASE_URL="https://api.cdp.coinbase.com"
export COINBASE_ALLOWED_HOSTS="api.cdp.coinbase.com"
export COINBASE_DEFAULT_NETWORK="base-sepolia"
```

Inspect safe runtime state:

```bash
./scripts/openclaw-run config show-sanitized
./scripts/openclaw-run auth check
```

Read wallet data:

```bash
./scripts/openclaw-run wallet list
./scripts/openclaw-run wallet get --wallet-id wallet-id
./scripts/openclaw-run wallet addresses --wallet-id wallet-id
./scripts/openclaw-run balance wallet --wallet-id wallet-id
```

Read public onchain balances:

```bash
./scripts/openclaw-run balance address --network base-sepolia --address 0x0000000000000000000000000000000000000000
```

Create a wallet:

```bash
./scripts/openclaw-run wallet create --network base-sepolia --yes
```
