#!/usr/bin/env bash
# loadline installer. Reads nothing, sends nothing, installs one shell script.
set -euo pipefail
DEST="${LOADLINE_DIR:-$HOME/.claude/scripts}"
SRC="https://raw.githubusercontent.com/SharminSirajudeen/loadline/main/bin/loadline"
SETTINGS="$HOME/.claude/settings.json"

command -v jq >/dev/null || { echo "loadline needs jq:  brew install jq"; exit 1; }
mkdir -p "$DEST"
curl -fsSL "$SRC" -o "$DEST/loadline"
chmod +x "$DEST/loadline"
echo "installed: $DEST/loadline"

if [ -f "$SETTINGS" ] && grep -q '"statusLine"' "$SETTINGS"; then
  echo
  echo "You already have a statusLine configured. Leaving it alone."
  echo "To switch, set it to:  $DEST/loadline"
elif command -v jq >/dev/null; then
  tmp=$(mktemp)
  [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
  jq --arg c "$DEST/loadline" '.statusLine = {type:"command", command:$c}' "$SETTINGS" > "$tmp"
  mv "$tmp" "$SETTINGS"
  echo "wired into $SETTINGS"
fi
echo
echo "Restart Claude Code to see it."
