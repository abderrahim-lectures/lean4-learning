# Comprehensive Term, Citation, and Prose Audit

**Book:** Lean for Working Algebraists (v2.0.9)
**Date:** 2026-09-11
**Branch:** `skills/comprehensive-term-audit`
**Scope:** All 15 chapters + appendix, 15,880 lines of Markdown

---

## Systemic Issues (patterns across all chapters)

### S1. Citations buried in Sources boxes instead of inline (CRITICAL, ~40+ instances)

The single most pervasive defect. Definitions, theorems, and claims carry their citations only in the "Sources, quoted" box at the bottom of each section, not next to the definition/claim itself. A reader encountering the term for the first time sees no source until scrolling to the end.

**Affected chapters:** 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13

**Fix pattern:** Add `[Author Year, p.XX]` inline immediately after every Definition block, every theorem statement, and every named concept.

### S2. Bolded terms with no formal Definition block (~30+ instances)

Terms appear in **bold** as if already meaningful, but never receive a `**Definition.**` block. The bolding signals "this is a defined term" but the book never stamps it as one.

**Most affected:** Chapters 1-4 (logic recap alone has 14), Chapter 6, Chapter 11

### S3. Lean code blocks without tactic-level documentation (~25+ instances)

Code blocks present proofs and definitions without inline comments explaining what each tactic does to the goal state. The prose above or below explains the mathematics, but the Lean code itself is opaque without reading the surrounding text.

**Most affected:** Chapters 4 (Secs. 5-7), 10, 11, 12, 15 (solutions appendix)

### S4. Terms used before formal definition (~15 instances)

Terms like "elaborate," "reduce," "bound variable," "normal form" appear in Chapter 1 before their formal definitions in Chapter 2. The book acknowledges this but offers no working gloss at first use.

---

## Chapter-by-Chapter Findings

### Chapter 1: Basics (8 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 1.1 | CRITICAL | `01-everything-has-a-type.md:28` | **calculus of constructions** bolded, no definition, no citation | Add `[CoquandHuet1988]` inline |
| 1.2 | CRITICAL | `03-dependent-types.md:109` | **family of types indexed by Nat** bolded, never formally defined | Add Definition block with `[TPIL4]` |
| 1.3 | CRITICAL | `03-dependent-types.md:184` | **equation compiler** bolded, used, never defined | Add inline definition + `[LeanDocs]` |
| 1.4 | HIGH | `01-everything-has-a-type.md:25` | **judgment** definition exists but citation `[MartinLof1984]` only in Sources box | Add inline citation |
| 1.5 | HIGH | `01-everything-has-a-type.md:67` | Type system guarantee concept, `[Pierce2002]` only in Sources box | Add inline citation |
| 1.6 | HIGH | `01-everything-has-a-type.md:181` | **F-algebra** definition, `[Jacobs1999]` only in Sources box | Add inline citation |
| 1.7 | HIGH | `01-everything-has-a-type.md:191` | **initial object** definition, `[MacLane1998]` only in Sources box | Add inline citation |
| 1.8 | HIGH | `01-everything-has-a-type.md:219` | **natural numbers object** used, `[Jacobs1999]` only in Sources box | Add inline citation |

### Chapter 2: Terminology and CoC (9 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 2.1 | CRITICAL | `01-terminology.md:99` | **currying** definition, `[Pierce2002]` only in Sources box | Add inline citation |
| 2.2 | HIGH | `01-terminology.md:184` | **motive** defined without citation, `[TPIL4]` only in Sources | Add inline citation |
| 2.3 | HIGH | `01-terminology.md:64` | **reduction/normal form** defined without citation | Add inline citations |
| 2.4 | HIGH | `01-terminology.md:150` | **variable capture** bolded, no formal definition | Add Definition block |
| 2.5 | HIGH | `01-basics/01-everything-has-a-type.md:174` | **disjoint sum/coproduct** used without definition | Add parenthetical + `[MacLane1998]` |
| 2.6 | HIGH | `03-dependent-types.md:456` | **Sort** bolded, used without definition | Add inline definition |
| 2.7 | HIGH | `02-def-let-implicit.md:155` | **polymorphic** bolded, no formal definition | Add Definition block + `[Pierce2002]` |
| 2.8 | HIGH | `03-dependent-types.md:255` | **noncomputable** bolded, no formal definition | Add Definition block |
| 2.9 | HIGH | `01-basics/01-everything-has-a-type.md:173` | **endofunctor** bolded, no definition, no citation | Add inline definition + `[MacLane1998]` |

### Chapter 3: Structures and Types (10 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 3.1 | CRITICAL | `00-index.md:22` | **currying** introduced without formal Definition block | Add Definition block |
| 3.2 | CRITICAL | `00-index.md:23` | **Hom-set** used without definition | Add parenthetical definition |
| 3.3 | CRITICAL | `01-structure-basics.md:33` | **constructor** bolded, no formal definition | Add Definition block |
| 3.4 | CRITICAL | `01-structure-basics.md:44` | **anonymous constructor** bolded, no formal definition | Add Definition block |
| 3.5 | CRITICAL | `01-structure-basics.md:48` | **field projection** bolded, no formal definition | Add Definition block |
| 3.6 | HIGH | `03-extending-structures.md:78` | **forgetful functor** used without definition, citation only in Sources | Add Definition block + inline citation |
| 3.7 | HIGH | `03-extending-structures.md:83` | **full subcategory** used without definition | Add parenthetical |
| 3.8 | HIGH | `04-propositions-and-proofs/01-prop.md:13` | **proof** (as Lean term) bolded, no Definition block | Add Definition block |
| 3.9 | HIGH | `04-propositions-and-proofs/01-prop.md:13` | **Curry-Howard correspondence** bolded, no Definition block | Add Definition block |
| 3.10 | MEDIUM | `02-type-parameters.md:68` | **parametric polymorphism** only in Sources box, never defined in body | Add inline definition |

### Chapter 4: Propositions and Proofs (20 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 4.1 | CRITICAL | `02-logic-recap.md` (14 terms) | Entire Logic Recap has 14 bolded terms with no Definition blocks: propositional variables, formulas, connectives, metavariables, valuation, tautology, provability, provable from hypotheses, inference rules, natural deduction, introduction rule, elimination rule, first-order logic, predicates | Add Definition blocks for all 14 |
| 4.2 | CRITICAL | `03-theorem-lemma.md` | Entire section has zero citations | Add Sources box citing TPIL4 |
| 4.3 | CRITICAL | `04-implication.md` | Entire section has zero citations | Add Sources box citing TPIL4 + Howard1980 |
| 4.4 | HIGH | `05-and-or-not.md:7` | Lean code blocks in Secs. 5-7 lack tactic documentation | Add inline Lean comments |
| 4.5 | HIGH | `06-quantifiers.md:7` | Lean code block undocumented | Add inline comments |
| 4.6 | HIGH | `07-equality.md:10` | `.symm` and `.trans` used without explaining they are built-in methods | Add Lean comments |
| 4.7 | HIGH | `05-and-or-not.md:53` | `decide` used before explained, no inline comment | Add comment before code |
| 4.8 | MEDIUM | `05-and-or-not.md` | No "what forces" motivation paragraph | Add motivating paragraph |
| 4.9 | MEDIUM | `06-quantifiers.md` | No "what forces" motivation paragraph | Add motivating paragraph |
| 4.10 | MEDIUM | `07-equality.md` | No "what forces" motivation paragraph | Add motivating paragraph |

### Chapter 5: Tactics (8 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 5.1 | CRITICAL | `04-more-tactics.md:112` | **abbrev** defined circularly using "reducible" before it is defined | Rewrite to avoid circularity |
| 5.2 | CRITICAL | `04-more-tactics.md:153` | **simp** defined using "simplification lemmas" (circular) | Define mechanically first |
| 5.3 | CRITICAL | `04-more-tactics.md:124` | **opaque** defined only by negation | Give standalone first sentence |
| 5.4 | HIGH | `02-core-tactics.md:91` | **backward chaining** used without definition | Add parenthetical |
| 5.5 | HIGH | `02-core-tactics.md:92` | **substitution of equals** used without definition/citation | Add Definition or citation |
| 5.6 | HIGH | `01-goal-state.md:7` | **goal** bolded, no Definition block | Add Definition block |
| 5.7 | HIGH | `00-index.md:18` | **tactic mode** bolded, no Definition block | Add Definition block |
| 5.8 | HIGH | `03-reading-failures.md:35` | **sorry** bolded, no formal Definition block | Add Definition block |

### Chapter 6: Rigor Check (17 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 6.1 | CRITICAL | `01-structure-vs-class.md:126` | **coercion** defined circularly (describes mechanism, not concept) | Give standalone definition |
| 6.2 | CRITICAL | `03-typing-rules-and-safety.md:200` | **impredicativity of Prop** missing "what forces" motivation | Add one motivating sentence |
| 6.3 | CRITICAL | `04-defeq-vs-propeq.md:46` | **weak head normal form** missing motivation + no formal definition | Add why WHNF exists + Definition block |
| 6.4 | HIGH | `02-universes.md:16` | **hierarchy of universes** bolded, no Definition block | Add Definition block |
| 6.5 | HIGH | `02-universes.md:69` | **universe polymorphic** bolded, no Definition block | Add Definition block |
| 6.6 | HIGH | `03-typing-rules-and-safety.md:69` | **typing judgment** bolded, no Definition block | Add Definition block + `[Pierce2002]` |
| 6.7 | HIGH | `03-typing-rules-and-safety.md:106` | **value** bolded, no Definition block | Add Definition block |
| 6.8 | HIGH | `03-typing-rules-and-safety.md:104` | **Progress** theorem, `[Pierce2002]` only in Sources | Add inline citation |
| 6.9 | HIGH | `03-typing-rules-and-safety.md:111` | **Preservation** theorem, `[Pierce2002]` only in Sources | Add inline citation |
| 6.10 | HIGH | `01-structure-vs-class.md:38` | **typeclass resolution** defined without citation | Add `[TPIL4]` inline |
| 6.11 | MEDIUM | `04-defeq-vs-propeq.md:119` | **structure eta** no Definition block | Add Definition block |
| 6.12 | MEDIUM | `04-defeq-vs-propeq.md:21` | **normal form** used without definition | Add parenthetical |
| 6.13 | MEDIUM | `04-defeq-vs-propeq.md:20` | **definitional equality** citation only in Sources | Add inline `[TPIL4]` |
| 6.14 | MEDIUM | `04-defeq-vs-propeq.md:58` | **propositional equality** citation only in Sources | Add inline `[TPIL4]` |

### Chapter 7: Groups (5 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 7.1 | HIGH | `02-translating.md:31` | **magma** used without definition | Add parenthetical |
| 7.2 | MEDIUM | `01-definition.md:18` | Group definition, `[DummitFoote2003]` only in Sources | Add inline citation |
| 7.3 | LOW | `04-permutations-example.md:113` | `Perm3.ext` code lacks goal-state comments | Add inline comments |

### Chapter 8: Group Theorems (3 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 8.1 | MEDIUM | `01-setup.md:39` | Theorem citations only in Sources box | Add inline citations in Secs. 2-4 |

### Chapter 9: Rings (10 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 9.1 | HIGH | `05-finite-ring-example.md:102` | **quotient** used without definition | Add parenthetical |
| 9.2 | HIGH | `05-finite-ring-example.md:102` | **ideal** used without definition | Add parenthetical |
| 9.3 | HIGH | `05-finite-ring-example.md:98` | **field** used without definition | Add one-sentence definition |
| 9.4 | HIGH | `07-matrices.md:41` | **free Z-module** used before modules are defined (Ch. 11) | Replace with "free abelian group Z^4" |
| 9.5 | MEDIUM | `01-definition.md:22` | Ring definition, `[DummitFoote2003]` only in Sources | Add inline citation |
| 9.6 | MEDIUM | `02-comm-group.md:8` | CommGroup has no citation at all | Add Sources box |
| 9.7 | MEDIUM | `01-definition.md:34` | **rng** introduced without citation | Add inline citation |
| 9.8 | LOW | `07-matrices.md:189` | `add4_reorder` proof lacks goal-state comments | Add comments |

### Chapter 10: Ring Theorems (4 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 10.1 | MEDIUM | `02-theorem-1.md:39` | `mul_zero` Lean proof undocumented | Add tactic-level comments |
| 10.2 | MEDIUM | `03-theorem-2.md:56` | `neg_one_mul` Lean proof undocumented | Add tactic-level comments |
| 10.3 | MEDIUM | `03-theorem-2.md:117` | `zero_mul` Mathlib example undocumented | Add explanation |

### Chapter 11: Modules (9 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 11.1 | HIGH | `01-definition.md:22` | **module** definition lacks Definition block + inline citation | Wrap in Definition block + add `[DummitFoote2003]` |
| 11.2 | HIGH | `02-translating-into-lean.md:47` | **ring homomorphism** used before it is defined anywhere | Add definition or forward reference |
| 11.3 | HIGH | `04-submodules.md:14` | **submodule** definition lacks Definition block + inline citation | Wrap in Definition block + add citation |
| 11.4 | HIGH | `05-linear-maps.md:7` | **linear map** definition lacks Definition block + inline citation | Wrap in Definition block + add citation |
| 11.5 | MEDIUM | `00-index.md` | Missing "What forces the definition" section | Add motivation section |
| 11.6 | MEDIUM | `05-linear-maps.md:10` | `LinearMap` structure proof obligations undocumented | Add comments |
| 11.7 | MEDIUM | `05-linear-maps.md:60` | `mulByLinearMap` proof obligations undocumented | Add comments |
| 11.8 | MEDIUM | `04-submodules.md:68` | `evenSubmodule` closure proofs undocumented | Add comments |
| 11.9 | MEDIUM | `06-direct-sums.md:176` | `proj1` proof obligations undocumented (rfl close) | Add explanation |

### Chapter 12: Path Algebras (9 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 12.1 | HIGH | `01-what-is-a-quiver.md:22` | **quiver** definition lacks Definition block + inline citation | Wrap in Definition block + add `[AssemSimsonSkowronski2006]` |
| 12.2 | HIGH | `02-paths.md:15` | **path** definition lacks Definition block + inline citation | Wrap in Definition block + add citation |
| 12.3 | HIGH | `05-path-composition.md:164` | **path algebra** definition lacks Definition block + inline citation | Wrap in Definition block + add citation |
| 12.4 | HIGH | `05-path-composition.md:84` | **free category** bolded, used without definition | Add definition or parenthetical |
| 12.5 | HIGH | `05-path-composition.md:176` | Path algebra uses "free k-module" before it is defined (Ch. 14) | Replace with "finite k-linear combinations" |
| 12.6 | MEDIUM | `07-checkpoint-project.md:49` | `Path.length`/`Path.append_length` tactics undocumented | Add inline comments |

### Chapter 13: Working Efficiently (6 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 13.1 | HIGH | `03-simp.md:31` | **normalization by rewriting** bolded, no Definition block | Add Definition block + `[Newman1942]` |
| 13.2 | HIGH | `03-simp.md:40` | **confluence** referenced but never defined | Add inline definition |
| 13.3 | HIGH | `02-decision-procedures.md:52` | **Presburger arithmetic** named but not defined | Replace "famously decidable" with explanation |
| 13.4 | MEDIUM | `02-decision-procedures.md:95` | `Decidable` definition + `[Chlipala2013]` only in Sources | Add inline citation |
| 13.5 | MEDIUM | `03-simp.md:38` | **canonical form** used without definition | Add parenthetical |
| 13.6 | LOW | `01-search-tactics.md:30` | `exact?` code block undocumented | Add inline comment |

### Chapter 14: Next Steps (3 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 14.1 | LOW | `02-moving-to-mathlib.md:12` | **type class** bolded, only syntactic description | Expand with conceptual definition |
| 14.2 | LOW | `02-moving-to-mathlib.md:37` | **inheritance diamond** glossed but not defined | Expand gloss |

### Chapter 15: Appendix Solutions (15 findings)

| # | Severity | File:Line | Issue | Fix |
|---|----------|-----------|-------|-----|
| 15.1 | HIGH | `02-chapter-2.md:31` | **proof irrelevance** used without definition/forward ref | Add parenthetical + forward ref |
| 15.2 | HIGH | `06-chapter-6.md:31` | **normal form** used without definition | Add parenthetical |
| 15.3 | HIGH | `02-chapter-2.md:20` | **elaboration** used without definition | Add parenthetical + forward ref |
| 15.4 | HIGH | `03-chapter-3.md:9` | **expected type** used without definition | Add parenthetical |
| 15.5 | HIGH | `03-chapter-3.md:30` | **forgetful functor** bolded, no proper definition | Add inline definition |
| 15.6 | HIGH | `02-chapter-2.md:69` | **Thrush combinator** bolded, no definition | Add Definition block |
| 15.7 | HIGH | `12-chapter-12.md:181` | **indexed inductive type** used without definition | Add parenthetical |
| 15.8 | MEDIUM | `04-chapter-4.md:42` | **definitional vs propositional equality** used without definition | Add parenthetical |
| 15.9 | MEDIUM | `05-chapter-5.md:44` | Induction mechanism not explained | Add explanation |
| 15.10 | LOW | `07-chapter-7.md:41` | `cases` tactic undocumented (8 uses) | Add inline comments |
| 15.11 | LOW | `06-chapter-6.md:73` | `class`/`instance` keywords undocumented | Add inline comments |
| 15.12 | LOW | `06-chapter-6.md:160` | `Monoid`/`listMonoid`/`monoid_id_unique` undocumented | Add inline comments |
| 15.13 | LOW | `01-chapter-1.md:7` | **Pi-type** used without forward ref | Add forward ref |
| 15.14 | LOW | `01-chapter-1.md:22` | **dependent type** used before explanation | Add forward ref |
| 15.15 | LOW | `11-chapter-11.md:123` | `multiplesSubmodule` code undocumented | Add inline comments |

---

## Prose Violations

| # | File:Line | Violation | Category |
|---|-----------|-----------|----------|
| P1 | `06-rigor-check/05-exercises.md:12` | "asymmetric recursion" | Uncommon vocabulary |
| P2 | `15-appendix-solutions/06-chapter-6.md:68` | "asymmetric recursion" | Uncommon vocabulary |
| P3 | `02-terminology-and-coc/02-pi-sigma-and-coc.md:49` | "It is not ... It is ..." | Antithesis drumbeat |
| P4 | `04-propositions-and-proofs/06-quantifiers.md:35` | "of course" | Trivially |

**Count:** 4 prose violations (below the 3.0/1000-word threshold, but P3 and P4 should be fixed).

---

## Lean Code Documentation Gaps (by chapter)

| Chapter | Undocumented blocks | Files affected |
|---------|-------------------|----------------|
| Ch. 1 | `#print Fin` output, `#eval` comments | `03-dependent-types.md`, `01-everything-has-a-type.md` |
| Ch. 2 | `noncomputable` + `#reduce` | `02-pi-sigma-and-coc.md` |
| Ch. 4 | `decide`, `.symm`, `.trans`, `And`/`Or`/`Not` tactics | `05-and-or-not.md`, `06-quantifiers.md`, `07-equality.md` |
| Ch. 5 | `def`/`abbrev`/`opaque` behavioral contrast | `04-more-tactics.md` |
| Ch. 6 | Universe check examples, typing rule examples | `02-universes.md`, `03-typing-rules-and-safety.md` |
| Ch. 7 | `Perm3.ext` goal states | `04-permutations-example.md` |
| Ch. 9 | `add4_reorder`, `Mat2.ext`, `mat2Ring` | `07-matrices.md` |
| Ch. 10 | `mul_zero`, `neg_one_mul`, `zero_mul` | `02-theorem-1.md`, `03-theorem-2.md` |
| Ch. 11 | `LinearMap`, `mulByLinearMap`, `evenSubmodule`, `proj1` | `05-linear-maps.md`, `04-submodules.md`, `06-direct-sums.md` |
| Ch. 12 | `Path.length`, `Path.append_length` | `07-checkpoint-project.md` |
| Ch. 13 | `exact?`, `simp` usage | `01-search-tactics.md`, `03-simp.md` |
| Ch. 15 | `cases` (8x), `class`/`instance`, `Monoid` block, `refine`/`absurd`, `show` chain, `simp only` | Multiple solution files |

---

## Priority Order

### Phase 1: Inline citations (highest impact, most mechanical)
Add `[Author Year, p.XX]` inline next to every Definition block, theorem statement, and named concept. Currently ~40+ citations are buried in Sources boxes. This is the single most impactful fix.

### Phase 2: Missing Definition blocks
Add `**Definition.**` blocks for all bolded terms that lack them. ~30 terms affected. Priority: Chapter 4 Logic Recap (14 terms), Chapter 1-2 foundational terms, Chapter 11 (module, submodule, linear map, quiver, path, path algebra).

### Phase 3: Lean code documentation
Add inline tactic-level comments to all undocumented code blocks. ~25+ blocks affected. Priority: Chapters 4, 10, 11, 12, 15.

### Phase 4: Circular explanations and missing motivation
Fix the 6 circular definitions (Ch. 5 `abbrev`/`simp`/`opaque`, Ch. 6 `coercion`, Ch. 12 path algebra) and add "what forces" sections where missing (Ch. 11).

### Phase 5: Forward references and glosses
Add parenthetical glosses or forward references for terms used before definition (Ch. 1 "elaborate"/"reduce", Ch. 9 "quotient"/"ideal"/"field"/"free module", Ch. 15 solution terms).

### Phase 6: Prose repairs
Fix the 4 prose violations (2x "asymmetric", 1x antithesis drumbeat, 1x "of course").
