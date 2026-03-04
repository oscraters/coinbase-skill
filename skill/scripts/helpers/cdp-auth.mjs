#!/usr/bin/env node

function usage() {
  process.stderr.write(`Usage:
  cdp-auth.mjs --kind api|wallet --request-method GET --request-host api.cdp.coinbase.com --request-path /platform/v1/wallets [--request-body '{"k":"v"}']
`);
}

function getArg(name) {
  const index = process.argv.indexOf(name);
  if (index === -1) {
    return "";
  }
  return process.argv[index + 1] ?? "";
}

const kind = getArg("--kind");
if (!kind || process.argv.includes("--help")) {
  usage();
  process.exit(kind ? 0 : 1);
}

const requestMethod = getArg("--request-method");
const requestHost = getArg("--request-host");
const requestPath = getArg("--request-path");
const requestBody = getArg("--request-body");

if (!requestMethod || !requestHost || !requestPath) {
  usage();
  process.exit(1);
}

const apiKeyId = process.env.CDP_API_KEY_ID;
const apiKeySecret = process.env.CDP_API_KEY_SECRET;
if (!apiKeyId || !apiKeySecret) {
  process.stderr.write("Missing CDP_API_KEY_ID or CDP_API_KEY_SECRET\n");
  process.exit(1);
}

const common = {
  apiKeyId,
  apiKeySecret,
  requestMethod,
  requestHost,
  requestPath
};

try {
  const authModule = await import("@coinbase/cdp-sdk/auth");

  if (kind === "api") {
    const token = await authModule.generateJwt(common);
    process.stdout.write(token);
    process.exit(0);
  }

  if (kind === "wallet") {
    const walletSecret = process.env.CDP_WALLET_SECRET;
    if (!walletSecret) {
      process.stderr.write("Missing CDP_WALLET_SECRET\n");
      process.exit(1);
    }

    if (typeof authModule.generateWalletJwt !== "function") {
      process.stderr.write("Installed @coinbase/cdp-sdk does not expose generateWalletJwt\n");
      process.exit(1);
    }

    const token = await authModule.generateWalletJwt({
      ...common,
      walletSecret,
      ...(requestBody ? { requestBody } : {})
    });
    process.stdout.write(token);
    process.exit(0);
  }

  process.stderr.write(`Unknown kind: ${kind}\n`);
  process.exit(1);
} catch (error) {
  process.stderr.write(`JWT generation failed: ${error instanceof Error ? error.message : String(error)}\n`);
  process.exit(1);
}
