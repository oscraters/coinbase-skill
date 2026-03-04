---
name: coinbase-cdp-bash
description: Use a bash CLI to interact with Coinbase CDP safely from OpenClaw, including auth checks, wallet inspection, balances, and guarded wallet creation with OpenClaw secret injection.
homepage: https://github.com/<your-org>/coinbase-individual
metadata: { "openclaw": { "primaryEnv": "CDP_API_KEY_ID", "requires": { "bins": ["bash", "curl", "jq", "node"], "config": ["skills.entries.coinbase-cdp-bash"] }, "homepage": "https://github.com/<your-org>/coinbase-individual" } }
---

# Coinbase CDP Bash Skill

Use this skill when the user wants Coinbase CDP operations from OpenClaw through a shell-first interface.

## Entry Point

Run [`scripts/coinbase-cli`](/home/noir/enna/skills/coinbase-individual/skill/scripts/coinbase-cli).

## Operating Rules

- Treat `CDP_API_KEY_SECRET`, `CDP_WALLET_SECRET`, bearer JWTs, and wallet JWTs as highly sensitive.
- Never print secrets to stdout or logs.
- Keep logs on stderr only and let the redaction layer sanitize them.
- Read base URLs from config or environment. Do not hardcode alternate hosts into command implementations.
- Refuse write operations unless the user passes `--yes`.
- Prefer read-only commands first when exploring an account or wallet state.
- Default examples to `base-sepolia` unless the user explicitly needs production.

## Required Runtime Inputs

- `CDP_API_KEY_ID`
- `CDP_API_KEY_SECRET`
- `COINBASE_API_BASE_URL` or `skills.entries.coinbase-cdp-bash.config.apiBaseUrl`

## Optional Runtime Inputs

- `CDP_WALLET_SECRET`
- `COINBASE_DEFAULT_NETWORK`
- `COINBASE_ALLOWED_HOSTS`
- `COINBASE_REQUEST_TIMEOUT_SECONDS`

## Common Commands

```bash
{baseDir}/scripts/coinbase-cli config show-sanitized
{baseDir}/scripts/coinbase-cli auth check
{baseDir}/scripts/coinbase-cli wallet list
{baseDir}/scripts/coinbase-cli wallet get --wallet-id <wallet-id>
{baseDir}/scripts/coinbase-cli wallet addresses --wallet-id <wallet-id>
{baseDir}/scripts/coinbase-cli balance wallet --wallet-id <wallet-id>
{baseDir}/scripts/coinbase-cli balance address --network base-sepolia --address <address>
{baseDir}/scripts/coinbase-cli wallet create --network base-sepolia --yes
```

## References

- Endpoint summary: [`references/coinbase-endpoints.md`](/home/noir/enna/skills/coinbase-individual/skill/references/coinbase-endpoints.md)
- Security checks: [`references/security-checklist.md`](/home/noir/enna/skills/coinbase-individual/skill/references/security-checklist.md)
- Usage examples: [`references/examples.md`](/home/noir/enna/skills/coinbase-individual/skill/references/examples.md)

