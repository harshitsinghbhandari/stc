#!/usr/bin/env bash
# rtk-hook-version: 1
# stc Cursor Agent hook — rewrites shell commands to use stc for token savings.
# Works with both Cursor editor and cursor-cli (they share ~/.cursor/hooks.json).
# Cursor preToolUse hook format: receives JSON on stdin, returns JSON on stdout.
# Requires: stc >= 0.23.0, jq
#
# This is a thin delegating hook: all rewrite logic lives in `stc rewrite`,
# which is the single source of truth (src/discover/registry.rs).
# To add or change rewrite rules, edit the Rust registry — not this file.

if ! command -v jq &>/dev/null; then
  echo "[stc] WARNING: jq is not installed. Hook cannot rewrite commands. Install jq: https://jqlang.github.io/jq/download/" >&2
  exit 0
fi

if ! command -v stc &>/dev/null; then
  echo "[stc] WARNING: stc is not installed or not in PATH. Hook cannot rewrite commands. Install: https://github.com/harshitsinghbhandari/stc#installation" >&2
  exit 0
fi

# Version guard: stc rewrite was added in 0.23.0.
STC_VERSION=$(stc --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
if [ -n "$STC_VERSION" ]; then
  MAJOR=$(echo "$STC_VERSION" | cut -d. -f1)
  MINOR=$(echo "$STC_VERSION" | cut -d. -f2)
  if [ "$MAJOR" -eq 0 ] && [ "$MINOR" -lt 23 ]; then
    echo "[stc] WARNING: stc $STC_VERSION is too old (need >= 0.23.0). Upgrade: brew upgrade stc" >&2
    exit 0
  fi
fi

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$CMD" ]; then
  echo '{}'
  exit 0
fi

# Delegate all rewrite logic to the Rust binary.
# stc rewrite exits 1 when there's no rewrite — hook passes through silently.
REWRITTEN=$(stc rewrite "$CMD" 2>/dev/null) || { echo '{}'; exit 0; }

# No change — nothing to do.
if [ "$CMD" = "$REWRITTEN" ]; then
  echo '{}'
  exit 0
fi

jq -n --arg cmd "$REWRITTEN" '{
  "permission": "allow",
  "updated_input": { "command": $cmd }
}'
