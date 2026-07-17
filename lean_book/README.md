# Lean for Working Algebraists

[Changelog](CHANGELOG.md) | [Latest release (PDF)](https://github.com/abderrahim-lectures/lean4-learning/releases/latest)

A guide to Lean 4 for readers who already think in groups, rings, functors,
and diagrams, but have never written a line of Lean (or any proof
assistant). We assume no programming background — only the mathematical
maturity of someone comfortable with abstract algebra and the basic language
of category theory (objects, morphisms, composition, functors). The book
builds up Lean 4 syntax and tactics only as far as needed to formalize
groups, rings, and quiver path algebras — the categorical viewpoint (a
quiver's path category, a ring as a one-object preadditive category, etc.)
is called out explicitly wherever it clarifies what the Lean code is really
encoding.

## How to read this book

Not every reader needs every chapter in order — see
[Learning paths](learning-paths.md) for a chapter-dependency graph and a
handful of named paths through the book (already know Lean? already know
algebra? want the formal foundations first?) before committing to reading
start to finish.

Each chapter is its own folder (e.g. [06-groups/](06-groups/)) containing a
`00-index.md` overview plus one small Markdown file per section — open the
chapter's `00-index.md` first, which links to every section in order. LaTeX
math is written inline as `$...$` and in display blocks as `$$...$$`; render
with any Markdown viewer that supports MathJax/KaTeX (e.g. VS Code with a
Markdown+Math extension, or Pandoc). A handful of category-theory diagrams
(the universal-property/initial-object/forgetful-functor entries in the
Chapter 1 §4 glossary, the product/coproduct pictures in Chapter 3, the
running quiver example in Chapter 11, and the chapter-dependency graph in
[Learning paths](learning-paths.md)) are written as
[Mermaid](https://mermaid.js.org/) diagrams — these render natively on
GitHub and in VS Code with the "Markdown Preview Mermaid Support"
extension; in a viewer without Mermaid support they fall back to a
readable fenced code block showing the diagram's source instead of a
rendering error.

Code blocks are valid Lean 4 (toolchain `v4.31.0`, matching
`../lean_project`). Every code block in Chapters 1–11 has been ported into
`../lean_project/LeanProject/` (one module per chapter) and verified with
`lake build` against the real compiler, not just read over — several bugs
that only surfaced this way (a missing extensionality lemma, a couple of
`rw` steps that over-rewrote, a reference to an undefined `intZModule`,
Mathlib's `ring` tactic used without Mathlib ever being imported) have
been fixed in both the book text and the project. You're encouraged to
open `lean_project` yourself and run `lake build`/`lake exe lean_project`
to see it compile.

This book is about more than the constructs it covers — the running goal is
to build the *skill* of using Lean: reading a goal state, deciding what to
try next, recovering when a tactic fails, and knowing which proofs to
derive by hand versus hand off to automation. Chapters 7 and 9 in
particular present each theorem as a search process (what to look at, what
to try, why an attempt fails) rather than only the polished final proof;
Chapter 12 is dedicated entirely to working efficiently once the underlying
ideas are understood. Chapter 5 pauses to address the rigor questions a
careful mathematician will already be asking by that point — `structure`
versus `class`, universes, and definitional versus propositional equality —
before committing to `Group`'s definition in Chapter 6.

This book is, and remains, Mathlib-free by design: every group, ring, and
path algebra is built from scratch so you see every definition and proof
obligation explicitly (see [the Mathlib note](00-setup/04-mathlib-note.md)).
Starting in Chapter 6, though, each worked example is followed by a clearly
labeled "Mathlib equivalent" box showing the same statement phrased against
Mathlib's real `Group`/`Ring`/`Module` API. This isn't a contradiction of
the from-scratch approach — it's a second, parallel track. Seeing the same
idea twice, once built by hand and once as Mathlib already has it, is how
you learn both halves of working in Lean at once: the underlying
mathematics *and* the shape of the library you'll actually use once you
leave this book. Chapter 13 then completes the handoff to Mathlib in full.

The book has been through several editorial passes: a first pass checking
for foundational terms used before they're explained, thin worked-example
coverage, and outright factual errors; a second, accessibility-focused
pass that caught "Mathematical reading" boxes drifting past the book's own
promised background (a shared glossary now lives at
[Chapter 1 §4](01-basics/04-terminology.md), and
[Chapter 3 §2](03-propositions-and-proofs/02-logic-recap.md) recaps
standard logic from scratch for readers meeting it for the first time) and added
optional "Programmer's corner (Python)" boxes alongside the "Mathematical
reading" ones; and a third, readability-focused pass that put every worked
example in its own block immediately followed by its own explanation
(rather than several examples dumped together, explained afterward all at
once) and added plain-text category-theory diagrams at the natural spots.
See [CHANGELOG.md](CHANGELOG.md) for the full, itemized history.

## Table of contents

**Part I — Lean fundamentals**

0. [Setting up Lean 4](00-setup/00-index.md)
1. [First steps: terms, types, `#eval`](01-basics/00-index.md)
2. [Functions, definitions, and structures](02-functions-and-structures/00-index.md)
3. [Propositions as types, and basic proofs](03-propositions-and-proofs/00-index.md)
4. [Tactics, and how to work a goal you don't know the proof of](04-tactics/00-index.md)
5. [Rigor check: structures, universes, and equality](05-rigor-check/00-index.md)

**Part II — Algebra, formalized**

6. [Structures and classes: defining a `Group`](06-groups/00-index.md)
7. [Group examples and basic theorems](07-group-theorems/00-index.md)
8. [Rings: adding a second operation](08-rings/00-index.md)
9. [Ring examples and basic theorems](09-ring-theorems/00-index.md)
10. [Modules over a ring](10-modules/00-index.md)
11. [Quivers and path algebras](11-path-algebras/00-index.md)

**Part III — Working with Lean, and beyond**

12. [Working efficiently in Lean](12-working-efficiently/00-index.md)
13. [Where to go next](13-next-steps/00-index.md)

**Appendix**

14. [Solutions to exercises](14-appendix-solutions/00-index.md)

**Reference**

- [Learning paths](learning-paths.md) — a chapter-dependency graph and
  named reading paths for different starting points.
- [Tactic and library reference](tactic-and-library-reference.md) — every
  tactic used in the book, and every Mathlib name from Chapters 6-11's
  "Mathlib equivalent" boxes, each linked to its official documentation.
- [λ-calculus / type theory to Lean dictionary](lambda-calculus-dictionary.md) —
  a lookup table connecting the formal notation in this book's
  "Mathematical reading" boxes back to Lean syntax, term by term.
- [Bibliography](bibliography.md) — every external source cited in any
  chapter's "References" section, consolidated into one list with one
  citation style; each chapter links back to the entries it uses.

## Building the LaTeX manuscript

`python build/build_latex.py` converts every chapter's Markdown into a
full LaTeX manuscript under [`latex/`](latex/): one `.tex` file per
Markdown section (mirroring the source layout exactly), a driver per
chapter, and a top-level `latex/lean-for-working-algebraists.tex`. This
is real, professional LaTeX — proper `\chapter`/`\section` structure with
styled headings and running headers, `amsthm`/`tcolorbox` environments
for the book's recurring boxes ("Mathematical reading," "Programmer's
corner," checkpoint projects), every former Mermaid diagram hand-translated
to native `tikz-cd` (in [`latex/diagrams/`](latex/diagrams/), each with
its own standalone compile smoke-test in
[`latex/smoketest/`](latex/smoketest/)), Lean and Python code via the
`listings` package (styled in [`latex/lean-listings.tex`](latex/lean-listings.tex)),
and a single `latex/references.bib` cited via `biblatex`. The script only
emits `.tex` — no PDF is a build artifact of this repository; compile it
yourself once a LaTeX distribution (e.g. MiKTeX or TeX Live) with
`xelatex`, `biber`, and the `tikz-cd`/`tcolorbox`/`titlesec`/`fancyhdr`
packages is available:

```sh
cd latex
xelatex lean-for-working-algebraists.tex
biber lean-for-working-algebraists
xelatex lean-for-working-algebraists.tex
xelatex lean-for-working-algebraists.tex
```

(three `xelatex` passes plus one `biber` run is the standard sequence
needed to fully resolve cross-references and the bibliography.)

## Navigation

Every chapter file has a navigation strip at the top (link back to this
menu, plus previous/next chapter) and a matching one at the bottom, so you
can move through the book without returning here each time.

## License

MIT — see [LICENSE](../LICENSE).
