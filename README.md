# Lean for Working Algebraists

[Changelog](changelog/README.md) | [Latest release (PDF)](https://github.com/abderrahim-lectures/lean4-learning/releases/latest)

A guide to Lean 4 for readers who already think in groups, rings, functors,
and diagrams, but have never written a line of Lean (or any proof
assistant). We assume no programming background, only the mathematical
maturity of someone comfortable with abstract algebra and the basic language
of category theory (objects, morphisms, composition, functors). The book
builds up Lean 4 syntax and tactics only as far as needed to formalize
groups, rings, and quiver path algebras. The categorical viewpoint (most
substantially, the path category of a quiver as the free category on a quiver
in Chapter 12) is called out explicitly wherever it clarifies what the
Lean code is really encoding.

## Pedagogical approach

This book teaches by derivation, not by dispensation, in the tradition
of Arnold's and Gelfand's teaching rather than Bourbaki's. "It is
impossible to understand an unmotivated definition" (Arnold, *On
Teaching Mathematics*, 1997): every definition and theorem in this book
is *earned*. A section poses the question or concrete problem that forces
a concept, walks the reasoning that discovers it, and only then names
and formalizes the result, mirroring Gelfand's Moscow seminar method of
finding the simplest example that captures a phenomenon before finding
the language to state it generally. There is no fixed
Definition→Theorem→Proof→Remark skeleton imposed on that reasoning;
structure follows the logic of the argument, not a template. Formulas
and theorems are proved before they are used, never handed down as rules
to memorize. Exercises favor fewer, harder, escalating, proof-heavy
problems over repetitive drills, and do not give away their own answer;
solutions live in [15-appendix-solutions/](15-appendix-solutions/00-index.md).
See [CONTRIBUTING.md](../CONTRIBUTING.md#book-prose-conventions) for
the convention as a checklist, and
[Chapter 7](07-groups/00-index.md) for it applied in full.

## How to read this book

Not every reader needs every chapter in order. See
[Learning paths](learning-paths.md) for a chapter-dependency graph and a
handful of named paths through the book (already know Lean? already know
algebra? want the formal foundations first?) before committing to reading
start to finish.

Each chapter is its own folder (e.g. [07-groups/](07-groups/)) containing a
`00-index.md` overview plus one small Markdown file per section. Open the
`00-index.md` of the chapter first, which links to every section in order. LaTeX
math is written inline as `$...$` and in display blocks as `$$...$$`; render
with any Markdown viewer that supports MathJax/KaTeX (e.g. VS Code with a
Markdown+Math extension, or Pandoc). A handful of category-theory diagrams
(the universal-property/initial-object/forgetful-functor entries in the
Chapter 2, Section 1 glossary, the product/coproduct pictures in Chapter 4, the
running quiver example in Chapter 12, and the chapter-dependency graph in
[Learning paths](learning-paths.md)) are written as
[Mermaid](https://mermaid.js.org/) diagrams; these render natively on
GitHub and in VS Code with the "Markdown Preview Mermaid Support"
extension. In a viewer without Mermaid support they fall back to a
readable fenced code block showing the source of the diagram instead of a
rendering error.

Code blocks are valid Lean 4 (toolchain `v4.33.1`, matching
`../lean_project`). Every code block in Chapters 1–12 has been ported into
`../lean_project/LeanProject/` (one module per chapter) and verified with
`lake build` against the real compiler, not just read over. Several bugs
that only surfaced this way (a missing extensionality lemma, a couple of
`rw` steps that over-rewrote, a reference to an undefined `intZModule`,
the `ring` tactic of Mathlib used without Mathlib ever being imported) have
been fixed in both the book text and the project. You're encouraged to
open `lean_project` yourself and run `lake build`/`lake exe lean_project`
to see it compile.

This book is about more than the constructs it covers. The running goal is
to build the *skill* of using Lean, namely reading a goal state, deciding what to
try next, recovering when a tactic fails, and knowing which proofs to
derive by hand versus hand off to automation. Chapters 8 and 10 in
particular present each theorem as a search process (what to look at, what
to try, why an attempt fails) rather than only the polished final proof;
Chapter 13 is dedicated entirely to working efficiently once the underlying
ideas are understood. Chapter 6 pauses to address the rigor questions a
careful mathematician will already be asking by that point, namely `structure`
versus `class`, universes, and definitional versus propositional equality,
before committing to the definition of `Group` in Chapter 7.

This book is, and remains, Mathlib-free by design, every group, ring, and
path algebra is built from scratch so you see every definition and proof
obligation explicitly (see [the Mathlib note](00-setup/04-mathlib-note.md)).
Starting in Chapter 7, though, each worked example is followed by a clearly
labeled "Mathlib equivalent" box showing the same statement phrased against
the real `Group`/`Ring`/`Module` API of Mathlib. This isn't a contradiction of
the from-scratch approach; it's a second, parallel track. Seeing the same
idea twice, once built by hand and once as Mathlib already has it, is how
you learn both halves of working in Lean at once, the underlying
mathematics *and* the shape of the library you'll actually use once you
leave this book. Chapter 14 then completes the handoff to Mathlib in full.

The book has been through several editorial passes, a first pass checking
for foundational terms used before they're explained, thin worked-example
coverage, and outright factual errors; a second, accessibility-focused
pass that caught "Mathematical reading" boxes drifting past the own
promised background of the book (a shared glossary now lives at
[Chapter 2, Section 1](02-terminology-and-coc/01-terminology.md), and
[Chapter 4, Section 2](04-propositions-and-proofs/02-logic-recap.md) recaps
standard logic from scratch for readers meeting it for the first time) and added
optional "Programmer note (Python)" boxes alongside the "Mathematical
reading" ones; and a third, readability-focused pass that put every worked
example in its own block immediately followed by its own explanation
(rather than several examples dumped together, explained afterward all at
once) and added plain-text category-theory diagrams at the natural spots;
and a fourth pass added `dbg_trace`-annotated tracing to every genuinely
recursive Lean definition in the book, so the recursion can be watched
unwinding one call at a time rather than only read about; and a fifth,
narrative-focused pass rewrote the opening of every chapter as a genuine story
(each section framed as the answer to a question the previous one forces,
rather than a list of topics), moved the formal citations of every section
from a "Recall" box at the top, the first impression of the reader, before
any explanation, to a "Sources, quoted" recap at the bottom, and merged
the former separate "References" list into that same box, so each
section now closes with one citation block instead of two; and renamed
the terse "Brief:" gloss following each verbatim quote to "Picture it
like this:", rewriting all of them as plain-language explanations
grounded in everyday analogies rather than a compressed technical
restatement, while the quotes and citations themselves stay exactly as
rigorous as before.

A sixth pass reverses part of the fifth, book-wide: narrative chapter
openers and bare "Picture it like this" analogy boxes are replaced with a
derivation-first exposition in the tradition of Arnold's and Gelfand's
teaching, "it is impossible to understand an unmotivated definition." A
definition or theorem is no longer stated and then explained; each
section poses the question that forces it and walks the reasoning that
discovers it, naming the result once it has been earned, with no fixed
Definition-Theorem-Proof template imposed on that reasoning. Exercises
that gave away their own answer inline ("Socratic questions") were
converted to stated problems, with solutions moved to
[15-appendix-solutions/](15-appendix-solutions/00-index.md). Worked
examples, citations, and the "Picture it like this" glosses inside
"Sources, quoted" citation boxes (direct quotes) are unaffected.
[Chapter 7](07-groups/00-index.md) was the pilot; the same treatment now
covers every chapter.
See [changelog/](changelog/README.md) for the full, itemized history.

## Table of contents

**Part I, Lean fundamentals**

0. [Setting up Lean 4](00-setup/00-index.md)
1. [First steps: terms, types, `#eval`](01-basics/00-index.md)
2. [Terminology and the calculus of constructions](02-terminology-and-coc/00-index.md)
3. [Functions, definitions, and structures](03-functions-and-structures/00-index.md)
4. [Propositions as types, and basic proofs](04-propositions-and-proofs/00-index.md)
5. [Tactics, the toolbox for proving things](05-tactics/00-index.md)
6. [Rigor check: structures, universes, and equality](06-rigor-check/00-index.md)

**Part II, Algebra, formalized**

7. [Structures and classes: defining a `Group`](07-groups/00-index.md)
8. [Group examples and basic theorems](08-group-theorems/00-index.md)
9. [Rings: adding a second operation](09-rings/00-index.md)
10. [Ring examples and basic theorems](10-ring-theorems/00-index.md)
11. [Modules over a ring](11-modules/00-index.md)
12. [Quivers and path algebras](12-path-algebras/00-index.md)

**Part III, Working with Lean, and beyond**

13. [Working efficiently in Lean](13-working-efficiently/00-index.md)
14. [Where to go next](14-next-steps/00-index.md)

**Appendix**

15. [Solutions to exercises](15-appendix-solutions/00-index.md)

**Reference**

- [Learning paths](learning-paths.md), a chapter-dependency graph and
  named reading paths for different starting points.
- [Tactic and library reference](tactic-and-library-reference.md), every
  tactic used in the book, and every Mathlib name from the
  "Mathlib equivalent" boxes of Chapters 7-12, each linked to its official documentation.
- [Proof strategy guide](proof-strategy-guide.md), the reverse of the
  library reference: given the *shape* of a goal, hypothesis, or
  definition, which tactic to reach for first, keyed to the exercise and
  theorem patterns of the book itself.
- [λ-calculus / type theory to Lean dictionary](lambda-calculus-dictionary.md),
  a lookup table connecting the formal notation in the
  "Mathematical reading" boxes of this book back to Lean syntax, term by term.
- [Notation reference](notation-reference.md), the ordinary logic/algebra
  symbols used throughout the main text (∀, ∃, ∈, ∘, •, ⟨_, _⟩, ...), each
  matched to its Lean syntax.
- [Bibliography](bibliography.md), every external source cited in any
  "Sources, quoted" box of a section, consolidated into one list with one
  citation style; each section links back to the entries it uses.
- [Python companion](python-companion/python_companion.ipynb), every
  "Programmer note (Python)" snippet in the book, collected into one
  runnable notebook that opens directly in Google Colab, no Lean
  installation required.

## Building the LaTeX manuscript

`python3 ../lean_book_latex/build/build_latex.py` converts the Markdown of every chapter into a
full LaTeX manuscript under [`../lean_book_latex/`](../lean_book_latex/)
(a sibling of this directory, not a subdirectory of it), one `.tex` file
per Markdown section (mirroring the source layout exactly), a driver per
chapter, and a top-level
`lean_book_latex/lean-for-working-algebraists.tex`. This
is real, professional LaTeX, with proper `\chapter`/`\section` structure with
styled headings and running headers, `amsthm`/`tcolorbox` environments
for the recurring boxes of the book ("Mathematical reading," "Programmer
note," checkpoint projects), every former Mermaid diagram hand-translated
to native `tikz-cd` (in
[`../lean_book_latex/diagrams/`](../lean_book_latex/diagrams/), each with
its own standalone compile smoke-test in
[`../lean_book_latex/smoketest/`](../lean_book_latex/smoketest/)), Lean
and Python code via the
`listings` package (styled in
[`../lean_book_latex/lean-listings.tex`](../lean_book_latex/lean-listings.tex)),
and a single `lean_book_latex/references.bib` cited via `biblatex`. The
script only
emits `.tex`; no PDF is a build artifact of this repository. Compile it
yourself once a LaTeX distribution (e.g. MiKTeX or TeX Live) with
`xelatex`, `biber`, and the `tikz-cd`/`tcolorbox`/`titlesec`/`fancyhdr`
packages is available:

```sh
cd ../lean_book_latex
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

MIT. See [LICENSE](../LICENSE).
