#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/telegram_api.sh me
  scripts/telegram_api.sh updates [limit]
  scripts/telegram_api.sh chat [chat_id]
  scripts/telegram_api.sh send-message [chat_id] <text>
  scripts/telegram_api.sh raw <method> [json_payload]

Environment:
  TELEGRAM_BOT_TOKEN   Required bot token from BotFather.
  TELEGRAM_CHAT_ID     Optional default chat id.
  TELEGRAM_PARSE_MODE  Optional parse mode for send-message.
USAGE
}

require_token() {
  if [[ -z "${TELEGRAM_BOT_TOKEN:-}" ]]; then
    echo "Missing TELEGRAM_BOT_TOKEN." >&2
    exit 2
  fi
}

api_url() {
  printf 'https://api.telegram.org/bot%s/%s' "$TELEGRAM_BOT_TOKEN" "$1"
}

call_get() {
  local method="$1"
  shift || true
  curl -fsS --get "$(api_url "$method")" "$@"
  printf '\n'
}

call_post_form() {
  local method="$1"
  shift
  curl -fsS -X POST "$(api_url "$method")" "$@"
  printf '\n'
}

call_post_json() {
  local method="$1"
  local payload="${2:-{}}"
  curl -fsS -X POST "$(api_url "$method")" \
    -H 'Content-Type: application/json' \
    --data "$payload"
  printf '\n'
}

main() {
  local command="${1:-}"
  if [[ -z "$command" || "$command" == "-h" || "$command" == "--help" ]]; then
    usage
    exit 0
  fi

  require_token

  case "$command" in
    me)
      call_get getMe
      ;;
    updates)
      local limit="${2:-20}"
      call_get getUpdates --data-urlencode "limit=$limit"
      ;;
    chat)
      local chat_id="${2:-${TELEGRAM_CHAT_ID:-}}"
      if [[ -z "$chat_id" ]]; then
        echo "Missing chat id. Pass one or set TELEGRAM_CHAT_ID." >&2
        exit 2
      fi
      call_get getChat --data-urlencode "chat_id=$chat_id"
      ;;
    send-message)
      local chat_id=""
      local text=""
      if [[ $# -ge 3 ]]; then
        chat_id="$2"
        text="$3"
      else
        chat_id="${TELEGRAM_CHAT_ID:-}"
        text="${2:-}"
      fi
      if [[ -z "$chat_id" || -z "$text" ]]; then
        echo "Usage: scripts/telegram_api.sh send-message [chat_id] <text>" >&2
        exit 2
      fi

      local args=(-F "chat_id=$chat_id" -F "text=$text")
      if [[ -n "${TELEGRAM_PARSE_MODE:-}" ]]; then
        args+=(-F "parse_mode=$TELEGRAM_PARSE_MODE")
      fi
      call_post_form sendMessage "${args[@]}"
      ;;
    raw)
      local method="${2:-}"
      local payload="${3:-{}}"
      if [[ -z "$method" ]]; then
        echo "Usage: scripts/telegram_api.sh raw <method> [json_payload]" >&2
        exit 2
      fi
      call_post_json "$method" "$payload"
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
}

main "$@"
