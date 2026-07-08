# Lean for Working Algebraists

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

Each chapter is its own folder (e.g. [06-groups/](06-groups/)) containing a
`00-index.md` overview plus one small Markdown file per section — open the
chapter's `00-index.md` first, which links to every section in order. LaTeX
math is written inline as `$...$` and in display blocks as `$$...$$`; render
with any Markdown viewer that supports MathJax/KaTeX (e.g. VS Code with a
Markdown+Math extension, or Pandoc).

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

The book has been through an editorial pass specifically checking for
foundational terms used before they're explained, thin worked-example
coverage, and outright factual errors — the Curry–Howard correspondence
(Chapter 3) now gets a full connective-by-connective table rather than a
one-line slogan; a "Terminology" section (Chapter 1 §4) defines
*elaborate*, *unify*, *reduce/normal form*, and *motive* the first time
each is needed, with forward pointers to Appendix B where they're made
fully precise; every algebraic chapter now has at least one worked
example beyond the "obvious" one (a genuinely non-abelian finite group in
Chapter 6, a finite commutative ring in Chapter 8, a concrete linear map
and direct-sum instance in Chapter 10, a computed path composition in
Chapter 11), including one place (Chapter 7) where a generic theorem is
explicitly instantiated on a concrete structure to demonstrate the
"prove once, use everywhere" payoff rather than only asserting it. "Read
more" pointers — both internal cross-references and external standard
references (Mathlib source, *Theorem Proving in Lean 4*, Dummit & Foote,
Aluffi, and quiver-representation texts) — are threaded throughout rather
than concentrated only in the closing chapters.

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

**Appendices**

14. [Appendix A: Solutions to exercises](14-appendix-solutions/00-index.md)
15. [Appendix B: The λ-calculus underneath Lean](15-lambda-calculus/00-index.md)

## Navigation

Every chapter file has a navigation strip at the top (link back to this
menu, plus previous/next chapter) and a matching one at the bottom, so you
can move through the book without returning here each time.
