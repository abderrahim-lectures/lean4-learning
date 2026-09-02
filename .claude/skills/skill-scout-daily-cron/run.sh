#!/usr/bin/env bash
# Daily local skill-scouting pass for this repo, run headless via cron.
# Report-only: searches the public web for genuinely new Claude Code
# skill-writing patterns applicable to THIS repo's specific work, writes
# findings to reviews/skill-scouting/<date>.md, never modifies any other
# file, never commits, never pushes.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
LOG_DIR="$REPO_DIR/.claude/skills/skill-scout-daily-cron/logs"
mkdir -p "$LOG_DIR"
DATE="$(date +%F)"
LOG_FILE="$LOG_DIR/$DATE.log"

cd "$REPO_DIR"

PROMPT="$(cat "$REPO_DIR/.claude/skills/skill-scout-daily-cron/prompt.md")"

claude -p "$PROMPT" \
  --allowedTools "Read,Grep,Glob,WebSearch,WebFetch,Write,Bash(mkdir *),Bash(date *)" \
  --add-dir "$REPO_DIR" \
  >> "$LOG_FILE" 2>&1

echo "[skill-scout] $DATE run complete, log: $LOG_FILE"
