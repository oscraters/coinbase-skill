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
./scripts/coinbase-cli config show-sanitized
./scripts/coinbase-cli auth check
```

Read wallet data:

```bash
./scripts/coinbase-cli wallet list
./scripts/coinbase-cli wallet get --wallet-id wallet-id
./scripts/coinbase-cli wallet addresses --wallet-id wallet-id
./scripts/coinbase-cli balance wallet --wallet-id wallet-id
```

Read public onchain balances:

```bash
./scripts/coinbase-cli balance address --network base-sepolia --address 0x0000000000000000000000000000000000000000
```

Create a wallet:

```bash
./scripts/coinbase-cli wallet create --network base-sepolia --yes
```

