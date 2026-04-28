# AGENTS.md

Guidance for agents working in this repository.

## Project Overview

This repository contains an unofficial Codex plugin package for Telegram Bot API messaging workflows.

- `.codex-plugin/plugin.json` defines plugin metadata and points Codex at the skills directory.
- `skills/telegram/SKILL.md` is the primary behavior surface for the plugin.
- `scripts/telegram_api.sh` is a small helper for Telegram Bot API calls.
- `assets/` contains plugin branding assets.

The plugin is currently instructions plus a helper script. It does not define an MCP server or custom app tools.

## Secrets

- Never commit `.env`.
- Never print bot tokens, chat secrets, invite links, or private message contents unless explicitly necessary.
- Read Telegram credentials from `TELEGRAM_BOT_TOKEN`.
- Use `TELEGRAM_CHAT_ID` for a default send target when needed.
- Use Gitleaks before publishing changes that touch scripts, docs, workflows, or examples.

## Useful Commands

Validate plugin JSON:

```bash
python3 -m json.tool .codex-plugin/plugin.json >/dev/null
```

Validate commitlint config JSON:

```bash
python3 -m json.tool .commitlintrc.json >/dev/null
```

Lint shell scripts:

```bash
shellcheck scripts/*.sh
```

Check bot identity when `.env` contains the required `TELEGRAM_*` variables:

```bash
set -a
source .env
set +a
scripts/telegram_api.sh me
```

## Change Guidelines

- Keep edits small and aligned with the plugin's current shape.
- Prefer improving `skills/telegram/SKILL.md` for agent behavior changes.
- Prefer improving `scripts/telegram_api.sh` for reusable API execution behavior.
- Do not add a package manager just for linting unless the repo already adopts one.
- Keep placeholder assets unless properly licensed Telegram brand assets are supplied.
- Update `CHANGELOG.md` using Keep a Changelog sections for user-visible changes.
- Use conventional commits; this checkout is configured with `.gitmessage` as the local commit template.

## Telegram Safety

Telegram writes can notify real people and groups. Default to read-only discovery. For any action that sends, edits, deletes, pins, forwards, or otherwise changes Telegram state:

1. Identify the exact target chat.
2. Summarize the intended request and expected effect.
3. Ask for explicit confirmation before executing.
4. Read back the Telegram API response after execution.

## CI Expectations

GitHub Actions runs:

- Gitleaks secret scanning.
- JSON validation for plugin and commitlint config files.
- ShellCheck for scripts.
- Required-file checks for plugin metadata, skill, script, license, changelog, and assets.
