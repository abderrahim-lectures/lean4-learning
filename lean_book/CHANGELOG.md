# Changelog

Notable changes to this book, most recent first. Each entry links back to
the commit(s) it corresponds to where one exists.

## Unreleased — Readability & navigation pass

- **One block per example.** Sections that used to dump several `theorem`/
  `def`/`structure` examples into one big code fence, then explain all of
  them together afterward, now interleave: one small code block, then the
  explanation for *that* example, repeated — across Chapters 1–11 and the
  appendix solutions. A `def`/helper immediately followed by the one thing
  that uses it (e.g. a `structure` and its `.ext` lemma) is kept together
  rather than artificially split.
- **"Mathematical reading" boxes** that discussed multiple examples at
  once were split the same way, so each box sits with the specific example
  it's explaining; boxes that genuinely synthesize *across* several
  examples (compare them, generalize over them) were left intact.
- **"Programmer's corner (Python)" boxes** were checked and repositioned
  to sit immediately after the one example each is illustrating, rather
  than trailing at the end of a section that had since grown other content.
- **ASCII-art category-theory diagrams** added at the natural spots:
  the shared glossary's universal-property/initial-object/forgetful-functor/
  subobject entries, the product/coproduct reading of `∧`/`∨`, and a
  literal arrow diagram for the book's running quiver example — rendered
  as plain text so they display identically in any Markdown viewer,
  without depending on `tikz-cd`/`amscd`-style LaTeX packages the book's
  stated MathJax/KaTeX rendering path doesn't guarantee.
- **Chapter 3's `∃` section** expanded from one example to two: the
  original `⟨2, rfl⟩` (smallest non-degenerate even number, chosen instead
  of the original `⟨0, rfl⟩` to avoid looking like a trick), plus a second
  example proving "there's a prime bigger than 3" — introducing a
  proof that isn't `rfl`, a nested `∧`-inside-`∃`, and an explicit note
  on why the *general* infinitude-of-primes theorem needs induction
  (not yet introduced) and where Mathlib's real proof lives.
- **Bare "Chapter *N* §*M*" text mentions** turned into actual clickable
  links throughout, wherever one had been left as plain prose instead of
  a cross-reference.

## Accessibility pass — merged [PR #1](https://github.com/abderrahim-lectures/lean4-learning/pull/1)

- Added a shared glossary (Chapter 1 §4) for the category-theory terms
  used repeatedly in "Mathematical reading" boxes but never previously
  defined — *universal property*, *initial object*, *forgetful functor*,
  *subobject/full subcategory* — and linked every later use back to it.
- Cut one-off category-theory flourishes past the book's own promised
  baseline (adjunction/counit, biproduct, presheaf category, proper
  class/Grothendieck universe, bifunctor, contravariant/anti-automorphism).
- Added **Appendix B §0**, a from-scratch recap of standard propositional
  and first-order logic and natural deduction, for readers meeting formal
  logic for the first time; wired Chapter 4's proof-theory asides to it.
- Fixed remaining HoTT-jargon residue (*transport*, *fiber*,
  *propositional truncation*) and dropped programming-background asides
  (Haskell/ML-family/`rustup` comparisons) that contradicted the book's
  own "no programming background" promise.
- Added five "Programmer's corner (Python)" boxes as an optional third
  reading track alongside "Mathematical reading," for readers with
  programming background but no formal-logic/type-theory background.
- Documented the pass itself in the README.

## [Expert-review pass](https://github.com/abderrahim-lectures/lean4-learning/commit/a07c15a8f78c0ead802dcd645efcccb4d4d56652) (2026)

- Full connective-by-connective Curry–Howard table for Chapter 3, replacing
  a one-line slogan.
- A "Terminology" section (Chapter 1 §4) defining *elaborate*, *unify*,
  *reduce/normal form*, and *motive* the first time each is needed.
- At least one worked example beyond the "obvious" one in every algebraic
  chapter (a genuinely non-abelian finite group in Chapter 6, a finite
  commutative ring in Chapter 8, a concrete linear map and direct-sum
  instance in Chapter 10, a computed path composition in Chapter 11).
- "Read more" pointers threaded throughout rather than concentrated only
  in the closing chapters.

## [Correct stale verification claim](https://github.com/abderrahim-lectures/lean4-learning/commit/1d910968f0facb2d84e0437c898d50440e766113)

- Fixed the README's verification notice and stated the exact Lean
  toolchain version (`v4.31.0`) the book's code is checked against.

## [Add Appendix B](https://github.com/abderrahim-lectures/lean4-learning/commit/1f7a82abe64c4e0630ea018a2f786dd2b4d08b8a)

- Added the λ-calculus and type-theory appendix: untyped λ-calculus,
  Church encodings, the simply typed λ-calculus, dependent types and the
  calculus of constructions, and a term-by-term dictionary from
  λ-calculus to Lean.

## [Port book code into lean_project](https://github.com/abderrahim-lectures/lean4-learning/commit/c1a1e5110c18ff9bd729f925cb1ee1c08d6f53f9)

- Every code block in Chapters 1–11 ported into `lean_project/LeanProject/`
  (one module per chapter) and verified with `lake build` against the real
  compiler — not just read over. Several bugs only surfaced this way (a
  missing extensionality lemma, `rw` steps that over-rewrote, a reference
  to an undefined `intZModule`, Mathlib's `ring` tactic used without
  Mathlib ever being imported) and were fixed in both the book text and
  the project.

## [Restructure into per-chapter folders](https://github.com/abderrahim-lectures/lean4-learning/commit/25896e6d96cab760acc7df45deb7bfbb9cd40e8f)

- Moved from a flat layout into one folder per chapter, each with a
  `00-index.md` overview and one file per section.
- Added the Chapter 5 "Rigor check" (structures vs. classes, universes,
  definitional vs. propositional equality) and the "Mathematical reading"
  boxes tying Lean constructs back to standard algebra/category-theory
  language.

## [Add matrix ring and module theory chapters](https://github.com/abderrahim-lectures/lean4-learning/commit/59753f68de1b6abe210e5657077b41c83485b69e)

- Added the matrix-ring worked example, Chapter 10 (modules over a ring),
  and chapter-to-chapter navigation strips.

## [Initial commit](https://github.com/abderrahim-lectures/lean4-learning/commit/9ece99a9f33777d8d8d96dc1ec6968190c960365)

- First version of the book: groups, rings, and quiver path algebras,
  with a companion `lean_project` Lean 4 project.
