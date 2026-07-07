# Lean 4 from Zero: Groups, Rings, and Path Algebras

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

Each chapter is a standalone Markdown file in [chapters/](chapters/). LaTeX
math is written inline as `$...$` and in display blocks as `$$...$$`; render
with any Markdown viewer that supports MathJax/KaTeX (e.g. VS Code with a
Markdown+Math extension, or Pandoc).

Code blocks are valid Lean 4 (tested against toolchain `v4.31.0`, matching
`../lean_project`). You're encouraged to copy them into `lean_project` and
run them yourself.

This book is about more than the constructs it covers — the running goal is
to build the *skill* of using Lean: reading a goal state, deciding what to
try next, recovering when a tactic fails, and knowing which proofs to
derive by hand versus hand off to automation. Chapters 6 and 8 in
particular present each theorem as a search process (what to look at, what
to try, why an attempt fails) rather than only the polished final proof;
Chapter 10 is dedicated entirely to working efficiently once the underlying
ideas are understood.

## Table of contents

0. [Setting up Lean 4](chapters/00-setup.md)
1. [First steps: terms, types, `#eval`](chapters/01-basics.md)
2. [Functions, definitions, and structures](chapters/02-functions-and-structures.md)
3. [Propositions as types, and basic proofs](chapters/03-propositions-and-proofs.md)
4. [Tactics, and how to work a goal you don't know the proof of](chapters/04-tactics.md)
5. [Structures and classes: defining a `Group`](chapters/05-groups.md)
6. [Group examples and basic theorems](chapters/06-group-theorems.md)
7. [Rings: adding a second operation](chapters/07-rings.md)
8. [Ring examples and basic theorems](chapters/08-ring-theorems.md)
9. [Quivers and path algebras](chapters/09-path-algebras.md)
10. [Working efficiently in Lean](chapters/10-working-efficiently.md)
11. [Where to go next](chapters/11-next-steps.md)
12. [Appendix: Solutions to exercises](chapters/12-appendix-solutions.md)
