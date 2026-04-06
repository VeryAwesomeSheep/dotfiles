#!/bin/bash

CACHE_FILE="$HOME/.cache/updates_status"
MAX_AGE=60 # Maximum allowed age of the cache file in minutes

is_cache_valid() {
  if [ -n "$(find "$CACHE_FILE" -mmin -"$MAX_AGE" 2>/dev/null)" ]; then
    return 0
  else
    return 1
  fi
}

case "$1" in
  --fetch)
    {
      checkupdates 2>/dev/null || true
      yay -Qua 2>/dev/null || true
    } > "${CACHE_FILE}.tmp"

    mv "${CACHE_FILE}.tmp" "$CACHE_FILE"
    exit 0
    ;;

  --simple)
    if ! is_cache_valid; then echo ""; exit 0; fi

    wc -l < "$CACHE_FILE"
    ;;

  --waybar)
    if ! is_cache_valid; then echo '{"text": "", "tooltip": ""}'; exit 0; fi

    count=$(wc -l < "$CACHE_FILE")

    if [ "$count" -eq 0 ]; then
      echo '{"text": "", "tooltip": ""}'
    else
      table=$(head -n 30 "$CACHE_FILE" | column -t)
      tooltip_content=$(printf "Updates: %s\n\n<tt>%s</tt>" "$count" "$table")

      if [ "$count" -gt 30 ]; then
        tooltip_content=$(printf "%s\n...and %d more" "$tooltip_content" "$((count - 30))")
      fi

      # 'c' is important here as it outputs JSON on a single line which is needed for waybar
      jq -cn \
        --arg text "" \
        --arg tooltip "$tooltip_content" \
        '{"text": $text, "tooltip": $tooltip}'
    fi
    ;;

  --update)
    kitty -e yay
    "$0" --fetch
    exit 0
    ;;

  *)
    echo "Usage: $0 {--fetch|--simple|--waybar|--update}"
    exit 1
    ;;
esac
