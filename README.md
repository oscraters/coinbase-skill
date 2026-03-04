# Coinbase CDP OpenClaw Skill

Public OpenClaw skill and bash CLI for Coinbase Developer Platform (CDP) operations. The user-facing interface is a shell command. Coinbase authentication is handled by a small Node helper so JWT generation stays aligned with Coinbase's documented SDK flow.

As of March 4, 2026, Coinbase's server-wallet v1 concept docs are marked deprecated effective February 2, 2026. This scaffold still uses the currently documented `/platform/v1` wallet REST endpoints, so wallet-management coverage should be reviewed against Server Wallet v2 before expanding beyond this initial command set.

## Status

- Public repo scaffold for ClawHub/OpenClaw distribution
- Shell-first CLI with Coinbase auth helper
- Safe read-only wallet and balance coverage
- Guarded wallet creation
- Planned migration path for Server Wallet v2

## What This Includes

- OpenClaw-compatible skill bundle in [`skill/`](/home/noir/enna/skills/coinbase-individual/skill)
- Bash CLI for safe read-only wallet and balance operations
- Guarded wallet creation flow with explicit confirmation
- OpenClaw config example using secrets indirection patterns
- OpenClaw launcher wrapper for direct `skills.entries.coinbase-cdp-bash.config.*` mapping
- Centralized redaction and hostname validation

## Security Model

- Secrets are read from runtime environment variables that OpenClaw can populate from secret providers.
- Secrets are never printed to stdout.
- Logs go to stderr and pass through redaction filters.
- Base URLs are declared in config and validated against an allowlist before requests are sent.
- Write operations require `--yes`.

## Requirements

- `bash`
- `curl`
- `jq`
- `node` 20+
- `npm install`

## Quick Start

Install dependencies:

```bash
npm install
```

Set runtime variables directly for local development, or let OpenClaw inject them:

```bash
export CDP_API_KEY_ID="your-api-key-id"
export CDP_API_KEY_SECRET="your-api-key-secret"
export COINBASE_API_BASE_URL="https://api.cdp.coinbase.com"
export COINBASE_DEFAULT_NETWORK="base-sepolia"
```

If you want the CLI to read an OpenClaw-style JSON config file directly, point it at one of these variables:

```bash
export COINBASE_SKILL_CONFIG_FILE="$PWD/skill/assets/openclaw.example.jsonc"
# or
export OPENCLAW_SKILL_CONFIG_FILE="$PWD/skill/assets/openclaw.example.jsonc"
```

For OpenClaw-style execution, use the launcher:

```bash
./skill/scripts/openclaw-run config show-sanitized
```

Run a few safe commands:

```bash
./skill/scripts/openclaw-run config show-sanitized
./skill/scripts/openclaw-run auth check
./skill/scripts/openclaw-run wallet list
./skill/scripts/openclaw-run balance address --network base-sepolia --address 0x...
```

Create a wallet only with explicit confirmation:

```bash
./skill/scripts/openclaw-run wallet create --network base-sepolia --yes
```

## OpenClaw Config Pattern

Use [`skill/assets/openclaw.example.jsonc`](/home/noir/enna/skills/coinbase-individual/skill/assets/openclaw.example.jsonc) as the starting point. The intended pattern is:

- OpenClaw resolves secret references into environment variables.
- [`skill/scripts/openclaw-run`](/home/noir/enna/skills/coinbase-individual/skill/scripts/openclaw-run) maps `skills.entries.coinbase-cdp-bash.config.*` into runtime env vars before invoking the CLI.
- The CLI reads those environment variables at runtime.
- The CLI can also read the same OpenClaw-style JSON config file directly through `COINBASE_SKILL_CONFIG_FILE` or `OPENCLAW_SKILL_CONFIG_FILE`.
- The same config schema works both locally now and later for anyone who installs the skill.

## ClawHub Packaging

The publishable skill bundle is the [`skill/`](/home/noir/enna/skills/coinbase-individual/skill) directory. It includes `SKILL.md`, scripts, references, and example config assets.

## Release Notes

See [RELEASE_NOTES.md](/home/noir/enna/skills/coinbase-individual/RELEASE_NOTES.md).

## Server Wallet V2

The current CLI uses the presently documented `/platform/v1/wallets` routes, but expansion is planned around a controlled migration to Server Wallet v2. The migration plan is in [skill/references/server-wallet-v2-plan.md](/home/noir/enna/skills/coinbase-individual/skill/references/server-wallet-v2-plan.md).

## Non-Goals

- No GitHub Actions
- No CI/CD
- No plaintext secrets in repo-managed config files
