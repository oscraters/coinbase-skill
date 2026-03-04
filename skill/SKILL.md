---
name: coinbase-cdp-bash
description: Use a bash CLI to interact with Coinbase CDP safely from OpenClaw, including auth checks, wallet inspection, balances, and guarded wallet creation with OpenClaw secret injection.
homepage: https://github.com/oscraters/coinbase-skill
metadata: { "openclaw": { "primaryEnv": "CDP_API_KEY_ID", "requires": { "bins": ["bash", "curl", "jq", "node"], "config": ["skills.entries.coinbase-cdp-bash"] }, "homepage": "https://github.com/oscraters/coinbase-skill" } }
---

# Coinbase CDP Bash Skill

Use this skill when the user wants Coinbase CDP operations from OpenClaw through a shell-first interface.

Before running the helper, install the bundled Node dependency from `{baseDir}`:

```bash
cd {baseDir}
npm install
```

## Entry Point

Run [`scripts/openclaw-run`](/home/noir/enna/skills/coinbase-individual/skill/scripts/openclaw-run) when OpenClaw is supplying skill config. Run [`scripts/coinbase-cli`](/home/noir/enna/skills/coinbase-individual/skill/scripts/coinbase-cli) directly for local shell usage.

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
- `COINBASE_ENVIRONMENT`
- `COINBASE_WALLET_API_BASE_URL`
- `COINBASE_WALLET_API_VERSION`

## Common Commands

```bash
{baseDir}/scripts/openclaw-run config show-sanitized
{baseDir}/scripts/openclaw-run auth check
{baseDir}/scripts/openclaw-run wallet list
{baseDir}/scripts/openclaw-run wallet get --wallet-id <wallet-id>
{baseDir}/scripts/openclaw-run wallet addresses --wallet-id <wallet-id>
{baseDir}/scripts/openclaw-run balance wallet --wallet-id <wallet-id>
{baseDir}/scripts/openclaw-run balance address --network base-sepolia --address <address>
{baseDir}/scripts/openclaw-run wallet create --network base-sepolia --yes
```

## References

- Endpoint summary: [`references/coinbase-endpoints.md`](/home/noir/enna/skills/coinbase-individual/skill/references/coinbase-endpoints.md)
- Security checks: [`references/security-checklist.md`](/home/noir/enna/skills/coinbase-individual/skill/references/security-checklist.md)
- Usage examples: [`references/examples.md`](/home/noir/enna/skills/coinbase-individual/skill/references/examples.md)
