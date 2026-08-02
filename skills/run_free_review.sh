#!/usr/bin/env bash
# Run adversarial reviews of lean_book using ALL free opencode models, each
# assigned to its best topic. Three phases:
#   1. per-model parallel review of its slice  -> reviews/<DATE>/<model>-<topic>.md
#   2. cross-critique: each model attacks the others' findings
#      -> reviews/<DATE>/critique-<model>.md
#   3. adjudication: nemotron synthesizes a final, deduped, fix-ready report
#      -> reviews/<DATE>/FINAL-REVIEW.md
set -uo pipefail
# Don't use -e: we want to continue even if one model fails

BOOK="$(pwd)/lean_book"
SKILLS="$(pwd)/skills"
DATE="$(date +%F)"
REV="$(pwd)/reviews/$DATE"
mkdir -p "$REV/prompts"

# Extra context injected into every Phase-1 prompt: v1.4.25 regression alert
REGRESSION_CTX="IMPORTANT: This book just underwent v1.4.25 changes — toolchain bumped from v4.31.0 to v4.32.2, and 'Bloom verbs made implicit' (explicit 'Learning objectives' paragraphs were REMOVED from every chapter's 00-index.md and replaced with narrative 'story of this chapter' sections). Your Regression Tracker persona MUST specifically check for issues introduced by these changes: broken cross-references to removed sections, version numbers inconsistent with v4.32.2, or gaps where removed scaffolding leaves exercises or theorems unmoored. All version references — lean_project/lean-toolchain, lakefile.toml, README.md, NOTICE.md, lean_book/README.md, lean_book/00-setup/02-installing-toolchain.md, lean_book/00-setup/04-mathlib-note.md, lean_book/learning-paths.md — should now read v4.32.2."

# --- Phase 1: per-model, per-topic review -----------------------------
# Each model gets the files of its slice as its argument list. The skill
# file path is passed first so the model loads the full reviewer instructions.
run_slice() {
  local model="$1" topic="$2" skill="$3"
  shift 3
  local files="$*"
  local prompt="$REV/prompts/p1-$model.md"
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
  timeout 1800 opencen run --model "opencen/$model" "$(cat "$prompt")" 2>"$REV/$model-$topic.log" \
    | sed 's/\x1b\[[0-9;]*m//g' \
    | awk '/<<<REPORT_START>>>/{f=1;next}/<<<REPORT_END>>>/{f=0}f' \
    > "$REV/$model-$topic.md"
  if ! grep -q "." "$REV/$model-$topic.md"; then
    echo "  !! $model produced no report; saving raw output to log"
    timeout 1800 opencen run --model "opencen/$model" "$(cat "$prompt")" 2>&1 \
      | sed 's/\x1b\[[0-9;]*m//g' > "$REV/$model-$topic-raw.md"
  fi
  echo "  -> $(wc -l < "$REV/$model-$topic.md") lines"
}

math_files_1="$(ls "$BOOK"/03-propositions-and-proofs/*.md "$BOOK"/05-rigor-check/*.md "$BOOK"/06-groups/*.md "$BOOK"/07-group-theorems/*.md)"
math_files_2="$(ls "$BOOK"/08-rings/*.md "$BOOK"/09-ring-theorems/*.md "$BOOK"/10-modules/*.md "$BOOK"/11-path-algebras/*.md)"
code_files="$(ls "$BOOK"/01-basics/*.md "$BOOK"/02-functions-and-structures/*.md "$BOOK"/04-tactics/*.md "$BOOK"/12-working-efficiently/*.md "$BOOK"/tactic-and-library-reference.md)"
sol_files="$(ls "$BOOK"/14-appendix-solutions/*.md)"
prose_files="$(ls "$BOOK"/00-setup/*.md "$BOOK"/13-next-steps/*.md "$BOOK"/README.md "$BOOK"/lambda-calculus-dictionary.md "$BOOK"/notation-reference.md "$BOOK"/learning-paths.md "$BOOK"/bibliography.md)"
root_files="$(ls "$(pwd)/README.md" "$(pwd)/NOTICE.md" "$(pwd)/CONTRIBUTING.md" "$(pwd)/REPRODUCING.md")"

pids=()
run_slice nemotron-3-ultra-free math-theorems adversarial-maths-reviewer $math_files_1 & pids+=($!)
run_slice laguna-s-2.1-free math-algebra adversarial-maths-reviewer $math_files_2 & pids+=($!)
run_slice north-mini-code-free lean-code adversarial-maths-reviewer $code_files & pids+=($!)
run_slice deepseek-v4-flash-free solutions adversarial-maths-reviewer $sol_files & pids+=($!)
run_slice ling-3.0-flash-free root-notice adversarial-book-reviewer $root_files & pids+=($!)
run_slice mimo-v2.5-free prose-setup adversarial-book-reviewer $prose_files & pids+=($!)
for pid in "${pids[@]}"; do wait "$pid"; done
echo "[p1] done"

# --- Phase 2: cross-critique -------------------------------------------
# Each model reads ALL other models' review reports and critiques them:
# which findings are robust (evidence-backed, file:line present, corroborated)
# vs. weak (vague, no file:line, contradicted by the text).
# Output -> reviews/<DATE>/critique-<model>.md
run_critique() {
  local model="$1"
  shift
  local peers="$*"
  local prompt="$REV/prompts/p2-$model.md"
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
  timeout 1800 opencen run --model "opencen/$model" "$(cat "$prompt")" 2>"$REV/critique-$model.log" \
    | sed 's/\x1b\[[0-9;]*m//g' \
    | awk '/<<<CRITIQUE_START>>>/{f=1;next}/<<<CRITIQUE_END>>>/{f=0}f' \
    > "$REV/critique-$model.md"
  if ! grep -q "." "$REV/critique-$model.md"; then
    echo "  !! $model produced no critique; saving raw output to log"
    timeout 1800 opencen run --model "opencen/$model" "$(cat "$prompt")" 2>&1 \
      | sed 's/\x1b\[[0-9;]*m//g' > "$REV/critique-$model-raw.md"
  fi
  echo "  -> $(wc -l < "$REV/critique-$model.md") lines"
}

all_reports=""
for model in nemotron-3-ultra-free laguna-s-2.1-free north-mini-code-free deepseek-v4-flash-free ling-3.0-flash-free mimo-v2.5-free; do
  for f in "$REV/$model-"*.md; do
    all_reports="$all_reports $f"
  done
done

pids2=()
for model in nemotron-3-ultra-free laguna-s-2.1-free north-mini-code-free deepseek-v4-flash-free ling-3.0-flash-free mimo-v2.5-free; do
  peers=""
  for f in $all_reports; do
    if [[ "$f" != *"$model-"* ]]; then
      peers="$peers $f"
    fi
  done
  run_critique "$model" "$peers" & pids2+=($!)
done
for pid in "${pids2[@]}"; do wait "$pid"; done
echo "[p2] done"

# --- Phase 3: adjudication ---------------------------------------------
# The strongest free model reads all reviews and critiques, then synthesizes
# a final, deduplicated, fix-ready report.
adj_prompt="$REV/prompts/p3-adjudication.md"
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
  echo "$all_reports"
  for f in "$REV"/critique-*.md; do
    echo "$f"
  done
  echo ""
  echo "Produce your final report as REVIEW-FINAL.md content, wrapped between"
  echo "<<<FINAL_START>>> and <<<FINAL_END>>>."
} > "$adj_prompt"
echo "[p3] adjudication"
timeout 1800 opencen run --model "opencen/nemotron-3-ultra-free" "$(cat "$adj_prompt")" 2>"$REV/FINAL-REVIEW.log" \
  | sed 's/\x1b\[[0-9;]*m//g' \
  | awk '/<<<FINAL_START>>>/{f=1;next}/<<<FINAL_END>>>/{f=0}f' \
  > "$REV/FINAL-REVIEW.md"
if ! grep -q "." "$REV/FINAL-REVIEW.md"; then
  echo "  !! adjudication produced no report; saving raw output to log"
  timeout 1800 opencen run --model "opencen/nemotron-3-ultra-free" "$(cat "$adj_prompt")" 2>&1 \
    | sed 's/\x1b\[[0-9;]*m//g' > "$REV/FINAL-REVIEW-raw.md"
fi
echo "  -> $(wc -l < "$REV/FINAL-REVIEW.md") lines"
echo "[p3] done"
