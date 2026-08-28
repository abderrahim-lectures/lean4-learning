---
name: second-brain
description: Top-level identity and router for this repo — a single book project ("Lean for Working Algebraists") plus its companion Lean/LaTeX/Python tooling. Use at the start of any new thread to decide which of this repo's own skills owns the request, before invoking anything else.
---

# Second brain: this book, and the tooling that builds it

Ported and adapted from `~/dev/research-ideas`'s `second-brain` skill,
which routes across three capacities in a much larger, multi-project
repo. This repo is one project with four facets, not three unrelated
capacities: **the book's prose**, **the book's mathematics**, **the
book's Lean code**, and **the build tooling** (LaTeX/PDF pipeline,
Python companion notebook, review orchestration). Route by which facet
the request actually touches; a single change (a rewritten section) can
touch two or three of these at once, and each facet's review skill
should be run, not just the one that feels most relevant.

## Routing a new request

- **A request to review, audit, or fix the book's prose, structure, or
  pedagogy** (clarity, forcing questions, chapter ordering, terminology
  introduced before use) → `adversarial-book-reviewer` (structure/
  pedagogy/facts) and `prose-style-reviewer` (sentence-level style: no
  possessives, no em-dashes, no colon-led explanations). Run both; a
  file can pass one while failing the other, since neither reads for
  what the other checks.
- **A request to review, audit, or fix the book's mathematics**
  (definitions, theorems, proofs, exercises, worked examples) →
  `adversarial-maths-reviewer`. For category-theory-specific claims
  (quivers as categories, universal properties, functors) also run
  `category-theory-accuracy-reviewer`. For notation used across
  chapters, also run `notation-consistency-reviewer`. For a chapter that
  narrates a proof as a search process (Chapters 8, 10, and the
  checkpoint projects) rather than a polished artifact, also run
  `proof-search-analyst`.
- **A request to review, audit, or fix the book's embedded Lean code**
  (does it compile, does it match the prose, does it fake a proof) →
  `lean-code-auditor`. Always verify empirically (`lake build` in
  `lean_project/`), never accept a code block as correct because it
  "looks right."
- **A request to review the built PDF** (typesetting, diagrams,
  cross-references, code-block styling) → `latex-typesetting-reviewer`,
  after running the build pipeline
  (`lean_book_latex/build/build_pdf.sh`).
- **A request to run the full multi-model adversarial pipeline** (not a
  single targeted check) → `.claude/skills/run_free_review.sh` (phases
  p1/p2/p3: per-model review, cross-critique, adjudication), then
  `claude-final-reviewer` as the closing, human-grade verification pass
  over the accumulated reports.
- **A request to write or fix a skill in this repo** (this file
  included) → treat it the same way `skill-improver` does in the
  research-ideas repo this was ported from: when a review skill's own
  domain produces a real finding it should have caught but did not, add
  the check to that skill's `SKILL.md` in the same session, do not wait
  to be asked twice.

## What "second brain" means operationally, scoped to one book

- Surface a relevant prior review report (`reviews/<date>/...`) or
  changelog entry unprompted when a new request echoes something already
  found and fixed, rather than re-deriving a finding from scratch. Check
  `lean_book/changelog/` and `reviews/` before assuming an issue is new.
- Verify empirically, always: `lake build` for any Lean claim, an actual
  link-existence sweep for any cross-reference claim, an actual
  `build_pdf.sh` run for any typesetting claim. A memory of "this was
  fine last time" is a lead, not proof, the same way a prior report's
  "Accept" verdict does not exempt a file from re-verification if the
  text has since changed.
- Hold every facet's standard simultaneously: a mathematically correct
  section can still fail `prose-style-reviewer`, and a well-written
  section can still contain a faithfulness gap between its prose and its
  Lean code. Running only one review skill and calling a file "done" is
  the specific failure mode this router exists to prevent.

## Central skill catalog

- `adversarial-book-reviewer` — prose, structure, pedagogy, facts.
- `prose-style-reviewer` — sentence-level style (possessives, em-dashes,
  colons, comma pileups, filler/hedge words, spatial metaphors,
  terminology drift). Ported and adapted from research-ideas'
  `style-provenance-check` (Rule 1 only; that skill's graphify/ledger/
  LaTeX-citation-locator rules are specific to that repo's paper
  pipeline and do not apply here).
- `adversarial-maths-reviewer` — definitions, theorems, proofs,
  exercises, worked examples, including embedded Lean code.
- `category-theory-accuracy-reviewer` — category-theory claims
  specifically (Chapters 2, 7, 9, 12).
- `notation-consistency-reviewer` — symbol/notation consistency across
  all chapters.
- `proof-search-analyst` — honesty and accuracy of proof-search
  narratives (Chapters 8, 10, checkpoint projects).
- `lean-code-auditor` — compilation, faithfulness, and proof-integrity
  of every embedded Lean snippet.
- `latex-typesetting-reviewer` — rendered-PDF pass after the build
  pipeline.
- `claude-final-reviewer` — closing adjudication over the multi-model
  pipeline's accumulated reports.
- `run_free_review.sh` — the multi-model orchestration script
  (`p1`/`p2`/`p3`/`all`), at `.claude/skills/run_free_review.sh`.

## Meta

Ported from `~/dev/research-ideas`'s `second-brain` and
`style-provenance-check` skills, adapted to this repo's single-project
scope. Update this catalog whenever a skill is added, renamed, or
removed from `.claude/skills/`.
