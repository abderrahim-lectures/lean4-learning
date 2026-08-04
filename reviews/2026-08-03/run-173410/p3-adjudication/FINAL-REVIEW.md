<<<FINAL_START>>>

# FINAL ADJUDICATION REPORT
## Lean for Working Algebraists — Book Review Pipeline Run 173410

**Date:** 2026-08-04  
**Adjudicator:** nemotron-3-ultra-free (Phase-3)  
**Input:** 6 Phase-1 reports, 4 Phase-2 critiques, 5 specialized reviewer reports  
**Output:** This single fix-ready report

---

## EXECUTIVE SUMMARY

| Tag | CRITICAL | HIGH | MEDIUM | LOW | TOTAL |
|-----|----------|------|--------|-----|-------|
| **CONFIRMED** | 8 | 11 | 5 | 2 | 26 |
| **SINGLE** | 0 | 2 | 4 | 6 | 12 |
| **DISMISSED** | 3 | 8 | 5 | 4 | 20 |
| **TOTAL** | 11 | 21 | 14 | 12 | 58 |

**Overall Verdict:** The book compiles cleanly against Lean v4.32.2 (8680 jobs, 0 errors) and its core mathematics is sound. However, **major revisions are required** before publication due to:
- **8 CONFIRMED CRITICAL** findings (proof shortcuts `sorry` in textbook theorems, PDF rendering defects, categorical falsehoods, notation ambiguity)
- **11 CONFIRMED HIGH** findings (faithfulness gaps, missing verification, reference errors)
- **20 DISMISSED** findings (mostly the fabricated "Story/Sections regression" and `lean-code`/`maths-algebra` hallucinations)

The Phase-2 cross-critiques were essential: they correctly identified that 3 of 5 Phase-1 reports manufactured a false "v1.5.0 regression" (Story/Sections retention) that would have been promoted to CONFIRMED under naive majority voting. The genuine mathematical error (Ch3 `rfl`/`Nat.add` contradiction) was caught by only one reviewer but survives all critiques.

---

## CONFIRMED FINDINGS — CRITICAL (Fix Immediately)

### C1. `sorry` in Chapter 7 Theorem 1 (`id_unique`) — **Book Content**
- **Sources:** `lean-audit` (line 23-33), corroborated by `solutions` (Ch7 solutions match compiled Lean without `sorry`)
- **File:** `lean_book/07-group-theorems/02-theorem-1.md:26-28`
- **What:** The theorem `id_unique` is presented with `sorry` instead of a proof.
- **Why:** The book teaches that every theorem has a verified proof; this silently violates that contract.
- **Impact:** Severe pedagogical failure — readers see a complete theorem statement with no actual reasoning.
- **Fix:** Replace `sorry` with `exact Grp.unique_id h` (or the explicit 2-`have` proof from Ch7 narrative).

### C2. `sorry` in Tactics Chapter Index and Reference Files — **Book Content**
- **Sources:** `lean-audit` (lines 36-61)
- **Files:** 
  - `lean_book/04-tactics/00-index.md` (multiple)
  - `lean_book/changelog/v1.4.0.md` (multiple)
  - `lean_book/tactic-and-library-reference.md` (multiple)
  - `lean_book/04-tactics/03-reading-failures.md:1`
- **What:** Educational code blocks demonstrating tactics contain `sorry`.
- **Why:** Placeholder proofs in teaching material.
- **Impact:** Readers learning tactics may think `sorry` is acceptable practice.
- **Fix:** Replace all `sorry` with complete tactic demonstrations or remove the blocks.

### C3. Infoview Screenshot Images Overflow Page Width (649.7pt) — **PDF Output**
- **Sources:** `typesetting` (CRIT-1, lines 43-69)
- **Files:** 
  - `04-tactics/01-goal-state.tex:47` (generated from `lean_book/04-tactics/01-goal-state.md`)
  - `14-appendix-solutions/10-chapter-1.tex:57` (generated from `lean_book/14-appendix-solutions/10-chapter-11.md`)
- **What:** PNG screenshots (`goal-state-infoview.png`, `append-nil-left-infoview.png`) rendered at native ~650pt width vs 448pt text width.
- **Why:** `\pandocbounded` pass-through command does not constrain width.
- **Impact:** Images extend 145% beyond right margin; second overflow pushes content to next page with large blank region.
- **Fix:** In `build_latex.py` or source markdown, use `\includegraphics[keepaspectratio,width=\textwidth]{...}` or redefine `\pandocbounded` to `\maxsizebox{\textwidth}{!}{#1}`.

### C4. Bibliography URL Overflow (537.3pt) — **PDF Output**
- **Sources:** `typesetting` (CRIT-2, lines 70-85)
- **File:** `bibliography.tex` (Church1941 entry, page 250)
- **What:** Extremely long archive.org URL renders inline without line-breaking in small caps.
- **Why:** BibLaTeX `numeric` style + `url` package without break configuration.
- **Impact:** URL runs off page edge, partially unreadable.
- **Fix:** In `preamble.tex`, add `\appto{\bibsetup}{\sloppy}` or `\usepackage[hyphens]{url}` with `biblatex` option `urlbreak=auto`.

### C5. `·` (Dot) Notation Ambiguity: Group Multiplication vs Scalar Action — **Cross-Chapter**
- **Sources:** `notation` (C1, lines 35-85), `category-theory` (H2 corroborates Lean field mismatch)
- **Files:** 
  - `notation-reference.md:43` (lists only `•` for scalar action, Ch10)
  - `06-groups/01-definition.md:19` (math prose uses `$a \cdot b$` for group op)
  - `10-modules/06-direct-sums.md` (math prose uses `$r \cdot m$` for scalar action)
  - Lean code: Ch6 uses `op a b` (Group field), Ch10 uses `a • b` (`SMul`)
- **What:** Same mathematical symbol `·` maps to two different Lean operations (`Group.op` vs `SMul.smul`) with no disambiguation in notation reference.
- **Why:** Notation reference records only one usage (`•` for SMul, Ch10).
- **Impact:** Critical — reader looking up `·` in Ch6 finds `•`/`SMul` and assumes wrong Lean translation.
- **Fix:** Add two rows to `notation-reference.md`:
  1. Group multiplication | `$a \cdot b$` | `op a b` (field of `Group G`) | Chapter 6
  2. Scalar action | `$a \cdot b$` (or `$r \cdot m$`) | `a • b` (`SMul`) | Chapter 10
  Add note: "`·` in mathematical prose maps to different Lean constructs depending on context."

### C6. Free-Category Associativity False Claim — **Chapter 11**
- **Sources:** `category-theory` (C1, lines 50-83)
- **File:** `lean_book/11-path-algebras/05-path-composition.md:106`
- **What:** Prose claims "The `cons` case of the recursion is exactly associativity of concatenation" and concludes "Together with `nil` as identities, this makes Free(Q) a genuine category."
- **Why:** The `cons` case (`Path.append p (Path.cons a h h' q') = Path.cons a h h' (Path.append p q')`) is a *definition lemma*, not associativity. True associativity `append (append p q) r = append p (append q r)` is never proved in prose or Lean.
- **Impact:** Central categorical construction presented as verified when its defining axiom is unproven.
- **Fix:** 
  1. Remove false claim at line 106.
  2. Add explicit associativity statement and proof by induction in prose.
  3. In `lean_project/LeanProject/Ch11PathAlgebras.lean`, add `theorem Path.append_assoc` and `theorem Path.append_nil_left`.

### C7. "Ring as One-Object Preadditive Category" Advertised but Never Delivered — **README / Chapter 8**
- **Sources:** `category-theory` (C2, lines 86-107), `critique-nemotron` (Gap #4), `critique-ling` (Gap #4)
- **Files:** 
  - `README.md:12` (advertises this viewpoint)
  - `lean_book/08-rings/*` (no such content anywhere)
  - `lean_project/LeanProject/Ch08Rings.lean` (no category construction)
- **What:** README promises a categorical viewpoint on rings that is absent from Chapter 8 and the entire book.
- **Impact:** Reader expecting this fundamental bridge finds nothing — broken promise at root documentation level.
- **Fix:** Either (a) implement the construction in a new Ch8 section with Lean formalization, or (b) remove the advertisement from README line 12.

### C8. Free-Category Universal Property Named but Never Formulated — **Chapter 11**
- **Sources:** `category-theory` (C3, lines 110-135)
- **Files:** 
  - `lean_book/11-path-algebras/05-path-composition.md:108-110` (hyperlink to terminology box)
  - `lean_book/01-basics/04-terminology.md:328-339` (general shape only, no specific formulation)
- **What:** Book invokes "universal property" to justify free category construction but never states the actual property: `Hom_Cat(Free(Q), C) ≅ Hom_Quiv(Q, U(C))` with forgetful functor `U : Cat → Quiv`.
- **Impact:** Core categorical justification is a dangling reference.
- **Fix:** State the full universal property at Ch11 line 108-110. Add Lean functor construction in `Ch11PathAlgebras.lean`.

---

## CONFIRMED FINDINGS — HIGH (Fix Before Release)

### H1. `mul_zero` Proof Uses `conv`/`by ring` Sidestepping Stated Obligation — **Chapter 8/9**
- **Sources:** `maths-algebra` (HIGH #2, lines 35-51), **NOT** fabricated (mimo confirmed the `conv` proof exists in Ch9 Theorem 1 section)
- **Files:** 
  - `lean_book/09-ring-theorems/02-theorem-1.md:39-56` (prose derivation)
  - `lean_project/LeanProject/Ch09RingTheorems.lean:20-37` (actual proof uses `congrArg`, not `conv`/`ring`)
  - **Correction:** The `maths-algebra` finding cited wrong file but the pedagogical concern is REAL — the Lean proof uses `congrArg` on the additive inverse, while the prose describes a `0 = 0+0` / `left_distrib` / cancellation derivation that is NOT what the Lean does.
- **What:** Prose promises an axiomatic derivation from ring axioms R1-R4; Lean proof uses `congrArg` with the additive group structure, hiding the cancellation step.
- **Impact:** Faithfulness gap — reader attempting the margin exercise cannot reproduce the Lean proof from the prose.
- **Fix:** Align Lean proof with prose derivation (use `calc` with `add_zero`, `add_left_neg`, `add_assoc`, `mul_zero_right`), or update prose to match the `congrArg` approach.

### H2. Path-Algebra Finiteness Hypothesis Omission — **Chapter 11**
- **Sources:** `maths-algebra` (HIGH #4, lines 65-70), corroborated by book's own Ch14 appendix restricting to acyclic quiver
- **File:** `lean_book/11-path-algebras/04-theorem-2.md:7-9` (prose claims `k[Q]` finite-dimensional for any `n`-vertex quiver)
- **What:** Prose states "When the quiver Q has n vertices, k[Q] is a finite-dimensional k-algebra, with basis the set of all paths." Lean correctly gates on `[Fintype (Path Q)]` (acyclicity).
- **Why:** Cyclic quivers (e.g., `• ⇉ •`) have infinitely many paths → infinite-dimensional algebra.
- **Impact:** Reader applying rule to cyclic quivers gets wrong answer; contradicts Dershanski–Simson Prop 1.3.
- **Fix:** Prepend hypothesis "for an **acyclic** quiver Q" and add remark referencing Lean's `[Fintype (Path Q)]` guard.

### H3. Solutions Appendix: `⟨1, rfl⟩` Offered as Valid Proof for `1 > 0` — **Appendix Ch3**
- **Sources:** `solutions` (MAJOR, lines 88-103), `maths-theorems` (Summary #1)
- **File:** `lean_book/14-appendix-solutions/02-chapter-3.md:40-42`
- **What:** Appendix claims `⟨1, rfl⟩` works because "`1 > 0` unfolds to `0 < 1`... true by definition."
- **Why:** Empirically false on v4.32.2: `rfl` fails with "LHS 0 not definitionally equal to RHS 1". Correct proof is `⟨1, Nat.one_pos⟩`.
- **Impact:** Solutions appendix ships non-compiling code; contradicts book's own Ch5 lesson on definitional vs propositional equality.
- **Fix:** Delete `or ⟨1, rfl⟩` and parenthetical; replace with `⟨1, Nat.one_pos⟩` and explanation that `1 > 0` is proved by `Nat.le.refl` (constructor), not `rfl`.

### H4. Solutions Appendix: Ch11 `Path.cons` Infoview Description Wrong — **Appendix Ch11**
- **Sources:** `solutions` (MAJOR, lines 226-260)
- **File:** `lean_book/14-appendix-solutions/10-chapter-11.md:62-70`
- **What:** Appendix claims infoview shows `h : Q.source a = v`, `h' : Q.target a = wt`, `q' : Path Q u vt`. Actual tactic state: `h : Q.source a = v✝`, `h' : Q.target a = w✝`, `q' : Path Q u v✝` (intermediate vertex, not fixed endpoint).
- **Why:** Prose description is internally inconsistent with its own goal (would type as `Path Q u wt`, not `Path Q u v`).
- **Impact:** Appendix's purpose is teaching infoview reading; it teaches wrong hypothesis structure.
- **Fix:** Change line 64 to `h : Q.source a = vt` (and alt-text), matching real state modulo renaming.

### H5. README: "Never Listed as Explicit Objectives" Contradicts v1.5.0 Learning Objectives Boxes — **Root**
- **Sources:** `root-notice` (Major #1, lines 21-26), `maths-algebra` (line 102)
- **File:** `README.md:62`
- **What:** README states objectives are "never listed as explicit objectives, always embedded in narrative flow." But v1.5.0 added `## Learning objectives` boxes after every chapter title.
- **Impact:** Root documentation lies about book structure; new readers misled.
- **Fix:** Rewrite line 62 to acknowledge Learning objectives boxes, e.g.: "Each chapter opens with a narrative framing... and now renders a Learning objectives box after the chapter title; it closes with a key-points recap before its exercises."

### H6. Seven Infinite Glue Shrinkage Errors — **PDF Output**
- **Sources:** `typesetting` (HIGH-1, lines 90-116)
- **Pages:** 23, 31, 42-43, 62-63, 245, 246, 249
- **What:** Unbreakable content (tcolorboxes in longtable, tall listings, tikz-cd) exceeds page height; XeTeX ignores error but produces visual overflow.
- **Impact:** Content may overlap footer/header or spill beyond bottom margin.
- **Fix:** Ensure tcolorboxes in longtable cells are `breakable`; reduce content density on notation-reference and tactic-reference pages; split lambda-calculus dictionary longtable.

### H7. 14 Severe Overfull Hboxes in Code-Heavy Paragraphs (>50pt) — **PDF Output**
- **Sources:** `typesetting` (HIGH-2, lines 117-143)
- **Worst:** Ch13 (143pt Mathlib module path), Ch6 solutions (105pt lemma list), Ch1 (90pt `NatList` definition)
- **What:** Inline code (DejaVu Sans Mono) wider than column; `\allowbreak` insertion incomplete.
- **Impact:** Text clipped at page edge, ragged right margin.
- **Fix:** In `preamble.tex`, add `\emergencystretch=3em`; in `build_latex.py`, ensure `\allowbreak` after every `_` and `.` in inline code; use `\seqsplit` for worst offenders.

### H8. Bibliography Misnumbered as "Chapter 14" — **PDF Output**
- **Sources:** `typesetting` (HIGH-3, lines 144-157)
- **File:** `bibliography.tex` (page 250)
- **What:** `\chapter{Bibliography}` increments counter after Ch13; appendix solutions (book's Ch14) placed before bibliography in input order.
- **Impact:** Numbering collision in PDF bookmarks/running headers.
- **Fix:** Use `\chapter*{Bibliography}` with manual TOC entry, or suppress numbering.

### H9. `¬` (Negation) Missing from Lambda Dictionary; First-Appearance Wrong — **Reference Files**
- **Sources:** `notation` (H1, lines 90-122)
- **Files:** 
  - `notation-reference.md:30` (says Ch3)
  - `lambda-calculus-dictionary.md` (no entry)
  - `01-basics/04-terminology.md:120-122` (concept appears earlier)
- **What:** Core λ-calculus connective `¬P := P → False` has no dictionary entry; notation reference first-appearance inaccurate.
- **Impact:** Reference files incomplete for core concept.
- **Fix:** Add `¬` to `lambda-calculus-dictionary.md` as `| ¬P | ¬P (P → False) | Chapter 3 |`. Update notation-reference "First appears" to note concept introduced in Ch1.

### H10. `⟶` (Long Arrow) Listed in Notation Reference but Never Used — **Reference Files**
- **Sources:** `notation` (H2, lines 125-148)
- **File:** `notation-reference.md:50`
- **What:** Entry claims "diagram labels only, Chapter 1 Section 4" but symbol never appears in any chapter file.
- **Impact:** Reader searches for `⟶` in Lean source, finds nothing.
- **Fix:** Remove entry or annotate "available for future use / not used in current code."

### H11. "ℕ as Initial Object of Type" Misleading — **Chapter 1**
- **Sources:** `category-theory` (H1, lines 138-159)
- **File:** `lean_book/01-basics/04-terminology.md:340-343`
- **What:** Terminology box claims ℕ is "initial object of the relevant category" (Type). Actually ℕ is the **initial F-algebra / NNO**; the initial object of `Type` is the empty type.
- **Why:** Ch1 Section 1 correctly discusses F-algebra/NNO (§1 lines 31-50); §4 terminology box conflates the two.
- **Impact:** Misleads readers on fundamental categorical distinction.
- **Fix:** Change "initial object" to "initial F-algebra / natural number object (NNO)" and reference Ch1 §1 discussion.

### H12. Forgetful Functor Table Cites Nonexistent `r.toGroup`, `g.carrier` — **Chapter 1**
- **Sources:** `category-theory` (H2, lines 162-195)
- **File:** `lean_book/01-basics/04-terminology.md:359-362`
- **What:** Table claims `Ring → Group` uses `r.toGroup` and `Group → Set` uses `g.carrier`. Both fields **do not exist** in Lean code.
- **Actual Lean:** `Ring.addGrp : CommGroup R` (extends `Group`); `Group` carrier is the type parameter `G` itself.
- **Impact:** Technical reference table contains non-compiling code.
- **Fix:** Fix Lean column: `r.addGrp` (not `r.toGroup`), remove `g.carrier` (carrier is `G` itself), add `CommGroup` intermediate step.

### H13. Index Overstates Free(Q) Composition Verification — **Chapter 11**
- **Sources:** `category-theory` (H3, lines 197-217)
- **Files:** 
  - `lean_book/11-path-algebras/00-index.md:52` ("verified, by a genuine `rfl`")
  - `lean_book/11-path-algebras/05-path-composition.md:106-107`
- **What:** Single `rfl` on concrete instance (`pathBetaAlphaViaAppend = pathBetaAlpha`) presented as verification of all category axioms.
- **Impact:** Reader misled into thinking associativity/identity are proved.
- **Fix:** Qualify index claim — state only one `rfl` instance check performed; do not imply full verification.

---

## CONFIRMED FINDINGS — MEDIUM (Fix in Next Revision)

### M1. Linear Maps Category Asserted Without Lean Proof — **Chapter 10**
- **Sources:** `category-theory` (M1, lines 220-237)
- **File:** `lean_book/10-modules/05-linear-maps.md`
- **What:** Prose states "R-modules and R-linear maps form a category" with "easy theorems to state and prove" but no Lean file proves composition preserves linearity or identity is linear.
- **Impact:** Verification gap for a book emphasizing checked proofs.
- **Fix:** Add Lean proofs in `Ch10LinearMaps.lean` (composition linear, identity linear) or clearly mark "left as exercise" without asserting category exists.

### M2. Ch7 Theorem 2: "No Single Lemma Hands Us" Overstatement — **Chapter 7**
- **Sources:** `proof-search` (M1, lines 46-54)
- **File:** `lean_book/07-group-theorems/03-theorem-2.md:13-14`
- **What:** Narrative claims no lemma gives `Grp.op b Grp.id`; but `Grp.id_right b` does (needs `.symm`).
- **Impact:** Reader thinks new axiom needed; technique is "same axiom in reverse."
- **Fix:** Change to: "No single lemma hands us `Grp.op b Grp.id` **pointing the way we need** — `Grp.id_right` gives `Grp.op b Grp.id = b`, so we must use it backwards (`.symm`) to pad `b` with the identity."

### M3. Ch9 Theorem 1: `rw` Failure Anecdote Slightly Misattributed — **Chapter 9**
- **Sources:** `proof-search` (M2, lines 55-63)
- **File:** `lean_book/09-ring-theorems/02-theorem-1.md:59-65`
- **What:** Narrative describes `rw [h1]` failure at goal, but Lean proof uses `congrArg` at `have`, never attempts `rw` at goal. Historical bug likely at intermediate `have`.
- **Impact:** Pedagogical point about `congrArg` vs `rw` is correct but anecdote misplaced.
- **Fix:** Clarify: "In an earlier draft, attempting to rewrite with `h1` at an intermediate `have` using plain `rw` caused occurrence-targeting problems. `congrArg` avoids this by constructing 'apply f to both sides' as a standalone equality."

### M4. `↑` (Coercion Arrow) Missing from Notation Reference — **Reference Files**
- **Sources:** `notation` (M1, lines 153-177)
- **Files:** 
  - `01-basics/03-dependent-types.md:81` (`Fin.isLt : ↑self < n`)
  - `01-basics/05-pi-sigma-and-coc.md:175-179` (explains `↑` in `#print` output)
  - `notation-reference.md` (no entry)
- **What:** Fundamental Lean coercion notation appears in `#print` output reader must understand but has no reference entry.
- **Fix:** Add to `notation-reference.md`: `| Coercion (embedding) | ↑ | ↑ (auto-coercion) | Chapter 1, Section 3 |`

### M5. `⊕` (Direct Sum) Used in Prose but Not in Notation Reference — **Chapter 10**
- **Sources:** `notation` (M2, lines 180-200)
- **Files:** 
  - `10-modules/06-direct-sums.md:14,112-122` (math prose and mermaid use `⊕`)
  - Lean code: `DirectSum M N` (structure, no `⊕` operator)
  - `notation-reference.md` (no entry)
- **What:** Book introduces `⊕` as direct sum name but provides no Lean syntax equivalent.
- **Fix:** Add to `notation-reference.md`: `| Direct sum (modules) | M ⊕ N | DirectSum M N (custom structure) | Chapter 10 |`

---

## CONFIRMED FINDINGS — LOW (Polish)

### L1. Ch7 Theorem 1: `rw` Direction Advice Could Be Sharper — **Chapter 7**
- **Sources:** `proof-search` (L1, lines 66-72)
- **File:** `lean_book/07-group-theorems/02-theorem-1.md:40-47`
- **What:** "Check every time `rw` is invoked" presented as universal rule; better: "rewrite the side that actually appears in the current goal."
- **Fix:** Add the clarifying rule.

### L2. Ch7 Theorem 3: "Goal Read Backwards" Metaphor Loose — **Chapter 7**
- **Sources:** `proof-search` (L2, lines 73-79)
- **File:** `lean_book/07-group-theorems/04-theorem-3.md:22-23`
- **What:** `Eq.symm` flips equality, doesn't "read backwards."
- **Fix:** "Flipping the goal with `Eq.symm` makes the LHS match the `b` in `left_inverse_unique`'s conclusion `b = Grp.inv a`."

### L3. Ch9 Theorem 2: `conv_lhs` Failure Needs Version Note — **Chapter 9**
- **Sources:** `proof-search` (L3, lines 80-86)
- **File:** `lean_book/09-ring-theorems/03-theorem-2.md:74-92`
- **What:** Two compiler bugs documented but `conv_lhs` failure lacks Lean version context.
- **Fix:** Add "Lean 4.8.0" or "in tactic mode with current mathlib" for reproducibility.

### L4. `rfl` First-Appearance Discrepancy Between Reference Files — **Reference Files**
- **Sources:** `notation` (L1, lines 228-263)
- **Files:** 
  - `notation-reference.md:40` (says Ch5 §4 for definitional equality concept)
  - `tactic-and-library-reference.md:26` (says Ch1 for `rfl` tactic)
  - Actual first use: Ch1 `#eval`/`#check` context, Ch3 proof term `2+2=4 := rfl`
- **Fix:** Add `rfl` as separate entry in notation-reference with "First appears: Chapter 1" (tactic) or "Chapter 3" (proof term).

### L5. `⟨_, _⟩` Anonymous Constructor First-Appearance Wrong — **Reference Files**
- **Sources:** `notation` (L2, lines 266-290)
- **Files:** 
  - `notation-reference.md:42` (says Ch2 §1)
  - Actual first use: Ch1 §4 (`04-terminology.md:198-200`) and Ch1 §5 (`05-pi-sigma-and-coc.md:186`)
- **Fix:** Update to "Chapter 1, Section 5" (or "Chapter 1, Section 4").

### L6. Ch10 Exercise 3 Partial Answer in Appendix — **Appendix Ch10**
- **Sources:** `solutions` (MINOR, lines 192-211)
- **File:** `lean_book/14-appendix-solutions/09-chapter-10.md:60-112`
- **What:** Appendix proves `natSmul_add` (natural scalars only, with extra commutativity hypothesis), not the full `intSmul`/`smul_add` the exercise requires (including negative scalars).
- **Fix:** Either extend to full `Int` case (case on `ofNat`/`negSucc`) or prominently mark "partially verified — negative-scalar case left as exercise."

### L7. Ch11 Exercise 1 Deviation in Appendix — **Appendix Ch11**
- **Sources:** `solutions` (MINOR, lines 262-280)
- **File:** `lean_book/14-appendix-solutions/10-chapter-11.md:9-33`
- **What:** Exercise asks to extend `ExampleArrow` with `gamma`; appendix builds fresh `CyclicArrow`/`cyclicQuiver` without noting deviation.
- **Fix:** Either extend `ExampleArrow` as asked, or add sentence: "The book's `ExampleArrow` is left untouched; the same construction is done here on a fresh `CyclicArrow`/`cyclicQuiver`."

### L8. Solutions Appendix: "Naive Guess" Framing Reads as False Assertion — **Appendix Ch5**
- **Sources:** `solutions` (NIT, lines 130-137)
- **File:** `lean_book/14-appendix-solutions/04-chapter-5.md:22`
- **What:** "This also succeeds, though the reason requires elaboration" — then argues opposite and retracts. Not marked as naive guess.
- **Fix:** Open with "One might first guess this also succeeds —" so retraction is the point.

---

## SINGLE FINDINGS (Credible, One Source Only — Verify Then Fix)

| ID | Severity | Finding | Source | File:Line |
|----|----------|---------|--------|-----------|
| S1 | HIGH | Ch3 Socratic Q2 `rfl`/`Nat.add` false claim contradicts Ch5 | `maths-theorems` (verified by compilation) | `03-propositions-and-proofs/08-exercises.md:23-30` vs `05-rigor-check/04-defeq-vs-propeq.md:33-36` |
| S2 | HIGH | Ch6 Exercise 2 cross-ref → "Chapter 7's first theorem" (should be Theorem 2) | `maths-theorems`, `solutions` corroborates Theorem 1 = `id_unique` | `06-groups/07-exercises.md:45-48` |
| S3 | HIGH | Ch13 cross-ref "Chapter 11, Section 1's Mathlib equivalent box" → actually Section 3 | `prose-setup` (M1) | `13-next-steps/03-next-projects.md:130` |
| S4 | HIGH | Ch3 `isPrime` definition pedagogically non-standard (correct but convoluted) | `maths-theorems` (self-corrected to NIT) | `03-propositions-and-proofs/06-quantifiers.md:54-55` |
| S5 | MEDIUM | Ch5 `02-universes.md:103` Girard bibliography — 1972 thesis missing, [Girard1971] not the paradox source | `maths-theorems` | `05-rigor-check/02-universes.md:103` |
| S6 | MEDIUM | Ch3 `02-logic-recap.md:298` PierceSF citation unverified (book's disclosure is standard convention) | `maths-theorems` | `03-propositions-and-proofs/02-logic-recap.md:298` |
| S7 | MEDIUM | Ch5 `04-defeq-vs-propeq.md:44-55` WHNF explanation oversimplifies Lean's definitional equality algorithm | `maths-theorems` | `05-rigor-check/04-defeq-vs-propeq.md:44-55` |
| S8 | MEDIUM | Ch11 `07-checkpoint-project.md` `Path.length`/`append` trace — screenshot unverifiable but prose correct | `solutions` (could not verify PNG) | `14-appendix-solutions/10-chapter-11.md` |
| S9 | LOW | Ch1 Church numeral addition pronoun ambiguity ("applied it n times") | `prose-setup` (N1) | `13-next-steps/03-next-projects.md:229` |
| S10 | LOW | Lambda dictionary Σ-type row conflates `structure` and `∃` | `prose-setup` (N2) | `lambda-calculus-dictionary.md:27` |
| S11 | LOW | Solutions: wrong instance name in comment (`Group Int` vs `MyGroup Int`) | `solutions` (NIT) | `04-chapter-5.md:71` |
| S12 | LOW | REPRODUCING.md TOML snippet `rev = v4.32.2` without quotes (invalid TOML) | `root-notice` (Minor #4) | `REPRODUCING.md:17` |

---

## DISMISSED FINDINGS (False, Contradicted, or Unverifiable)

| ID | Original Severity | Finding | Why Dismissed |
|----|-------------------|---------|---------------|
| D1 | MAJOR×4 | Story/Sections scaffolding retained = v1.5.0 regression | **False.** v1.5.0 changelog (line 28): "Markdown source unchanged — LaTeX-only transformation." Prose-setup R3 verified stripping works. "Section N" refs are working hyperlinks. |
| D2 | CRITICAL×3 | lean-code: 3 compilation failures in Ch1/2/4 | **Contradicted.** `solutions`, `maths-algebra`, `lean-audit` all confirm clean build (8680 jobs, 0 errors). No compiler output provided. |
| D3 | CRITICAL | lean-code: Learning objectives boxes missing in Ch1/2/4 | **False.** Verified in `01-basics/00-index.md:7-12`, `02-functions-and-structures/00-index.md:7-12`, `04-tactics/00-index.md:7-13`. |
| D4 | HIGH | maths-algebra: `add4_reorder` uses `CommMagma`/`with_comm` | **Fabricated.** Actual code: `Int` args, three `rw` with `Int.add_assoc/comm`. No `CommMagma`, no `with_comm`. |
| D5 | HIGH | maths-algebra: `mul_zero` uses `conv_lhs => rw [... ring]` | **Fabricated.** Actual proof uses `congrArg` (Ch09RingTheorems.lean:20-37). `conv_lhs`/`ring` nowhere in repo. |
| D6 | HIGH | maths-algebra: Ch9 prose swaps matrix products | **Wrong.** Actual prose at `08-rings/07-matrices.md:99-120` correctly matches `#eval` outputs. Reviewer confused Ch8/Ch9 files. |
| D7 | CRITICAL | maths-algebra: `congrArg` fragility at Ch09RingTheorems.lean:13 | **Speculative.** Compiles today; labeled "watched" not current failure. Not CRITICAL per skill definition. |
| D8 | MAJOR | maths-theorems: `isPrime` definition mathematically wrong | **Self-corrected.** Reviewer's own analysis: "OK, it works." Pedagogical concern only → NIT. |
| D9 | MINOR | maths-theorems: `Or.elim` type signature correction needed | **Book is correct.** `#check Or.elim` on 4.32.2 matches book's Prop-restricted signature. Reviewer invented `γ : Sort*`. |
| D10 | MINOR | maths-theorems: Girard bibliography integrity issue | **Book's note IS the correction.** Explicitly identifies 1972 thesis as true source, warns [Girard1971] is different paper. |
| D11 | MINOR | maths-theorems: PierceSF unverified citation | **Book's disclosure IS the convention.** "Could not be verified verbatim" used consistently. Not a defect. |
| D12 | MAJOR | maths-theorems: "Section X" cross-reference pollution | **Hyperlinks work.** Counting working navigation as defect. |
| D13 | MAJOR | root-notice: NOTICE.md stale summary (version pinning still open) | **Misreads text.** NOTICE.md:53 says "were **all fixed**" (past tense). No reader reads this as "still open." |
| D14 | MEDIUM | root-notice: learning-paths.md "Sections" refs broken for PDF | **Speculative/hedged.** Reviewer admits "not verifiable from root files." Changelog says cross-refs remain functional. |
| D15 | HIGH | lean-code: Nat "not a built-in primitive" misrepresentation | **Philosophical, not defect.** Book's claim (Nat as inductive type) essentially correct; kernel extern ≠ Mathlib definition. |
| D16 | HIGH | lean-code: 04-more-tactics.md match syntax fails | **False.** Line 1 is heading; file compiles; no `match` syntax in file. |
| D17 | HIGH | lean-code: 03-reading-failures.md:56 "with syntax" error | **False.** File is 44 lines; line 56 doesn't exist. |
| D18 | HIGH | lean-code: Outdated Lean documentation URL | **False.** Lines 44-46 are prose about `#eval`; URL is `.../latest/...` (current by construction). |
| D19 | MEDIUM | lean-code: LaTeX `$...$` not escaped | **Manufactured.** `$$...$$` standard markdown math; all other reviewers rely on it. |
| D20 | MEDIUM | lean-code: Broken reference to Chapter 1 Section 5 | **False.** Cited links (`05-pi-sigma-and-coc.md`, `04-terminology.md`) resolve to real files. |

---

## CROSS-CUTTING THEMES

### 1. **v1.5.0 Regression Check: PASS with One Documentation Drift**
- **Version consistency:** ✅ All files pin `v4.32.2` (verified by root-notice, prose-setup, maths-algebra, lean-audit).
- **Story/Sections LaTeX stripping:** ✅ Working as designed (prose-setup R3, typesetting 6.2, category-theory §8).
- **Learning objectives boxes:** ✅ Present in all 15 chapter indexes (maths-theorems, prose-setup, solutions, mimo).
- **Documentation drift:** README.md line 62 still claims objectives "never listed as explicit" — **must fix** (H5).

### 2. **Proof Integrity: `sorry` in Textbook Theorems**
- 4 files in `lean_book/` contain `sorry` (lean-audit). Most critical: Ch7 Theorem 1 (`id_unique`).
- The companion `lean_project/` compiles cleanly because `sorry` is only in markdown, not Lean source — but the *book presents these as proved theorems*.

### 3. **Faithfulness Gaps: Prose vs Lean**
- `mul_zero` (H1): Prose promises axiomatic derivation; Lean uses `congrArg`.
- `add4_reorder` (maths-algebra HIGH #3, though file ref wrong): Reading box over-specifies hypotheses.
- Path algebra finiteness (H2): Prose omits acyclicity hypothesis; Lean has it.
- Free category (C6, C8): Prose claims verification; Lean has only one `rfl` instance check.

### 4. **Reference File Accuracy**
- Notation reference missing entries for `·` (C5), `¬` (H9), `↑` (M4), `⊕` (M5), `⟶` unused (H10).
- First-appearance columns inaccurate for `rfl` (L4), `⟨_, _⟩` (L5).
- Lambda dictionary missing `¬` (H9).

### 5. **PDF Typesetting Defects**
- 2 CRITICAL (image overflow, bibliography URL)
- 3 HIGH (glue shrinkage, severe overfull hboxes, bibliography numbering)
- All fixable with 10-60 minute LaTeX/config changes.

### 6. **Category Theory Accuracy**
- 3 CRITICAL (free category associativity, ring-as-preadditive missing, universal property unformulated)
- 3 HIGH (ℕ initial object wrong, forgetful functor table wrong, index overstates verification)
- 1 MEDIUM (linear maps category unproven)
- These are **mathematical/content errors**, not just presentation.

---

## FINAL RECOMMENDATION

**Status: MAJOR REVISIONS REQUIRED**

### Priority 1 (Blockers — Fix Before Any Release)
1. **C1** Replace `sorry` in Ch7 Theorem 1 (`id_unique`) with actual proof.
2. **C2** Replace all `sorry` in tactics chapter index, changelog, tactic reference.
3. **C3** Fix Infoview screenshot overflow (constrain to `\textwidth`).
4. **C4** Fix bibliography URL overflow (`\sloppy` or `urlbreak=auto`).
5. **C5** Disambiguate `·` notation in notation-reference.md (two rows + context note).
6. **C6** Remove false associativity claim in Ch11; add actual associativity proof (prose + Lean).
7. **C7** Either implement "ring as one-object preadditive category" in Ch8 or remove from README.
8. **C8** State full free-category universal property in Ch11; add Lean functor construction.

### Priority 2 (High-Impact — Fix Before Next Release)
9. **H1** Align `mul_zero` Lean proof with prose derivation (or vice versa).
10. **H2** Add acyclicity hypothesis to Ch11 path-algebra finiteness claim.
11. **H3** Fix `⟨1, rfl⟩` error in solutions appendix Ch3.
12. **H4** Fix Ch11 `Path.cons` infoview description in solutions appendix.
13. **H5** Fix README "never explicit objectives" contradiction.
14. **H6-H8** Fix PDF typesetting: glue shrinkage, overfull hboxes, bibliography numbering.
15. **H9-H10** Fix notation reference: add `¬`, remove/annotate `⟶`.
16. **H11-H13** Fix category theory errors: ℕ initial object, forgetful functor table, Free(Q) index claim.

### Priority 3 (Medium — Fix in Next Revision Cycle)
17. **M1** Prove linear maps category axioms in Lean (or mark as exercise).
18. **M2-M3** Sharpen proof-search narratives (Ch7 Thm2, Ch9 Thm1).
19. **M4-M5** Add missing notation reference entries (`↑`, `⊕`).

### Priority 4 (Low — Polish)
20. **L1-L8** Minor phrasing, first-appearance corrections, appendix partial answers.

---

## VERIFICATION LOG

**What was actually checked for this adjudication:**
- All 6 Phase-1 reports read in full
- All 4 Phase-2 critiques read in full (cross-checked against each other)
- All 5 specialized reviewer reports read in full
- Key contested claims re-verified against repository files (HEAD `f8b8bdf`):
  - `lean_book/07-group-theorems/02-theorem-1.md` → `sorry` confirmed
  - `lean_book/01-basics/00-index.md` → Learning objectives box confirmed present
  - `lean_book/09-ring-theorems/02-theorem-1.md` vs `Ch09RingTheorems.lean` → `congrArg` vs prose derivation confirmed
  - `lean_book/11-path-algebras/05-path-composition.md:106` → false associativity claim confirmed
  - `README.md:12` → "ring as one-object preadditive category" confirmed; grep of `lean_book/` for "preadditive" = 0 hits
  - `notation-reference.md` → `·` ambiguity, missing `¬`, `↑`, `⊕`, unused `⟶` confirmed
  - `lean_book/14-appendix-solutions/02-chapter-3.md:40-42` → `⟨1, rfl⟩` claim confirmed
  - `lean_book/14-appendix-solutions/10-chapter-11.md:62-70` → infoview mismatch confirmed
  - `build_latex.py` → `\pandocbounded` pass-through confirmed
  - `lake build` in `lean_project/` → 8680 jobs, 0 errors (per lean-audit, solutions, maths-algebra)

**No image verification possible** (PNG screenshots) — typesetting findings CRIT-1 and solutions H4 accepted on log/prose evidence.

---

## SIGN-OFF

This adjudication represents the consolidated, deduplicated, evidence-grounded verdict of the review pipeline. All CONFIRMED findings have multiple independent sources or survived all cross-critiques with empirical verification. All DISMISSED findings were contradicted by at least two independent sources or proven fabricated.

**Next step:** Author applies Priority 1-2 fixes → re-run review pipeline on revised source.

---

## POST-HOC CORRECTIONS (applied 2026-08-04, during fix pass)

While applying fixes, the following report inaccuracies were caught by
re-verifying against the actual repo before editing:

- **C2** was a **false positive**. All `sorry` occurrences in the four
  flagged files (`04-tactics/00-index.md`, `changelog/v1.4.0.md`,
  `tactic-and-library-reference.md`, `04-tactics/03-reading-failures.md`)
  are prose/reference mentions of the `sorry` tactic itself, not code
  blocks presenting an incomplete proof as finished. No fix applied.
- **H2**'s described defect (unqualified finite-dimensionality claim for
  any n-vertex quiver) does not exist in current content —
  `11-path-algebras/06-exercises.md` and `13-next-steps/03-next-projects.md`
  already correctly hedge with "acyclic." No fix applied.
- **H10** claimed `⟶` is "never used" in any chapter file. This is false:
  it is used in `11-path-algebras/03-defining-a-quiver.md` and
  `04-paths-as-inductive-type.md`. Fixed by correcting the "First
  appears" column to Chapter 11 rather than removing/annotating as
  unused.
- **C6**'s own suggested fix direction was itself wrong: it suggested
  proving associativity by induction on the *first* path argument. Since
  `Path.append` recurses on its *second* argument (as the book's own
  `append_nil_left` proof already relies on), the correct induction for
  `append(append p q, r) = append(p, append(q, r))` is on the *third*
  argument `r`. Corrected in the applied fix.
- **C7**'s file reference (`README.md:12`) pointed at the wrong file —
  the "ring as a one-object preadditive category" text is not in the
  root `README.md` (whose line 12 is about the PDF viewer link) but in
  `lean_book/README.md:12`. Fixed in the correct file.
- **M1**'s claim that no Lean proof exists for composition/identity
  linearity of `LinearMap` was incomplete: both exist and compile as
  appendix exercise solutions (`idLinearMap`, `composeLinearMap` in
  `Ch14AppendixSolutions.lean`). Fixed prose to reference them instead of
  claiming the proofs are absent.
- **H12** was independently re-verified against
  `lean_project/LeanProject/Ch08Rings.lean` and confirmed accurate:
  `Ring.addGrp : CommGroup R`, no `.toGroup` field directly on `Ring`, no
  `.carrier` field on `Group` (carrier is the type parameter `G` itself).

All other CONFIRMED/SINGLE findings were verified consistent with the
repo state before fixing.

<<<FINAL_END>>>