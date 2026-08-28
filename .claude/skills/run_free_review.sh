#!/usr/bin/env bash
# Run adversarial reviews of lean_book using ALL free opencode models, each
# assigned to its best topic. Three phases:
#   1. per-model sequential review of its slice (one at a time)
#      -> reviews/<DATE>/run-*/p1-reviews/
#   2. cross-critique: each model attacks the others' findings
#      -> reviews/<DATE>/run-*/p2-critiques/
#   3. adjudication: nemotron synthesizes a final, deduped, fix-ready report
#      -> reviews/<DATE>/run-*/p3-adjudication/
#
# Each invocation writes into a timestamped run folder (reviews/<DATE>/run-<HHMMSS>/)
# so the "last ones" are always the newest run folder / newest timespan in the
# report filenames. Each model runs inside a pseudo-TTY (via `script`), so you
# SEE its live session — tool calls, file reads, streaming output — on the
# terminal while the full transcript is logged for report extraction. Phases
# are RESUMABLE: re-running p1/p2/p3 reuses the latest run folder and skips
# any model whose report already exists on disk (saved and reused — important
# on a slow connection). Use `--fresh` to force a new run.
#
# Usage:
#   ./run_free_review.sh                  # p1, p2, p3 in sequence (resumable)
#   ./run_free_review.sh p1               # Phase 1 only (resume or new run)
#   ./run_free_review.sh p2               # Phase 2 only (uses latest run's p1)
#   ./run_free_review.sh p3               # Phase 3 only (uses latest run's p1+p2)
#   ./run_free_review.sh p1 --fresh       # Phase 1 in a brand-new run folder
#   ./run_free_review.sh p1 nemotron      # Phase 1, only models matching 'nemotron'
#   ./run_free_review.sh runs             # list run folders, newest first
#   ./run_free_review.sh latest           # show files in the newest run folder
#   ./run_free_review.sh help             # this message
set -uo pipefail
# Don't use -e: we want to continue even if one model fails

BOOK="$(pwd)/lean_book"
SKILLS="$(pwd)/skills"
DATE="$(date +%F)"
BASE="$(pwd)/reviews/$DATE"
MODELS=(nemotron-3-ultra-free laguna-s-2.1-free north-mini-code-free deepseek-v4-flash-free ling-3.0-flash-free mimo-v2.5-free)

stamp() { date +%H%M%S; }
RUN=""
COUNTER=""

usage() {
  sed -n '2,25p' "$0"
}

latest_run() {
  ls -1dt "$BASE"/run-* 2>/dev/null | head -1
}

# Newest non-raw, non-empty .md report matching prefix in $1/$2, or "" if none.
existing_report() {
  local dir="$1" prefix="$2" f
  for f in "$dir"/"$prefix"*.md; do
    [ -e "$f" ] || continue
    [[ "$(basename "$f")" != *-raw.md ]] || continue
    [ -s "$f" ] || continue
    echo "$f"
    return
  done
  echo ""
}

# Pick the run folder to work in.
#   ensure_run [--fresh]
# Reuses the latest run folder whenever one exists (so p1, p2, p3 all write
# into the same run during `all`); creates a new run folder only with --fresh
# or when nothing exists yet.
ensure_run() {
  local fresh=""
  [ "${1:-}" = "--fresh" ] && fresh=1 && shift
  if [ -z "$fresh" ]; then
    RUN="$(latest_run)"
    if [ -n "$RUN" ]; then
      echo "[run] resuming $RUN"
      COUNTER="$RUN/.counter"
      : > "$COUNTER"
      return
    fi
  fi
  RUN="$BASE/run-$(stamp)"
  mkdir -p "$RUN"
  echo "[run] created $RUN"
  COUNTER="$RUN/.counter"
  : > "$COUNTER"
}

# Extra context injected into every Phase-1 prompt: v1.4.25 regression alert
REGRESSION_CTX="IMPORTANT: This book just underwent v1.4.25/v1.5.0 changes — toolchain pinned to v4.32.2 everywhere (project *and* docs, after a brief v1.5.0 doc-side bump to the unpublished v4.33.0 was reverted), 'Bloom verbs made implicit' (explicit 'Learning objectives' paragraphs were REMOVED from every chapter's 00-index.md and replaced with narrative 'story of this chapter' sections). v1.5.0: LaTeX removed 'Story' and 'Sections' sections. Your Regression Tracker persona MUST specifically check for issues introduced by these changes: broken cross-references to removed sections, version numbers inconsistent with v4.32.2 (the one true version), or gaps where removed scaffolding leaves exercises or theorems unmoored. All version references — lean_project/lean-toolchain, lakefile.toml, README.md, NOTICE.md, lean_book/README.md, lean_book/00-setup/02-installing-toolchain.md, lean_book/00-setup/04-mathlib-note.md, lean_book/learning-paths.md — should read v4.32.2."

# Run opencode inside a pseudo-TTY (via `script`) so its live progress — tool
# calls, file reads, streaming output — is visible on the terminal while the
# full ANSI transcript is captured to a log for report extraction.
# Usage: run_opencode <model> <prompt-file> <transcript-log>
run_opencode() {
  local model="$1" prompt_file="$2" log="$3"
  # Prompt is piped via stdin (not argv) so it is NOT echoed into the
  # transcript header, keeping report markers clean for extraction.
  timeout 1800 script -q -c "opencode run --model opencode/$model < '$prompt_file'" "$log"
}

# --- Phase 1: per-model, per-topic review -----------------------------
# Each model gets the files of its slice as its argument list. The skill
# file path is passed first so the model loads the full reviewer instructions.
run_slice() {
  local model="$1" topic="$2" skill="$3"
  shift 3
  local files="$*"
  local start end final dir prompt
  start="$(stamp)"
  dir="$RUN/p1-reviews"
  mkdir -p "$dir" "$RUN/prompts" "$RUN/logs"
  prompt="$RUN/prompts/p1-$model.md"
  {
    echo "You are an adversarial, brutally honest reviewer following the skill file"
    echo "$SKILLS/$skill/SKILL.md . Read that skill file FIRST and obey it exactly."
    echo ""
    echo "Your assigned slice of the book. Use the Read tool to read EVERY file"
    echo "listed below before finding anything. NEVER cite a finding you did not"
    echo "actually read; every finding needs a file:line from the text."
    echo ""
    echo "$files"
    echo ""
    echo "Produce your complete referee report (Summary, Recommendation,"
    echo "severity-ordered Major concerns with WHAT/WHY/IMPACT/FIX, Minor concerns,"
    echo "and a Verification log) as your final message. Be brutally honest and"
    echo "direct; do not soften findings, do not manufacture them."
    echo ""
    echo "Wrap your ENTIRE report between the lines <<<REPORT_START>>> and"
    echo "<<<REPORT_END>>>. Nothing before or after those markers."
    echo ""
    echo "$REGRESSION_CTX"
  } > "$prompt"
  echo "[p1] $model ($topic) — $(echo "$files" | wc -w) files"
  run_opencode "$model" "$prompt" "$RUN/logs/p1-$model-$start.log"
  end="$(stamp)"
  final="$dir/$model-$topic-${start}_${end}.md"
  # Extract the report from the ANSI transcript: strip colours, drop CR,
  # then take the section between the report markers.
  sed 's/\x1b\[[0-9;]*m//g' "$RUN/logs/p1-$model-$start.log" | tr -d '\r' \
    | awk '/<<<REPORT_START>>>/{f=1;next}/<<<REPORT_END>>>/{f=0}f' \
    > "$final"
  if [ -s "$final" ]; then
    echo "  -> $(wc -l < "$final") lines: $(basename "$final")"
  else
    echo "  !! $model produced no report; transcript saved as -raw.md"
    cp "$RUN/logs/p1-$model-$start.log" "$dir/$model-$topic-${start}_${end}-raw.md"
    final="$dir/$model-$topic-${start}_${end}-raw.md"
  fi
  echo "$model" >> "$COUNTER"
}

p1() {
  local fresh="" filter="" arg
  for arg in "$@"; do
    [ "$arg" = "--fresh" ] && fresh=1 && continue
    filter="$arg"
  done
  ensure_run ${fresh:+--fresh}
  local reused=0 model topic skill
  launch_slice() {
    model="$1" topic="$2" skill="$3"
    shift 3
    if [ -n "$filter" ] && [[ "$model" != *"$filter"* ]]; then return; fi
    local done
    done="$(existing_report "$RUN/p1-reviews" "$model-")"
    if [ -n "$done" ]; then
      echo "[p1] reuse $model — $(basename "$done") ($(wc -l < "$done") lines)"
      echo "$model" >> "$COUNTER"
      reused=$((reused+1))
      return
    fi
    run_slice "$model" "$topic" "$skill" "$@"
  }
  launch_slice nemotron-3-ultra-free math-theorems adversarial-maths-reviewer $math_files_1
  launch_slice laguna-s-2.1-free math-algebra adversarial-maths-reviewer $math_files_2
  launch_slice north-mini-code-free lean-code adversarial-maths-reviewer $code_files
  launch_slice deepseek-v4-flash-free solutions adversarial-maths-reviewer $sol_files
  launch_slice ling-3.0-flash-free root-notice adversarial-book-reviewer $root_files
  launch_slice mimo-v2.5-free prose-setup adversarial-book-reviewer $prose_files
  local fails=0
  for f in "$RUN"/p1-reviews/*-raw.md; do [ -e "$f" ] && fails=$((fails+1)); done
  echo "[p1] done — $(ls "$RUN"/p1-reviews/*.md 2>/dev/null | wc -l) reports, $fails failed, $reused reused"
  echo "[p1] -> $RUN/p1-reviews/"
}

math_files_1="$(ls "$BOOK"/03-propositions-and-proofs/*.md "$BOOK"/05-rigor-check/*.md "$BOOK"/06-groups/*.md "$BOOK"/07-group-theorems/*.md)"
math_files_2="$(ls "$BOOK"/08-rings/*.md "$BOOK"/09-ring-theorems/*.md "$BOOK"/10-modules/*.md "$BOOK"/11-path-algebras/*.md)"
code_files="$(ls "$BOOK"/01-basics/*.md "$BOOK"/02-functions-and-structures/*.md "$BOOK"/04-tactics/*.md "$BOOK"/12-working-efficiently/*.md "$BOOK"/tactic-and-library-reference.md)"
sol_files="$(ls "$BOOK"/14-appendix-solutions/*.md)"
prose_files="$(ls "$BOOK"/00-setup/*.md "$BOOK"/13-next-steps/*.md "$BOOK"/README.md "$BOOK"/lambda-calculus-dictionary.md "$BOOK"/notation-reference.md "$BOOK"/learning-paths.md "$BOOK"/bibliography.md)"
root_files="$(ls "$(pwd)/README.md" "$(pwd)/NOTICE.md" "$(pwd)/CONTRIBUTING.md" "$(pwd)/REPRODUCING.md")"

# --- Phase 2: cross-critique -------------------------------------------
# Each model reads ALL other models' review reports and critiques them:
# which findings are robust (evidence-backed, file:line present, corroborated)
# vs. weak (vague, no file:line, contradicted by the text).
run_critique() {
  local model="$1" peers="$2"
  local start end final dir prompt
  start="$(stamp)"
  dir="$RUN/p2-critiques"
  mkdir -p "$dir" "$RUN/prompts" "$RUN/logs"
  prompt="$RUN/prompts/p2-$model.md"
  {
    echo "You are an adversarial reviewer doing cross-critique. Read the skill"
    echo "$SKILLS/adversarial-book-reviewer/SKILL.md for your operating stance."
    echo ""
    echo "Below are review reports from OTHER models that already reviewed the"
    echo "book. Your job: attack each report's findings. For EACH finding"
    echo "cited, check whether it has a verifiable file:line, whether the"
    echo "quoted evidence actually supports the claim, and whether another"
    echo "reviewer corroborated it. Flag findings that are vague, lack"
    echo "file:line citations, or contradict the actual text."
    echo ""
    echo "The peer review reports are:"
    echo ""
    echo "$peers"
    echo ""
    echo "Produce your critique as your final message, wrapped between"
    echo "<<<CRITIQUE_START>>> and <<<CRITIQUE_END>>>."
  } > "$prompt"
  echo "[p2] $model — critiquing $(echo "$peers" | wc -w) peer reports"
  run_opencode "$model" "$prompt" "$RUN/logs/critique-$model-$start.log"
  end="$(stamp)"
  final="$dir/critique-$model-${start}_${end}.md"
  sed 's/\x1b\[[0-9;]*m//g' "$RUN/logs/critique-$model-$start.log" | tr -d '\r' \
    | awk '/<<<CRITIQUE_START>>>/{f=1;next}/<<<CRITIQUE_END>>>/{f=0}f' \
    > "$final"
  if [ -s "$final" ]; then
    echo "  -> $(wc -l < "$final") lines: $(basename "$final")"
  else
    echo "  !! $model produced no critique; transcript saved as -raw.md"
    cp "$RUN/logs/critique-$model-$start.log" "$dir/critique-$model-${start}_${end}-raw.md"
    final="$dir/critique-$model-${start}_${end}-raw.md"
  fi
  echo "$model" >> "$COUNTER"
}

p2() {
  local fresh="" filter="" arg
  for arg in "$@"; do
    [ "$arg" = "--fresh" ] && fresh=1 && continue
    filter="$arg"
  done
  ensure_run ${fresh:+--fresh}
  local p1dir="$RUN/p1-reviews" reused=0 model peers
  local reports
  reports="$(ls "$p1dir"/*.md 2>/dev/null)"
  if [ -z "$reports" ]; then
    echo "[p2] no Phase-1 reports in $p1dir — run p1 first" >&2
    exit 1
  fi
  for model in "${MODELS[@]}"; do
    if [ -n "$filter" ] && [[ "$model" != *"$filter"* ]]; then continue; fi
    local done
    done="$(existing_report "$RUN/p2-critiques" "critique-$model-")"
    if [ -n "$done" ]; then
      echo "[p2] reuse $model — $(basename "$done") ($(wc -l < "$done") lines)"
      echo "$model" >> "$COUNTER"
      reused=$((reused+1))
      continue
    fi
    peers=""
    for f in $reports; do
      [[ "$(basename "$f")" == "$model"* ]] && continue
      peers="$peers $f"
    done
    run_critique "$model" "$peers"
  done
  local fails=0
  for f in "$RUN"/p2-critiques/*-raw.md; do [ -e "$f" ] && fails=$((fails+1)); done
  echo "[p2] done — $(ls "$RUN"/p2-critiques/*.md 2>/dev/null | wc -l) critiques, $fails failed, $reused reused"
  echo "[p2] -> $RUN/p2-critiques/"
}

# --- Phase 3: adjudication ---------------------------------------------
# The strongest free model reads all reviews and critiques, then synthesizes
# a final, deduplicated, fix-ready report.
p3() {
  ensure_run
  local start end final dir prompt
  local reports critiques
  start="$(stamp)"
  dir="$RUN/p3-adjudication"
  mkdir -p "$dir" "$RUN/prompts" "$RUN/logs"
  reports="$(ls "$RUN"/p1-reviews/*.md 2>/dev/null)"
  critiques="$(ls "$RUN"/p2-critiques/*.md 2>/dev/null)"
  if [ -z "$reports" ]; then
    echo "[p3] no Phase-1 reports — run p1 first" >&2
    exit 1
  fi
  local done
  done="$(existing_report "$RUN/p3-adjudication" "FINAL-REVIEW-")"
  if [ -n "$done" ]; then
    echo "[p3] reuse $done ($(wc -l < "$done") lines)"
    return
  fi
  prompt="$RUN/prompts/p3-adjudication.md"
  {
    echo "You are an adversarial reviewer doing final adjudication. Read the skill files"
    echo "$SKILLS/adversarial-book-reviewer/SKILL.md and"
    echo "$SKILLS/adversarial-maths-reviewer/SKILL.md first."
    echo ""
    echo "Below are Phase-1 review reports and Phase-2 cross-critiques from"
    echo "six free-tier models. Your job: synthesize a SINGLE final report."
    echo ""
    echo "For each finding, mark CONFIRMED if 2+ reviewers found it (and no"
    echo "critique invalidates it), SINGLE if only one reviewer found it (and it"
    echo "survives the critique), or DISMISS if the critique correctly shows it"
    echo "lacks evidence or contradicts the text."
    echo ""
    echo "Deduplicate findings across reviewers. Order by severity"
    echo "(CRITICAL > HIGH > MEDIUM > LOW)."
    echo ""
    echo "The review reports and critiques are:"
    echo ""
    echo "$reports"
    echo ""
    echo "$critiques"
    echo ""
    echo "Produce your final report as REVIEW-FINAL.md content, wrapped between"
    echo "<<<FINAL_START>>> and <<<FINAL_END>>>."
  } > "$prompt"
  echo "[p3] adjudication (reports=$(echo "$reports" | wc -w), critiques=$(echo "$critiques" | wc -w))"
  run_opencode nemotron-3-ultra-free "$prompt" "$RUN/logs/FINAL-$start.log"
  end="$(stamp)"
  final="$dir/FINAL-REVIEW-${start}_${end}.md"
  sed 's/\x1b\[[0-9;]*m//g' "$RUN/logs/FINAL-$start.log" | tr -d '\r' \
    | awk '/<<<FINAL_START>>>/{f=1;next}/<<<FINAL_END>>>/{f=0}f' \
    > "$final"
  if [ -s "$final" ]; then
    echo "  -> $(wc -l < "$final") lines: $(basename "$final")"
  else
    echo "  !! adjudication produced no report; transcript saved as -raw.md"
    cp "$RUN/logs/FINAL-$start.log" "$dir/FINAL-REVIEW-${start}_${end}-raw.md"
    final="$dir/FINAL-REVIEW-${start}_${end}-raw.md"
  fi
  echo "[p3] done -> $RUN/p3-adjudication/"
}

runs_list() {
  local dirs
  dirs="$(ls -1dt "$BASE"/run-* 2>/dev/null)"
  if [ -z "$dirs" ]; then
    echo "no runs yet"
    return
  fi
  echo "$dirs"
}

runs_latest() {
  local run
  run="$(latest_run)"
  if [ -z "$run" ]; then
    echo "no runs yet"
    return
  fi
  echo "$run"
  find "$run" -name '*.md' -printf '  %p (%k KB)\n' 2>/dev/null | sort
}

case "${1:-all}" in
  all|"")
    p1
    p2
    p3
    ;;
  p1|phase1)
    shift
    p1 "$@"
    ;;
  p2|phase2)
    shift
    p2 "$@"
    ;;
  p3|phase3|final)
    shift
    p3 "$@"
    ;;
  runs|list)
    runs_list
    ;;
  latest|show)
    runs_latest
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "Unknown command: $1" >&2
    usage
    exit 1
    ;;
esac
