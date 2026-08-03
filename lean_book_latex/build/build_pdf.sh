#!/usr/bin/env bash
# Build the book PDF end to end, from Markdown source to a finished file.
#
#   lean_book/**.md  --build_latex.py-->  lean_book_latex/**.tex
#                    --xelatex/biber-->   lean_book_latex/lean-for-working-algebraists.pdf
#
# Requires python3, pandoc, xelatex and biber on PATH (see
# .devcontainer/devcontainer.json, which installs all four).
#
# Usage: lean_book_latex/build/build_pdf.sh [--latex-only]
set -euo pipefail

BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LATEX_DIR="$(dirname "$BUILD_DIR")"
MAIN="lean-for-working-algebraists"

for tool in python3 pandoc; do
  command -v "$tool" >/dev/null || { echo "error: $tool not on PATH" >&2; exit 1; }
done

echo "==> Regenerating LaTeX from Markdown"
python3 "$BUILD_DIR/build_latex.py"

if [[ "${1:-}" == "--latex-only" ]]; then
  echo "==> Stopping after .tex generation (--latex-only)"
  exit 0
fi

for tool in xelatex biber; do
  command -v "$tool" >/dev/null || { echo "error: $tool not on PATH" >&2; exit 1; }
done

cd "$LATEX_DIR"
echo "==> xelatex (pass 1 of 3)"
xelatex -interaction=nonstopmode -halt-on-error "$MAIN.tex" >/dev/null
echo "==> biber"
biber "$MAIN" >/dev/null
echo "==> xelatex (pass 2 of 3)"
xelatex -interaction=nonstopmode -halt-on-error "$MAIN.tex" >/dev/null
echo "==> xelatex (pass 3 of 3)"
xelatex -interaction=nonstopmode -halt-on-error "$MAIN.tex" >/dev/null

echo "==> Built $LATEX_DIR/$MAIN.pdf"
grep -c "Warning" "$MAIN.log" | xargs echo "LaTeX warnings in log:"
