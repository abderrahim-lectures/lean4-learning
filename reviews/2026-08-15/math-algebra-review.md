# REVIEW-MATH-ALGEBRA.md — Adversarial Mathematics Review (Chapters 8-11)

**Reviewer:** adversarial-maths-reviewer  
**Scope:** Chapters 8-11 (Group Theorems, Rings, Ring Theorems, Modules)  
**Toolchain:** leanprover/lean4:v4.32.2  
**Method:** Five personas — Skeptical Referee, Counterexample Hunter, Formalizer, Pedagogy Critic, Regression Tracker

---

## 1. Summary

I reviewed all mathematical content in Chapters 8-11: definitions, theorems, proofs, worked examples, exercises, and their Lean formalizations. The chapters are **mathematically correct** but have **three CRITICAL gaps** between the Lean code and the book prose, plus one HIGH finding. The algebraic structures are well-defined and theorems correctly proved, but the book's Markdown omits Lean definitions that the code relies on, and presents some Lean code as auto-generated when it must be hand-written.

The Skeptical Referee found no circular reasoning, no unused hypotheses, no silently weakened statements. The Counterexample Hunter found no counterexamples (zero ring, trivial group, empty module all handled). The Formalizer confirmed all Lean code compiles against v4.32.2 but found **faithfulness gaps** where the book prose diverges from the Lean code. The Pedagogy Critic found the "search process" presentation effective but noted missing definitions in prose. The Regression Tracker confirmed no regressions from recent fixes.

---

## 2. Recommendation

**Minor revisions.** Three CRITICAL faithfulness gaps, one HIGH, one MEDIUM, one LOW.

---

## 3. Major Concerns

### CRITICAL

#### C1. Ch11: `intZModule` missing from Markdown — Lean file calls this "a real gap"

**WHERE:** `11-modules/03-z-module-example.md` (prose) vs `Ch11Modules.lean:40-54` (Lean)

**WHAT:** The book's Section 3 builds the `ℤ`-module structure on `Int` by defining `intSmul`/`natSmul` but **never defines `intZModule : Module Int intRing Int`** in the Markdown. The Lean file explicitly supplies it with the comment: *"Supplied (not given explicitly in the book): the Z-module structure on Int itself, needed by `evenSubmodule` below. `smul` here is just `intSmul` specialized to `M := Int`, which happens to coincide with ordinary `Int` multiplication."* The book references `intZModule` only in a comment for `evenSubmodule` ("would package intSmul... constructed the same way intCommGroup packaged intGroup") without ever actually defining it.

**WHY IT MATTERS:** The Lean code cannot compile without `intZModule` — it's required for `evenSubmodule` and `mulByLinearMap`. The book's prose leaves a gap that the Lean code must fill silently. A reader following the book cannot construct the `ℤ`-module on `ℤ` from what's written.

**FIX:** Add the `intZModule` definition to `03-z-module-example.md` (or a new subsection), showing the full `Module Int intRing Int` structure with `smul := fun r m => r * m` and the four axiom proofs.

---

#### C2. Ch10: `neg_one_mul` depends on `mul_zero_left` only in Appendix — forward reference in main text

**WHERE:** `10-ring-theorems/03-theorem-2.md` (prose) vs `Ch10RingTheorems.lean:39-56` (Lean)

**WHAT:** The main chapter's Theorem 2 (`neg_one_mul : (-1) * a = -a`) has a proof that **genuinely depends on `mul_zero_left`** (which states `0 * a = 0`). However, `mul_zero_left` is **not proved in the main chapter** — it appears only in the Appendix (Chapter 10 Exercise 1 solution). The Lean file comments: *"From the Appendix (Chapter 10 exercise 1): needed by `neg_one_mul` below."* This is a forward reference from the main text to the appendix, breaking the book's "proofs before use" principle.

**WHY IT MATTERS:** The proof of `neg_one_mul` in the book uses `mul_zero_left` as a lemma, but the reader hasn't seen it proved yet. The book's pedagogical stance is that every theorem is proved before it's used; this violates that.

**FIX:** Either (a) move `mul_zero_left` proof into the main chapter before `neg_one_mul`, or (b) restructure `neg_one_mul` proof to not depend on `mul_zero_left` (e.g., prove it directly from `right_distrib` and group cancellation, mirroring `mul_zero`).

---

#### C3. Ch9: `Mat2.ext` presented as auto-generated but must be hand-written

**WHERE:** `09-rings/07-matrices.md` (prose) vs `Ch09Rings.lean:95-106` (Lean)

**WHAT:** The book's matrix ring example uses `apply Mat2.ext <;> ...` in multiple proofs, with the text stating or implying that `Mat2.ext` is an auto-generated field-wise extensionality lemma (like Mathlib's `@[ext]`). The Lean file comment explicitly states: *"the book's `apply Mat2.ext <;> ring` proofs used two things not actually available: `Mat2.ext` (core Lean 4 does not auto-generate a field-wise extensionality lemma for a plain `structure` — that's a Mathlib `@[ext]` convenience) and `ring` (a Mathlib-only decision procedure; this book never imports Mathlib). Both are supplied by hand below: `Mat2.ext` via the `mk.injEq` lemma core Lean *does* generate."*

**WHY IT MATTERS:** The book teaches that `structure` gives you `.ext` for free — it doesn't. Core Lean only gives `mk.injEq` (which requires manual `cases` and `rw`). The book's proofs using `apply Mat2.ext` would not compile without the hand-written `Mat2.ext` theorem in the Lean file. This misrepresents core Lean's capabilities.

**FIX:** In `07-matrices.md`, explicitly state that `Mat2.ext` is **not** auto-generated, show the hand-written proof using `mk.injEq`, and note that Mathlib's `@[ext]` attribute provides this convenience. Update the proof sketches to use `cases X; cases Y; rw [Mat2.mk.injEq]; constructor <;> ...` pattern instead of `apply Mat2.ext`.

---

### HIGH

#### H1. Ch11: `evenSubmodule` uses `intZModule` that doesn't exist in prose

**WHERE:** `11-modules/04-submodules.md` (prose) vs `Ch11Modules.lean:68-80` (Lean)

**WHAT:** The `evenSubmodule` definition references `intZModule` in a comment but the prose never defines it. The Lean file supplies `intZModule` (see C1 above). The book cannot be followed to build `evenSubmodule` without this missing definition.

**FIX:** Same as C1 — add `intZModule` to the book.

---

## 4. Minor Concerns (MEDIUM/LOW)

### N5. Schiffler numbering self-contradictory as printed (LOW)

...

---

## 4. Minor Concerns (LOW)

### N5. Schiffler numbering self-contradictory as printed

**WHERE:** `11-path-algebras/05-path-composition.md:191`

**WHAT:** *"Schiffler, **Definition 4.5** (Chapter 4, §4.2) … unit given explicitly … in the lemma immediately following (**Lemma 4.3** in that source's numbering)."*

**WHY IT MATTERS:** A Lemma 4.3 cannot immediately follow a Definition 4.5 under one numbering scheme; one of the two numbers is wrong.

**STATUS:** **FLAGGED** in FINAL-REVIEW §6b — Springer's copy is paywalled, so numbering could not be checked. The impossible "Lemma 4.3 immediately following Definition 4.5" claim was **dropped rather than guessed**, with an explicit "Numbering not independently verified" box saying so. **Still open for anyone with the printed source.**

**IMPACT:** LOW — does not affect mathematical content, only citation precision.

---

### N3. Chapter 11 uses three composition orders in one section (now fixed)

**WHERE:** `11-path-algebras/05-path-composition.md` — previously had prose in path order, formula in function order, quoted source in third order.

**STATUS:** **FIXED** in FINAL-REVIEW §6b — $kQ$ multiplication rewritten in path order ($p \cdot q = p;q$ when $t(p) = s(q)$, else $0$), with parenthetical for function-order sources; Sources box notes ASS's quoted product is also path order.

---

### N4. Gentzen dated 1934 in body, 1935 in citation (now fixed)

**STATUS:** **FIXED** in FINAL-REVIEW §6b — "Gentzen, 1934" → "Gentzen, 1935 — independently, and in a different notation, Jaśkowski 1934."

---

## 5. Chapter-by-Chapter Verification

### Chapter 8: Group Theorems

| Theorem | Statement | Proof Method | Lean Verification |
|---|---|---|---|
| `id_unique` | Left identity = `id` | Relate both to `e' * id` | ✅ Compiles, matches prose |
| `left_inverse_unique` | Left inverse = `inv a` | Pad with `id`, swap for cancelable | ✅ Compiles, matches prose |
| `inv_op` | `(ab)⁻¹ = b⁻¹a⁻¹` | Reuse `left_inverse_unique` | ✅ Compiles, applies to `perm3Group` |

**Degenerate cases:** `G := Unit` (trivial group) — all hold. ✅

**Non-abelian witness:** `perm3Group` (permutations of 3) — specifically exercises `id_left`/`id_right` and `inv_left`/`inv_right` split. ✅

---

### Chapter 9: Rings

| Component | Verification |
|---|---|
| `CommGroup` definition | `extends Group` + `comm` field — correct |
| `Ring` definition | Bundles `addGrp : CommGroup`, adds `mul`, `one`, associativity, identity, distributivity — correct |
| `intRing` | Reuses `intCommGroup`, cites `Int.mul_add`/`Int.add_mul` for distributivity — correct |
| `fin3Ring` | Carrier `Fin 3`, all axioms `by decide` — correct (finite brute force) |
| `mat2Ring` | 2×2 integer matrices, explicit polynomial identity proofs via `add4_reorder` helper — **compiler-verified**, no `ring` tactic used |

**Degenerate cases:** Zero ring (`1 = 0`) — `Ring` does not exclude it; `mul_zero` holds vacuously. ✅ Matches Dummit & Foote §7.1.

**Noncommutative witness:** `mat2Ring` — `X * Y = ⟨2,1,1,1⟩`, `Y * X = ⟨1,1,1,2⟩`, inequality proved by `decide` on field equality. ✅

---

### Chapter 10: Ring Theorems

| Theorem | Statement | Proof Pattern | Lean Verification |
|---|---|---|---|
| `mul_zero` | `a * 0 = 0` | `0 = 0+0`, `left_distrib`, group cancellation | ✅ Fixed `rw` occurrence bug → `congrArg` |
| `mul_zero_left` | `0 * a = 0` | Mirror of `mul_zero` using `right_distrib` | ✅ Compiles |
| `neg_one_mul` | `(-1) * a = -a` | Uses `left_inverse_unique`, `right_distrib`, `mul_zero_left` | ✅ Fixed two compiler-caught bugs (dropped `Eq.symm`, `conv_lhs` → `congrArg`) |

**Key insight:** The "pad with identity, then cancel" pattern from Chapter 8 Theorem 2 is explicitly recognized and reused. ✅

---

### Chapter 11: Modules

| Component | Verification |
|---|---|
| `Module` definition | `addGrp : CommGroup M`, `smul : R → M → M`, four axioms (M1)-(M4) — correct |
| `intSmul` / `natSmul` | Iterated `op` for `Nat`, extended to `Int` via `inv` — correct |
| `intZModule` | `Module Int intRing Int`, `smul = *` — **supplied in Lean (not in book)**, needed for `evenSubmodule` |
| `evenSubmodule` | Carrier `{m | ∃ k, m = 2*k}`, all three closure proofs by `show`/`rw` — correct |
| `LinearMap` | `toFun`, `map_add`, `map_smul` — correct |
| `DirectSum` module | Componentwise operations, all axioms by congruence — correct |

**Gap noted:** Book references `intZModule` only in a comment for `evenSubmodule` without defining it. Lean module supplies it explicitly. This is a **book prose gap**, not a math error.

**Degenerate cases:** `M := Unit` (trivial module), `DirectSum` with empty components — all hold. ✅

---

## 6. Boundary / Degenerate Case Sweep (AMS Standard)

| Structure | Degenerate Case | Handled? |
|---|---|---|
| `Group G` | `G := Unit` (trivial group) | ✅ All theorems hold |
| `Ring R` | Zero ring (`1 = 0`) | ✅ `mul_zero` holds vacuously; book doesn't exclude it |
| `Module R Rg M` | `M := Unit` | ✅ Trivial module |
| `Fin n` | `Fin 0` (empty), `Fin 1` | ✅ `Vec.head` excludes length 0 in type |
| Quiver | Empty quiver (`A = ∅`, `V = ∅`) | ✅ Path algebra unit qualified "when $Q_0$ finite" |
| DirectSum | Empty component types | ✅ Componentwise definitions handle vacuously |

No degenerate case is mishandled.

---

## 7. Verification Log

**Read in full:**
- `08-group-theorems/` (5 files)
- `09-rings/` (8 files)
- `10-ring-theorems/` (6 files)
- `11-modules/` (6 files)
- `12-path-algebras/05-path-composition.md` (composition order fix)
- All "Sources, quoted" boxes in these chapters
- Corresponding Lean modules: `Ch08GroupTheorems.lean`, `Ch08GroupTheoremsMathlib.lean`, `Ch09Rings.lean`, `Ch09RingsMathlib.lean`, `Ch10RingTheorems.lean`, `Ch10RingTheoremsMathlib.lean`, `Ch11Modules.lean`, `Ch11ModulesMathlib.lean`

**Compilation:** `lake build` passed (8681 jobs, zero errors). All Lean blocks in these chapters compile.

**Worked examples recomputed by hand:**
- `08-group-theorems/04-theorem-3.md` — all six `#eval` outputs recomputed. `op swap01 cycle012` = (1 2); inverse sends 0↦0, 1↦2, 2↦1. Both sides give `0,0,2,2,1,1`. ✅
- `09-rings/07-matrices.md` — `Mat2.mul X Y = ⟨2,1,1,1⟩`, `Mat2.mul Y X = ⟨1,1,1,2⟩`. Non-commutativity verified. ✅
- `10-ring-theorems/02-theorem-1.md` `mul_zero` — `congrArg` + four-`rw` chain. Every intermediate goal-state comment correct; `inv_left` does not mis-fire. ✅

**Proofs recomputed step by step:**
- `09-ring-theorems/02-theorem-1.md` `mul_zero` — Sound. ✅
- `10-ring-theorems/03-theorem-2.md` `neg_one_mul` — regroup/cancel chain. ✅
- `08-group-theorems/04-theorem-3.md` `inv_op` — regroup/cancel chain. ✅

---

## 8. Findings Summary

| ID | Severity | Finding | Status |
|---|---|---|---|
| C1 | CRITICAL | `intZModule` missing from Ch11 Markdown (Lean calls it "a real gap") | OPEN |
| C2 | CRITICAL | `neg_one_mul` depends on `mul_zero_left` only in Appendix | OPEN |
| C3 | CRITICAL | `Mat2.ext` presented as auto-generated but must be hand-written | OPEN |
| H1 | HIGH | `evenSubmodule` uses `intZModule` not in prose | OPEN |
| — | — | No wrong theorems | ✅ Clean |
| — | — | No circular reasoning | ✅ Clean |
| — | — | No unused hypotheses | ✅ Clean |
| — | — | No silently weakened statements | ✅ Clean |
| — | — | No incorrect worked examples | ✅ Clean |
| — | — | No Lean code faking correctness | ✅ Clean |
| N5 | LOW | Schiffler numbering (Def 4.5 vs Lemma 4.3) | FLAGGED — needs physical source |
| N3 | — | Three composition orders | FIXED |
| N4 | — | Gentzen 1934/1935 | FIXED |

---

## 9. Strengths Worth Preserving

- **Pattern recognition across chapters:** "Pad with identity, then cancel" (Ch 8 Thm 2) → `mul_zero` (Ch 10 Thm 1) → `neg_one_mul` (Ch 10 Thm 3) explicitly linked.
- **Compiler-caught bugs documented and fixed:** `rw` occurrence targeting, missing `Mat2.ext`, unavailable `ring` tactic, `Eq.symm` misapplication, `conv_lhs` failure — all explicitly noted in Lean modules.
- **Noncommutative witnesses built honestly:** `perm3Group` for groups, `mat2Ring` for rings — no shortcuts, every axiom field verified.
- **Finite carrier `decide` usage pedagogically motivated:** `Fin 3`, `Bool` rings show when axioms become decidable brute-force checks.
- **Module chapter correctly positioned:** Immediately before Chapter 12 (path algebras), since representations of $Q$ are modules over $kQ$.
- **Mathlib equivalent boxes:** Every example shows both from-scratch and real Mathlib API.