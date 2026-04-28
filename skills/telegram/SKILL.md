---
name: telegram
description: Work with Telegram Bot API messaging. Use when the user asks Codex to inspect a Telegram bot, read bot updates, discover chats, draft Telegram messages, or send confirmed messages through a bot.
---

# Telegram

Use this skill for Telegram Bot API tasks. This plugin works through a bot token; it cannot read a user's personal Telegram inbox unless messages are visible to that bot.

## Connection

Prefer the helper script at `scripts/telegram_api.sh` from the plugin root.

Required environment:

- `TELEGRAM_BOT_TOKEN`: Telegram bot token from BotFather.

Optional environment:

- `TELEGRAM_CHAT_ID`: Default chat id for message sends.
- `TELEGRAM_PARSE_MODE`: Default parse mode for `send-message`, for example `MarkdownV2` or `HTML`.

Never print bot tokens, chat secrets, invite links, or private message contents unless the user explicitly asks for the content and it is necessary for the task.

## Safe Workflow

1. Start with read-only discovery, such as `me` or `updates`.
2. Identify the exact chat id and recipient before sending anything.
3. Draft the message and ask for explicit confirmation before sending.
4. For sends, read back the Telegram API response and report the message id, chat id, and delivery status without exposing secrets.

## Common Commands

Run these from the plugin root:

```bash
scripts/telegram_api.sh me
scripts/telegram_api.sh updates
scripts/telegram_api.sh chat "$TELEGRAM_CHAT_ID"
scripts/telegram_api.sh send-message "$TELEGRAM_CHAT_ID" "Hello from Codex"
scripts/telegram_api.sh raw getWebhookInfo
```

The helper prints JSON. Prefer `jq` when available for inspection.

## API Notes

Telegram Bot API methods are called at:

```text
https://api.telegram.org/bot<token>/<method>
```

Bots only receive messages that Telegram makes available to them. In groups, privacy mode and bot permissions affect what updates are visible.

## Message Safety

Sending messages can notify real people or groups. Before sending, editing, deleting, pinning, forwarding, or otherwise changing Telegram state, ask for explicit confirmation with the exact target chat and message text or action summary.
