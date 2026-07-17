# Changelog

Notable changes to this book, most recent first. Each entry links back to
the commit(s) it corresponds to where one exists.

## Unreleased — Learning objectives, key points, and a consolidated bibliography

- Added a short **"Learning objectives"** paragraph to every chapter's
  `00-index.md` (Chapters 0–13), stating what a reader should be able to
  do by the end of that chapter.
- Added a brief **"Key points"** recap immediately before each chapter's
  exercises (or, for the three chapters without an exercises file —
  Chapters 0, 2, 12 — at the end of the chapter's last section). Chapter
  13 was left without one, since [01-what-we-built.md](13-next-steps/01-what-we-built.md)
  already serves as a whole-book recap.
- **Consolidated every chapter's References section into one
  [Bibliography](bibliography.md)**, de-duplicating first: Pierce's *Types
  and Programming Languages* alone was cited in full, with slightly
  different text, in five different chapters, and several other sources
  (Dummit & Foote, the Python `typing`/mypy docs, Milner 1978, the CoC
  paper, *Theorem Proving in Lean 4*) were repeated at least once. Every
  source now has exactly one full citation, on the bibliography page;
  each chapter's own References section keeps only a short pointer plus
  the section-specific reason for citing it. Three sources missed by the
  original per-chapter passes (Gentzen 1935, Gödel 1930, Martin-Löf 1984)
  were folded in during this consolidation. Added to the README's
  Reference list.
- No Lean code was touched in this pass; `lake build` on the companion
  `lean_project` re-confirmed unaffected.

## Unreleased — Project-Based Learning components

Distributed PBL scaffolding through the book instead of leaving it only at
the very end:

- Added a new **checkpoint project** at the end of Part I,
  [05-rigor-check/06-checkpoint-project.md](05-rigor-check/06-checkpoint-project.md):
  build a `Monoid` from scratch (`Group` minus inverses) and prove identity
  uniqueness for it, one chapter ahead of `Group` itself. Full worked
  solution (with a second instance) added to
  [Appendix, Chapter 5](14-appendix-solutions/04-chapter-5.md).
- Added a second **checkpoint project** at the end of Part II,
  [11-path-algebras/07-checkpoint-project.md](11-path-algebras/07-checkpoint-project.md):
  define `Path.length` and prove `Path.append` respects it. This surfaced
  a real, verified fact about Lean worth documenting directly — functions
  matching on an *indexed* inductive type like `Path` reduce only through
  their equation lemmas (`simp only [...]`), not plain `rfl`, once an
  abstract argument is involved. Full worked solution added to
  [Appendix, Chapter 11](14-appendix-solutions/10-chapter-11.md); [Chapter
  13's "What we built"](13-next-steps/01-what-we-built.md) updated to name
  this as a second explained exception to the book's no-`simp` discipline
  (alongside Chapter 6's `Perm3.ext`), rather than leave the claim
  overstated.
- Both new chapters' `00-index.md` and their exercises files' navigation
  updated to include the checkpoint project as the chapter's closing
  section.
- Expanded [Chapter 13 §3](13-next-steps/03-next-projects.md)'s five
  one-line "suggested next projects" into full scaffolds (learning
  objectives, prerequisites, milestones, a concrete deliverable, and a
  self-verification step the reader can run), modeled on §2's "Two
  theorems for free" capstone rigor. These remain genuinely open — no
  appendix solutions were added for them, unlike the two checkpoint
  projects, since they were never worked exercises with answers in the
  first place.

## Unreleased — Full-book review pass (Chapters 2, 4, 6–13, solutions appendix)

Applied the same verification discipline used for the type-theory rewrite
(every Lean snippet re-run against the pinned toolchain via `lake env
lean`/`lake build`; every factual and cross-reference claim checked) to
every remaining chapter. Found and fixed several real bugs a read-through
alone would have missed:

- **Wrong lemma name in a solution.** [Appendix, Chapter
  5](14-appendix-solutions/04-chapter-5.md)'s exercise 1 solution claimed
  `rw [Nat.two_mul]` closes `n * 2 = n + n`; running it fails, since
  `Nat.two_mul : 2 * n = n + n` has the arguments in the other order.
  Fixed to the correct `Nat.mul_two : n * 2 = n + n`.
- **A tool-output claim that didn't match the real toolchain.** [Chapter 12
  §1](12-working-efficiently/01-search-tactics.md) claimed `exact?` suggests
  `exact h.symm` for a simple symmetry goal; run against this book's pinned
  toolchain, it instead returns a correct but far less readable term.
  Rewrote the section to show the verified actual output and make the
  point honestly (search tactics find *a* closing term, not necessarily
  the most idiomatic one).
- **A missing exercise solution.** [Appendix, Chapter
  8](14-appendix-solutions/07-chapter-8.md) had solutions for exercises 1–2
  but not 3 (`mat2_not_comm`), even though the theorem was already proved
  and verified in the companion Lean project. Added the missing solution
  and explanation.
- **Repeated chapter mislabeling.** [Chapter
  12](12-working-efficiently/00-index.md) attributed the "find the proof
  by search, not just present the answer" discipline and its multi-step
  `rw`/`have` proofs to "Chapters 6 and 8" in five places across four
  files; that framing and those proofs are actually in Chapters 7 and 9
  (6 and 8 are the *definition* chapters). Corrected throughout.
- **A stale cross-reference.** [Chapter 10 §5](10-modules/05-linear-maps.md)
  attributed `evenSubmodule` to "Chapter 9"; it's defined earlier in the
  same chapter, in §4. Fixed to point to §4 directly.
- **An overclaim about the book's own tactic usage.** [Chapter
  13](13-next-steps/01-what-we-built.md) claimed "there is no `simp`"
  anywhere in the book; [Chapter 6 §4](06-groups/04-permutations-example.md)'s
  `Perm3.ext` genuinely uses `simp only [mk.injEq]`, since core Lean
  generates no field-wise extensionality lemma for a plain `structure`.
  Softened the claim and named the one explained exception.
- Added **References** sections (real, verified sources) to chapters that
  were missing them despite making external, checkable claims: [Chapter
  2](02-functions-and-structures/01-structure-basics.md) (structure-as-product,
  parametric polymorphism, forgetful functors), [Chapter
  8 §3](08-rings/03-ring.md) (Dummit & Foote, Aluffi), [Chapter 10
  §2](10-modules/02-translating-into-lean.md) (Dummit & Foote, Weibel), and
  [Chapter 11 §5](11-path-algebras/05-path-composition.md)
  (Assem–Simson–Skowroński, Schiffler).
- Fixed a stale "first used" location for `sorry` in the
  [tactic and library reference](tactic-and-library-reference.md) (claimed
  Chapter 7; it's actually introduced in Chapter 4 §3).
- Re-verified every Lean code block in Chapters 6–11 and 13 (both the
  from-scratch and "Mathlib equivalent" boxes) by rebuilding the entire
  companion `lean_project` — including its `LeanProjectMathlib` modules —
  against the pinned `v4.31.0` toolchain; confirmed every book code block
  still matches its ported module exactly, with no drift.
- Ran a full site-wide Markdown link-integrity sweep; the only unresolved
  link is a pre-existing, intentionally preserved historical reference in
  this changelog (see above, "09-chapter-11.md" predates the Appendix B
  renumbering).

## Unreleased — Type-theory chapters rewritten, Appendix B eliminated

- Rewrote [Chapter 1 §1](01-basics/01-everything-has-a-type.md) and
  [§3](01-basics/03-dependent-types.md) to lead with concrete,
  toolchain-verified examples (`Fin`, `Vec`/`Vec.replicate`/`Vec.head`/
  `Vec.dot`, `Sigma`, proof irrelevance) and Python-first comparisons
  before the categorical/formal framing, addressing confusion with the
  prior dependent-types explanation. Added a References section, citing
  real, checked sources, to every chapter touched by this pass.
- **Eliminated Appendix B entirely**, merging its ~9,000 words of formal
  λ-calculus/CoC material directly into the main chapters that already
  pointed to it, rather than leaving it as backmatter most readers would
  skip:
  - The standard-logic recap (natural deduction, soundness/completeness,
    classical vs. intuitionistic) is now [Chapter 3
    §2](03-propositions-and-proofs/02-logic-recap.md), immediately after
    the Curry–Howard table that motivates it, renumbering §2-§7 to §3-§8.
  - The untyped λ-calculus recap (grammar, α/β-reduction, currying,
    Church–Rosser, the $K$ combinator) is woven directly into [Chapter 1
    §4](01-basics/04-terminology.md)'s "Reduce/reduction" glossary entry.
  - Π-types, `Prop` irrelevance, Σ-types, and the CoC/CIC summary are now
    [Chapter 1 §5](01-basics/05-pi-sigma-and-coc.md); the simply typed
    λ-calculus's typing judgments/progress/preservation and the
    universe-formation typing rule are now a new [Chapter 5
    §3](05-rigor-check/03-typing-rules-and-safety.md), extending §2's
    informal universe discussion.
  - Church encodings (booleans, numerals) became a self-contained aside
    in [Chapter 13](13-next-steps/03-next-projects.md), since nothing
    else in the book depended on them.
  - The λ-calculus/Lean dictionary table is now a standalone
    [reference page](lambda-calculus-dictionary.md), sibling to
    `tactic-and-library-reference.md`.
  - Added a new Chapter 1 exercises section
    ([01-basics/06-exercises.md](01-basics/06-exercises.md)) with
    solutions, and renumbered the solutions appendix (`14-appendix-solutions/`)
    throughout to make room for it.
  - Every cross-reference into this content, in both directions, was
    rewritten to point at its new home; a full link-integrity sweep
    across every `.md` file in the book found zero broken internal links
    after the `15-lambda-calculus/` directory was removed.

## Unreleased — Capstone: two theorems for free

- Added "Two theorems for free" to [Chapter 13 §2](13-next-steps/02-moving-to-mathlib.md):
  a short capstone proving, for real via Mathlib, two facts this book's
  own from-scratch definitions explicitly could not state — that
  `ZMod 3` is a `Field` (Chapter 8 §5 built only a `Ring` and said so
  outright), and Lagrange's theorem applied to a genuine subgroup of
  `Equiv.Perm (Fin 3)` (Chapters 6-7's non-abelian example, which never
  had subgroups defined for it). Ported into `lean_project` as
  `Ch13CapstoneMathlib.lean` and compiled against real Mathlib — the
  first attempt's `decide` calls on `Nat.card`/`orderOf` failed to
  reduce (both are defined via classical choice), fixed by routing
  through `Nat.card_eq_fintype_card`/`Fintype.card_perm` and
  `orderOf_eq_prime` instead.

## Unreleased — Inline reference links, and a second screenshot

- Every tactic and Mathlib name across the whole book now gets a reference
  link right next to its first mention in each chapter's own prose (not
  only on the standalone `tactic-and-library-reference.md` lookup page
  added earlier) — tactics link to the official Lean 4 Tactic Reference,
  Mathlib names (in Chapters 6-11's "Mathlib equivalent" boxes) link via
  Loogle. Care was taken not to link the book's own from-scratch
  `Group`/`Ring`/`Module`/etc. as if they were the real Mathlib classes.
- Added a second real VS Code screenshot, in
  [Appendix A's Chapter 11 solutions](14-appendix-solutions/09-chapter-11.md),
  showing the Lean Infoview for `append_nil_left`'s `cons` case.

## Unreleased — PDF: real Mermaid diagrams, Lean syntax highlighting, honest front matter

- Mermaid diagrams now render as real images in the PDF (via
  `@mermaid-js/mermaid-cli`), not fenced source text — previously every
  `graph TD`/`graph LR` diagram just showed as a code block.
- Added a custom Kate syntax-highlighting definition for Lean 4
  (`build/lean4.xml`, since Pandoc's highlighter has no built-in Lean
  lexer) so Lean code blocks get real syntax coloring; Python code blocks
  already highlighted correctly.
- Long code lines now wrap instead of running off the page edge.
- The PDF's title page now names the actual author, Abderrahim Adrabi,
  and a new front-matter "About this book" page states plainly that the
  text was generated by Claude Code under the author's direction — not
  just noted in the repo's top-level README, but in the PDF itself.
- All PDF-build tooling (`build_pdf.py`, `pdf-header.tex`,
  `pdf-metadata.yaml`, `lean4.xml`) moved into a dedicated `build/`
  folder instead of sitting loose at the book root.

## Unreleased — Screenshot and reference links

- Added a real VS Code screenshot of the **Lean Infoview** to
  [Chapter 4 §1](04-tactics/01-goal-state.md), captured live against
  `my_add_comm`'s `succ` case, showing the hypotheses/goal split described
  in the surrounding text rather than only a text mock-up of it.
- Added [`tactic-and-library-reference.md`](tactic-and-library-reference.md),
  a lookup table linking every tactic used in the book to the official
  Lean 4 Tactic Reference, and every Mathlib name used in Chapters 6-11's
  "Mathlib equivalent" boxes to Loogle/Mathlib4 docs. Linked from the
  README, Chapter 4, Chapter 6, and Chapter 12.

## Unreleased — PDF build

- Added `build_pdf.py`, a Pandoc + XeLaTeX pipeline producing a single
  print-style PDF of the whole book (KOMA-Script `scrbook`, title page,
  numbered chapters, table of contents, syntax-highlighted code blocks).
  Per-file navigation strips are stripped and cross-file links flattened
  to plain text, since neither makes sense inside one linear PDF.

## Unreleased — Plain-English pass

- **Rewrote the book's prose to roughly CEFR B2 English** (upper-intermediate)
  across every chapter and the appendix: shorter sentences, plainer everyday
  words, fewer stacked em-dash asides. The goal is that a non-native English
  reader spends effort on Lean and math, not on decoding vocabulary. Code
  blocks, LaTeX math, links, headers, and the recurring section labels
  ("Mathematical reading.", "Programmer's corner (Python).", "Read more:",
  "Mathlib equivalent.") were left untouched — only the surrounding English
  glue changed, with no loss of technical content or nuance.
- The shared glossary (Chapter 1 §4) was restructured so every term
  (Elaborate/elaboration, Unify/unification, Reduce/reduction/normal form,
  Motive, and the four category-theory terms) has its own heading and a
  stable link anchor, ready for other chapters to link to on first use.
- Fixed a real bug surfaced while touching Chapter 11's Mathlib-equivalent
  boxes: an `open Quiver` in two code samples silently clashed with
  Mathlib's own root-level `Path` (continuous paths,
  `Mathlib.Topology.Path`), the same ambiguity already fixed in
  `lean_project` but never carried back into the book text. Fixed by
  spelling out `Quiver.Path` throughout instead.

## Unreleased — Mathlib-equivalent boxes

- **Every worked example in Chapters 6–11 (groups, group theorems, rings,
  ring theorems, modules, path algebras) is now followed by a "Mathlib
  equivalent" box**, showing the same statement or construction phrased
  against Mathlib's real `Group`/`Ring`/`Module`/`Quiver` API. The
  from-scratch construction stays the primary teaching path (see
  [the Mathlib note](00-setup/04-mathlib-note.md), updated to explain the
  framing); the Mathlib box is a deliberate peek ahead, so that Chapter
  13's move to Mathlib in full isn't the reader's first sight of it.
- Every added Mathlib snippet is ported into `lean_project/LeanProject/`
  as a matching `Ch0*Mathlib.lean` module per chapter (kept separate from
  the from-scratch modules so it's obvious which files pull in the
  Mathlib dependency) and verified with `lake build` against real
  Mathlib, not just read over.
- `lean_project` now depends on Mathlib (pinned to the `v4.31.0` tag,
  matching the toolchain).

## Unreleased — Mermaid diagrams

- **Category-theory diagrams upgraded from plain ASCII art to
  [Mermaid](https://mermaid.js.org/)** (the universal-property/
  initial-object/forgetful-functor/subobject entries in the Chapter 1 §4
  glossary, the product/coproduct pictures in Chapter 3, the running
  quiver example in Chapter 11) — real boxes and arrows on GitHub and in
  Mermaid-aware viewers, falling back to a readable code block showing the
  diagram source everywhere else, still without depending on
  `tikz-cd`/`amscd`-style LaTeX packages the book's MathJax/KaTeX
  rendering path doesn't guarantee.

## [Readability & navigation pass](https://github.com/abderrahim-lectures/lean4-learning/commit/fa7b258)

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
- **Category-theory diagrams** added at the natural spots: the shared
  glossary's universal-property/initial-object/forgetful-functor/subobject
  entries, the product/coproduct reading of `∧`/`∨`, and a literal arrow
  diagram for the book's running quiver example (originally plain ASCII,
  later upgraded to Mermaid — see above).
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
