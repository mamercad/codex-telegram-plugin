# Telegram Codex Plugin

Unofficial Codex plugin for working with Telegram Bot API messaging workflows.

It adds a Telegram skill that helps Codex inspect bot state, review bot-visible updates, draft messages, and ask for confirmation before sending anything to a chat.

## Contents

- `.codex-plugin/plugin.json`: Codex plugin manifest.
- `skills/telegram/SKILL.md`: Telegram operating guidance for Codex.
- `scripts/telegram_api.sh`: Small curl-based helper for Telegram Bot API calls.

## Configuration

Set your bot token before asking Codex to inspect Telegram:

```bash
export TELEGRAM_BOT_TOKEN="123456:your-bot-token"
```

Optional defaults:

```bash
export TELEGRAM_CHAT_ID="123456789"
export TELEGRAM_PARSE_MODE="HTML"
```

## Examples

```bash
scripts/telegram_api.sh me
scripts/telegram_api.sh updates
scripts/telegram_api.sh chat "$TELEGRAM_CHAT_ID"
scripts/telegram_api.sh send-message "$TELEGRAM_CHAT_ID" "Hello from Codex"
scripts/telegram_api.sh raw getWebhookInfo
```

## Safety

Telegram sends can notify real people and groups. The skill instructs Codex to identify the target chat, draft the message, and ask for explicit confirmation before sending, editing, deleting, pinning, or forwarding messages.

## Secret Scanning

This repository uses Gitleaks in GitHub Actions. To run the same scan locally:

```bash
gitleaks git --config .gitleaks.toml --redact .
```

## Repository Conventions

- Formatting defaults are defined in `.editorconfig`.
- Commit message rules are defined in `.commitlintrc.json`.
- Releases are tracked in `CHANGELOG.md` using Keep a Changelog.

## Trademark

This project is not affiliated with, endorsed by, or sponsored by Telegram Messenger Inc. Telegram is a trademark of its respective owner.
