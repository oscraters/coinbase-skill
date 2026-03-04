# Coinbase CDP OpenClaw Skill

Public OpenClaw skill and bash CLI for Coinbase Developer Platform (CDP) operations. The user-facing interface is a shell command. Coinbase authentication is handled by a small Node helper so JWT generation stays aligned with Coinbase's documented SDK flow.

As of March 4, 2026, Coinbase's server-wallet v1 concept docs are marked deprecated effective February 2, 2026. This scaffold still uses the currently documented `/platform/v1` wallet REST endpoints, so wallet-management coverage should be reviewed against Server Wallet v2 before expanding beyond this initial command set.

## What This Includes

- OpenClaw-compatible skill bundle in [`skill/`](/home/noir/enna/skills/coinbase-individual/skill)
- Bash CLI for safe read-only wallet and balance operations
- Guarded wallet creation flow with explicit confirmation
- OpenClaw config example using secrets indirection patterns
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

Run a few safe commands:

```bash
./skill/scripts/coinbase-cli config show-sanitized
./skill/scripts/coinbase-cli auth check
./skill/scripts/coinbase-cli wallet list
./skill/scripts/coinbase-cli balance address --network base-sepolia --address 0x...
```

Create a wallet only with explicit confirmation:

```bash
./skill/scripts/coinbase-cli wallet create --network base-sepolia --yes
```

## OpenClaw Config Pattern

Use [`skill/assets/openclaw.example.jsonc`](/home/noir/enna/skills/coinbase-individual/skill/assets/openclaw.example.jsonc) as the starting point. The intended pattern is:

- OpenClaw resolves secret references into environment variables.
- The CLI reads those environment variables at runtime.
- The CLI can also read an OpenClaw-style JSON config file through `COINBASE_SKILL_CONFIG_FILE` or `OPENCLAW_SKILL_CONFIG_FILE`.
- The same config schema works both locally now and later for anyone who installs the skill.

## ClawHub Packaging

The publishable skill bundle is the [`skill/`](/home/noir/enna/skills/coinbase-individual/skill) directory. It includes `SKILL.md`, scripts, references, and example config assets.

## Non-Goals

- No GitHub Actions
- No CI/CD
- No plaintext secrets in repo-managed config files
