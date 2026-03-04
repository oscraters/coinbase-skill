# Security Checklist

- Do not add `set -x` to the CLI or shared shell libraries.
- Keep all logs on stderr.
- Do not echo JWTs or wallet secrets.
- Do not commit `.env` files with real values.
- Keep Coinbase base URLs in config or environment, not inline in command bodies.
- Use `config show-sanitized` to inspect runtime config safely.
- Require `--yes` for wallet creation and any future signing or broadcast commands.
- Prefer testnet examples in docs and examples.
- Keep host validation enabled unless there is a documented operational reason to widen it.

