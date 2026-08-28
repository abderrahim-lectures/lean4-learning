---
name: latex-typesetting-reviewer
description: Adversarial review of LaTeX/PDF typesetting output — checks formatting consistency, equation rendering, diagram quality (tikz-cd), cross-reference integrity, code-block styling, and overall visual correctness against the source Markdown. Use after running the LaTeX build pipeline (build_latex.py -> xelatex -> biber) to verify the PDF is production-ready.
---
> **See also:** `second-brain/SKILL.md` routes across this repo's review skills. Run after `lean_book_latex/build/build_pdf.sh`, not on the Markdown source directly.


# LaTeX Typesetting Reviewer

A textbook is never "done" until the PDF renders correctly. This skill
checks the **typeset output** of `lean-for-working-algebraists.tex` for
formatting defects that no Markdown review would catch: equation
overflow, broken cross-references, diagram misplacement, code-block
clipping, and typography regressions.

## Operating stance

- **Output-first.** Read the PDF output, not the source. A Markdown
  file can look perfect while the rendered LaTeX breaks — check the
  actual `.pdf` or the `latexmk` log.
- **Verbatim comparison.** Where the source Markdown makes a specific
  formatting claim (e.g. "Section 5 of Chapter 3"), verify the PDF's
  section numbering matches.
- **Typography as correctness.** A widowed line, a clipped equation, or
  a diagram drawn in a code block (instead of rendered) is not "polish"
  — it is a readability defect that interrupts the reader.

## What to check

| Category | Checks |
|---|---|
| **Cross-references** | Every `\ref`/`\hyperref` resolves to the correct target. No "??" placeholders. Section numbers match the reading order described in the prose. |
| **Equations** | No display-math overflows (`\overflow`). Inline math does not break across lines. `align`/`alignat` environments have matching `&` and `\\`. Matrix/table columns align. |
| **Diagrams** | Every `tikz-cd` diagram compiles and matches its source `.tex` in `lean_book_latex/diagrams/`. No Mermaid source appears unrendered in the PDF. Diagrams are positioned at the point they are first referenced, not floating far away. |
| **Code blocks** | `lstlisting` blocks for Lean and Python render with correct syntax styling (check against `lean-listings.tex` styles). No code block is clipped at page boundaries. Line numbers (if enabled) are consistent. |
| **Boxes** | `mathreading`, `progcorner`, `pblproject`, `tcolorbox` environments render with correct titles, borders, and background. No box content overflows or is cut off. |
| **Page layout** | Consistent margins, running headers (`fancyhdr`), chapter titles. No orphan/widow lines in key sections. Page numbers are sequential and correct. |
| **Bibliography** | `biber`/`biblatex` resolves every `\cite{Key}` to a `references.bib` entry. No "References" section contains empty or `?` entries. Citation numbers/style is consistent. **Known recurring risk in this repo:** `lean_book/bibliography.md` (Markdown, human-facing) and `lean_book_latex/references.bib` (BibTeX) are two hand-maintained copies of the same source list that must be kept in sync manually — a citation added to one and not the other renders as "undefined" only in the PDF, never in the Markdown. Whenever any citation was added or changed, diff the key sets of both files directly (`grep -o '\[[A-Za-z0-9]*\]:' bibliography.md` vs `grep -o '@\w*{[A-Za-z0-9]*,' references.bib`) rather than relying solely on a clean `latexmk` log — this exact gap has recurred more than once in this project's history. |
| **Index/table of contents** | TOC entries match the actual chapter/section structure. Page numbers in the TOC match the rendered pages. (If an index exists.) |

## Build verification

Before reviewing, confirm the build pipeline:

```sh
python3 lean_book_latex/build/build_latex.py
cd lean_book_latex
latexmk -xelatex lean-for-working-algebraists.tex
biber lean-for-working-algebraists
latexmk -xelatex lean-for-working-algebraists.tex
```

Check `latexmk` output for:
- **Overfull hbox/vbox warnings** — indicate content overflowing margins
- **Underfull hbox warnings** — indicate poor line-breaking
- **Package warnings** — `hyperref`, `cleveref`, `tcolorbox` configuration issues
- **Citation warnings** — undefined citations (`There were undefined citations`)
- **Reference warnings** — undefined references (`There were undefined references`)

## Finding bar

Each finding must answer:

1. **WHAT** — the specific defect (e.g. "equation on page 42 overflows into the right margin by 3mm") and the PDF page number / source `file:line`.
2. **WHY** — the reader harm (clipped math is unreadable; a broken cross-reference wastes time; a floating diagram confuses the argument flow).
3. **IMPACT** — `CRITICAL` (unreadable/clipped content), `HIGH` (broken cross-ref or citation), `MEDIUM` (poor page break or widowed line), `LOW` (minor typography).
4. **FIX** — the specific repair (e.g. "wrap in `\\begin{adjustbox}{width=\\textwidth}`", "move `\\caption` before the float", "add `\\needspace{4em}` before the heading").

## Triage gate

| Genuine fault — report it | Manufactured noise — drop it |
|---|---|
| A clipped equation or diagram | A font choice you personally dislike |
| A broken cross-reference (`??` or wrong target) | A color scheme the author chose intentionally |
| A code block cut off at a page boundary | A margin width within 1mm of the spec |
| An undefined citation or reference | A float position that is acceptable per the book's style |

## Citation requirement

Every finding MUST anchor to a verifiable source: the PDF page number,
a `latexmk` log warning, a TikZ error message, or the book's own
cross-reference table. "This diagram looks misaligned" without a page
number and log warning is not a finding.


Write `REVIEW-LATEX.md`:

1. **Summary** — 2–3 sentences confirming you reviewed the PDF output.
2. **Recommendation** — `Accept` / `Minor revisions` / `Major revisions` / `Reject`.
3. **Major concerns** — severity-ordered. `CRITICAL`: clipped/unreadable content. `HIGH`: broken cross-refs/citations. `MEDIUM`: layout/page-break issues. `LOW`: typography polish.
4. **Minor concerns** — `LOW` only.
5. **Build log** — which warnings appeared and which are actionable.

## Recommended free models

- `mimo-v2.5-free` — best for structural review (cross-ref integrity,
  equation overflow, diagram positioning) across the full PDF.
- `ling-3.0-flash-free` — best for fast first-pass scanning of all
  276 pages for obvious defects (clipped content, `??` placeholders).
- `nemotron-3-ultra-free` — best for final adjudication of competing
  findings from multiple models reviewing the same pages.
