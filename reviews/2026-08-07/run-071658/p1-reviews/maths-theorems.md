<<<REPORT_START>>>

# Adversarial Review: Maths-Theorems Slice (Chapters 3, 5, 6, 7)

**Slice:** `lean_book/03-propositions-and-proofs/*.md`, `lean_book/05-rigor-check/*.md`, `lean_book/06-groups/*.md`, `lean_book/07-group-theorems/*.md`
**Reviewer:** Maths-Theorems (adversarial)
**Date:** 2026-08-07

---

## Summary

This slice covers the logical foundations (Ch. 3), the rigor checkpoint (Ch. 5), the `Group` structure definition and examples (Ch. 6), and the first generic group theorems (Ch. 7). The mathematical content is **largely correct and well-structured**, with a clear pedagogical arc from Curry–Howard through universe hierarchy to concrete group constructions and generic theorems. However, the slice contains **multiple regression issues from the v1.4.25/v1.5.0 changes**, **inconsistent cross-references**, **missing or incorrect version pins**, and **several mathematical/Lean inaccuracies** that range from minor to major.

---

## Recommendation

**CONDITIONAL PASS** — The slice is mathematically sound in its core but requires fixes for:
1. Version consistency (v4.32.2 nowhere explicitly pinned in these files, but referenced indirectly)
2. Broken cross-references to removed "Story"/"Sections" scaffolding
3. Learning objectives boxes present but some contradict chapter body
4. Mathematical errors in Ch. 5 universe explanation and Ch. 6 permutation group construction
5. Lean code issues (missing imports, incorrect `decide` usage, `rw` direction confusion)

---

## Major Concerns (Severity: HIGH)

### M1. Version Inconsistency: No Explicit v4.32.2 Pin in Slice Files
**WHAT:** The v1.5.0 changes pinned the toolchain to v4.32.2 "everywhere (project *and* docs)". None of the 20 files in this slice contain an explicit Lean version declaration or version pin. The index files reference `lean_project` and `lake env lean` but never state the version.

**WHY:** A reader following the book in a fresh environment has no way to verify they are on the correct toolchain. The `lean-toolchain` file in the project root may say v4.32.2, but the book itself (which is the documentation) does not confirm this in the chapters where code is introduced.

**IMPACT:** High — users on v4.33.0 (or any other version) will encounter silent incompatibilities (e.g., `decide` behavior changes, universe polymorphism syntax, tactic differences) with no guidance.

**FIX:** Add a "Toolchain version" callout box in each chapter's index file (or in 00-setup/02-installing-toolchain.md which is outside this slice but referenced) stating: `This book uses Lean 4.32.2. Pin your toolchain with \`echo "leanprover/lean4:4.32.2" > lean-toolchain\`.`

**EVIDENCE:** 
- `03-propositions-and-proofs/00-index.md`: No version mention
- `05-rigor-check/00-index.md`: No version mention  
- `06-groups/00-index.md`: No version mention
- `07-group-theorems/00-index.md`: No version mention
- `05-rigor-check/06-checkpoint-project.md:73`: References `lake env lean` without version context

---

### M2. Regression: "Story" and "Sections" Sections Still Present in Markdown but Supposedly Removed from LaTeX
**WHAT:** The v1.5.0 changes state: "LaTeX removed 'Story' and 'Sections' sections". However, **all four index files in this slice still contain both sections** in their markdown source:
- `## The story of this chapter`
- `## Sections` (with numbered lists)

**WHY:** If the LaTeX build process now suppresses these sections, the markdown source should either be cleaned up (sections removed) or the suppression should be documented. As it stands, there is a disconnect: the rendered PDF will not match the source navigation. Cross-references *within* the markdown (e.g., "Section 1", "Section 2" in the story narrative) point to sections that may not appear in the final output.

**IMPACT:** High — broken navigation in rendered output; readers following "Section 1" links in the story narrative will find those sections missing in PDF.

**EVIDENCE:**
- `03-propositions-and-proofs/00-index.md:14-60`: Full "The story of this chapter" with 7 numbered sections
- `03-propositions-and-proofs/00-index.md:62-71`: "## Sections" with 8 numbered items
- `05-rigor-check/00-index.md:23-61`: "The story of this chapter" with 4 numbered sections
- `05-rigor-check/00-index.md:67-74`: "## Sections" with 6 numbered items
- `06-groups/00-index.md:13-50`: "The story of this chapter" with 6 numbered sections
- `06-groups/00-index.md:56-64`: "## Sections" with 7 numbered items
- `07-group-theorems/00-index.md:21-52`: "The story of this chapter" with 4 numbered sections
- `07-group-theorems/00-index.md:57-63`: "## Sections" with 5 numbered items

**FIX:** Either (a) remove these sections from markdown source entirely, or (b) add a conditional build tag (e.g., `<!-- OMIT_FROM_LATEX -->`) and document the discrepancy. Given the instruction says "LaTeX removed" them, option (a) is correct — delete from markdown.

---

### M3. Mathematical Error: Universe Hierarchy Explanation in Ch. 5 is Incorrect
**WHAT:** `05-rigor-check/02-universes.md` lines 50-56 claim:
> "Why does `Type → Type` live in `Type 1` rather than back in `Type 0`? ... Forming `A → B` when `A : Type i` and `B : Type j` produces a term of type `Type (max i j)`. Concretely here, `A := Type` (living in `Type 1`, since `Type : Type 1`) and `B := Type` again, so `Type → Type` itself lands in `Type (max 1 1) = Type 1`."

**WHY:** This is **wrong**. In Lean 4, `Type` (i.e., `Type 0`) is `Sort 1`. The function type `Type → Type` is `Sort 1 → Sort 1`, which lives in `Sort (max 1 1) = Sort 1 = Type 0`, **not** `Type 1`. The error comes from confusing the universe level of `Type` itself (`Type : Type 1`, so `Type` is at level 1) with the universe level of the *function type* `Type → Type`.

Correct calculation:
- `Type` = `Sort 1` : `Sort 2` (i.e., `Type 1`)
- `Type → Type` = `Sort 1 → Sort 1` : `Sort (max 1 1)` = `Sort 1` = `Type 0`

So `Group : Type → Type` actually lives in `Type 0`, **not** `Type 1`. The claim that "Group is not even a candidate carrier type for its own construction. It sits one universe level too high" is false.

**IMPACT:** Critical — this misleads readers about a foundational aspect of Lean's type theory. The subsequent discussion of universe polymorphism (lines 65-76) is built on this incorrect premise.

**EVIDENCE:** `05-rigor-check/02-universes.md:50-56`

**FIX:** Rewrite the universe calculation correctly. `Group : Type → Type` has type `Type 0` (since it's a function between `Type 0` types). The reason `Group` cannot be its own carrier is that `Group G` expects `G : Type`, but `Group` itself is `Type → Type`, not `Type`. The universe level is not the obstruction; the *kind* (type vs. type constructor) is.

---

### M4. Lean Code Error: `decide` Cannot Prove `isPrime 5` as Written
**WHAT:** `03-propositions-and-proofs/06-quantifiers.md` lines 54-58 define:
```lean
@[reducible] def isPrime (n : Nat) : Prop :=
  n ≥ 2 ∧ ∀ m : Nat, m < n → m ≥ 2 → ¬ (m ∣ n)

theorem exists_prime_gt_three : ∃ p : Nat, p > 3 ∧ isPrime p :=
  ⟨5, by decide⟩
```

**WHY:** `decide` only works on *decidable* propositions. The definition of `isPrime` uses `∀ m : Nat, ...` which is **not** automatically decidable in Lean 4 (it requires `Nat.strong_induction_on` or similar). The `@[reducible]` attribute does not make it decidable; it only controls definition unfolding. `by decide` will fail with "type class inference failed: Decidable (∀ m : ℕ, m < 5 → m ≥ 2 → ¬m ∣ 5)".

**IMPACT:** High — the code as written does not compile. This is a concrete Lean 4 error that breaks the example.

**EVIDENCE:** `03-propositions-and-proofs/06-quantifiers.md:54-58`

**FIX:** Either (a) use `norm_num [isPrime]` with a `decide` on the resulting finite conjunction, or (b) prove `isPrime 5` by `decide` after making `isPrime` a `decidable_pred` via `instance : DecidablePred isPrime := ...`, or (c) replace with `by norm_num [isPrime]` which works because `norm_num` can evaluate the bounded universal quantifier.

---

### M5. Lean Code Error: `Perm3` Construction Missing `Function.Bijective` Proofs
**WHAT:** `06-groups/04-permutations-example.md` defines `Perm3` as a structure with `toFun`, `invFun`, and proofs they are inverses. However, the `Group Perm3` instance (lines 141-170) uses `Perm3.ext` which requires proving equality of *both* `toFun` and `invFun`. The `assoc`, `id_left`, `id_right` proofs use `rfl` on function equality, but Lean 4 does **not** reduce function composition `(f ∘ g)` to a lambda automatically — `rfl` will fail on `f.toFun ∘ g.toFun = f.toFun ∘ g.toFun` when the goal expects pointwise equality.

**WHY:** In Lean 4, function extensionality is not definitional. `Perm3.ext` correctly states that two `Perm3`s are equal iff their `toFun` and `invFun` are pointwise equal. But the proofs of `assoc`, `id_left`, etc. use `apply Perm3.ext` followed by `intro x; rfl`. This `rfl` only works if both sides are *definitionally* equal after unfolding. For `assoc`: `(f ∘ g) ∘ h` vs `f ∘ (g ∘ h)` are **not** definitionally equal — they are only propositionally equal via `Function.funext_iff`. The `rfl` will fail.

**IMPACT:** High — the `perm3Group` construction as written will not type-check.

**EVIDENCE:** `06-groups/04-permutations-example.md:145-169`

**FIX:** Replace `rfl` with `funext x; rfl` or `simp [Function.comp_apply]` to prove pointwise equality. The `rfl` tactic cannot prove equality of composed functions without extensionality.

---

### M6. Mathematical Error: Ch. 7 Theorem 2 Proof Uses `inv_right` Backwards Incorrectly
**WHAT:** `07-group-theorems/03-theorem-2.md` lines 36-45:
```lean
have e1 : b = Grp.op b Grp.id := (Grp.id_right b).symm
rw [e1]
rw [← Grp.inv_right a]
```

**WHY:** The proof claims to "pad `b` with the identity, then swap the identity for something you can cancel." The chain is:
`b = b·e = b·(a·a⁻¹) = (b·a)·a⁻¹ = e·a⁻¹ = a⁻¹`

But line 39 `rw [← Grp.inv_right a]` rewrites `Grp.id` (which is `e`) as `Grp.op a (Grp.inv a)` (i.e., `a·a⁻¹`). However, `Grp.inv_right a : Grp.op a (Grp.inv a) = Grp.id`. So `← Grp.inv_right a` rewrites `Grp.id` → `a·a⁻¹`. This is correct *if* the goal contains `Grp.id`. But after `rw [e1]`, the goal is `Grp.op b Grp.id = Grp.inv a`. The `Grp.id` here is the *right argument* of `Grp.op`. Rewriting it with `← Grp.inv_right a` changes `Grp.op b Grp.id` to `Grp.op b (Grp.op a (Grp.inv a))`, which is `b·(a·a⁻¹)`. This matches the intended chain.

**BUT:** The next step `rw [← Grp.assoc b a (Grp.inv a)]` rewrites `b·(a·a⁻¹)` to `(b·a)·a⁻¹`. `Grp.assoc b a (Grp.inv a) : Grp.op (Grp.op b a) (Grp.inv a) = Grp.op b (Grp.op a (Grp.inv a))`. So `← Grp.assoc` rewrites the *right side* to the *left side*, i.e., `b·(a·a⁻¹)` → `(b·a)·a⁻¹`. This is correct.

Then `rw [h]` where `h : Grp.op b a = Grp.id` rewrites `(b·a)·a⁻¹` to `e·a⁻¹`. Correct.

Then `exact Grp.id_left (Grp.inv a)` which is `e·a⁻¹ = a⁻¹`. Correct.

**So the proof is actually correct.** My initial reading flagged this as an error, but on careful inspection the `rw` directions are right. **This is NOT an error — retracting.**

---

### M7. Regression: Learning Objectives Boxes Present But Some Contradict Chapter Body
**WHAT:** Each index file has a "## Learning objectives" box. However, several objectives are not actually covered in the chapter body, or are covered in a different form.

**EVIDENCE:**
- `03-propositions-and-proofs/00-index.md:9-12`: Objective "Write and prove `theorem`/`lemma`s directly as terms" — Ch. 3 Section 3 (`03-theorem-lemma.md`) is only 26 lines and shows `theorem` syntax but does not cover "prove directly as terms" in any depth (no term-mode proofs of non-trivial statements).
- `05-rigor-check/00-index.md:9-11`: Objective "Distinguish definitional from propositional equality, and predict when `rfl` alone will and will not close a goal" — This is covered in Section 4 (`04-defeq-vs-propeq.md`), but the checkpoint project (`06-checkpoint-project.md`) does not exercise this distinction.
- `06-groups/00-index.md:9-11`: Objective "Build both an abelian (`Int`) and a genuinely non-abelian (permutations of `Fin 3`) example from scratch" — The permutation example uses a custom `Perm3` structure, not `Fin 3` permutations directly. The objective says "permutations of `Fin 3`" but the implementation is a hand-rolled bijection structure.
- `07-group-theorems/00-index.md:9-11`: Objective "Reuse a proved lemma (`left_inverse_unique`) to shortcut a later one (`inv_op`) instead of re-deriving it" — This is correctly demonstrated in Theorem 3.

**IMPACT:** Medium — learning objectives set expectations that are not fully met, reducing trust in the book's self-assessment.

**FIX:** Align learning objectives with actual content, or expand content to meet objectives.

---

### M8. Cross-Reference Error: Ch. 6 Index References "Mathlib Equivalent" Boxes That Don't Exist in All Sections
**WHAT:** `06-groups/00-index.md:66-69` states:
> "Starting with this chapter, most examples are followed by a 'Mathlib equivalent' box (see [00-setup/04-mathlib-note.md](../00-setup/04-mathlib-note.md)). For links to the official docs for every Mathlib name used in those boxes, see the [tactic and library reference](../tactic-and-library-reference.md)."

**WHY:** Not all sections in Ch. 6 have "Mathlib equivalent" boxes. Sections 1 (Definition), 2 (Translating), 5 (Accessing fields), 6 (Why bundle) have no Mathlib equivalent boxes. Only Sections 3 (Integers) and 4 (Permutations) have them.

**IMPACT:** Medium — misleading promise; readers expect boxes that aren't there.

**EVIDENCE:** Check each section file:
- `01-definition.md`: No Mathlib box
- `02-translating.md`: Has a "Read more" box referencing Mathlib's `Group` class, but not labeled "Mathlib equivalent"
- `03-integers-example.md`: Has "Mathlib equivalent" box (line 55)
- `04-permutations-example.md`: Has "Mathlib equivalent" box (line 191)
- `05-accessing-fields.md`: Has "Mathlib equivalent" box (line 28)
- `06-why-bundle.md`: Has "Mathlib equivalent" box (line 16)

Actually, Sections 2, 5, 6 *do* have Mathlib-equivalent content (though Section 2 calls it "Read more"). The index claim "most examples" is roughly accurate but "followed by" implies every example section, which is not true for Section 1.

**FIX:** Qualify the statement: "Sections 3–6 include 'Mathlib equivalent' boxes..."

---

## Major Concerns (Severity: MEDIUM)

### M9. Missing Import Statements in Lean Code Snippets
**WHAT:** Multiple Lean code snippets use identifiers without the necessary `open` or `import` statements, making them non-copy-pasteable.

**EVIDENCE:**
- `03-propositions-and-proofs/06-quantifiers.md:54`: Uses `Fin` in later chapters but not here; uses `Nat` (OK, in Prelude)
- `06-groups/04-permutations-example.md:17`: Uses `Fin 3` but no `import Mathlib.Data.Fin.Basic` or `open Fin`
- `06-groups/04-permutations-example.md:37`: Uses `∘` (function composition) without `open Function`
- `07-group-theorems/04-theorem-3.md:76`: Uses `perm3Group`, `swap01`, `cycle012` defined in Ch. 6 but no import path given

**IMPACT:** Medium — readers copying code into a fresh Lean file will get "unknown identifier" errors.

**FIX:** Add `import`/`open` comments above each standalone snippet, or a preamble note.

---

### M10. Ch. 5 Typing Rules Section: STLC Rules Don't Match Lean's Actual Rules
**WHAT:** `05-rigor-check/03-typing-rules-and-safety.md` presents STLC (Simply Typed Lambda Calculus) as "the actual rules the kernel of Lean checks a term against (using a small, representative fragment)".

**WHY:** Lean's kernel checks terms against the **Calculus of Inductive Constructions (CIC)**, not STLC. STLC lacks: dependent types (Π-types), inductive types, universe polymorphism, `Prop` impredicativity, and cumulativity. The section acknowledges this at line 127 ("What STLC still cannot do") but the framing at lines 12-13 ("the actual rules the kernel of Lean checks... using STLC") is misleading. STLC is a *fragment*, not the actual rules.

**IMPACT:** Medium — pedagogical confusion about what Lean's kernel actually does.

**FIX:** Rephrase: "a small, representative fragment (STLC) that illustrates the core typing discipline; the full kernel uses CIC which extends STLC with..."

---

### M11. Ch. 5 Progress/Preservation: Incorrect Attribution to Pierce for STLC
**WHAT:** `05-rigor-check/03-typing-rules-and-safety.md` lines 248-261 cite Pierce 2002 for Progress/Preservation theorems for STLC.

**WHY:** Pierce's Theorems 9.3.5 and 9.3.9 are for STLC *with* base types and constants. The statements quoted are correct for that system. However, the section presents these as the reason "well-typed proofs do not go wrong" for Lean. Lean's metatheory is proved for CIC, not STLC. The connection is analogical, not direct.

**IMPACT:** Medium — overstates the formal connection.

**FIX:** Clarify that progress/preservation for CIC (Lean's actual calculus) are much more complex theorems (see e.g., Sozeau et al. "The Meta-Coq Project" or the Lean 4 kernel correctness proofs), and STLC is only a pedagogical illustration.

---

### M12. Ch. 6 `Group` Definition: Missing `inv_left`/`inv_right` Symmetry Explanation
**WHAT:** `06-groups/02-translating.md` lines 58-59: "The remaining four fields are the identity and inverse axioms. They are split into left and right versions because commutativity has not been assumed."

**WHY:** This is correct but incomplete. In a *group*, left and right inverses *are* provably equal (Ch. 7 Theorem 2). The definition includes both as axioms, which is redundant but standard for a "minimal axiom set" that doesn't assume the theorems. The text should note this redundancy explicitly: "Both are included as axioms; Ch. 7 will prove they are equivalent."

**IMPACT:** Low-Medium — missed pedagogical opportunity to foreshadow Ch. 7.

**FIX:** Add a remark: "Note: including both `inv_left` and `inv_right` is redundant (one implies the other given the other axioms), but this book keeps both as primitive to avoid forward references. Chapter 7 proves `left_inverse_unique` showing they coincide."

---

### M13. Ch. 7 Theorem 3: `inv_op` Proof Uses `left_inverse_unique` Before It's in Scope
**WHAT:** `07-group-theorems/04-theorem-3.md` line 35: `apply left_inverse_unique`

**WHY:** The `variable` declaration in `01-setup.md` (line 18) makes `Grp : Group G` implicit. Theorems 1 and 2 are proved in the same namespace, so `left_inverse_unique` is available. This is correct Lean scoping. **Retracting — not an error.**

---

### M14. Ch. 3 `or_comm_term` Proof: `Or.elim` Arguments in Wrong Order
**WHAT:** `03-propositions-and-proofs/05-and-or-not.md` line 36:
```lean
theorem or_comm_term {P Q : Prop} (h : P ∨ Q) : Q ∨ P :=
  Or.elim h (fun hp => Or.inr hp) (fun hq => Or.inl hq)
```

**WHY:** `Or.elim h h₁ h₂` expects `h₁ : P → R` and `h₂ : Q → R`. Here `R = Q ∨ P`. The first argument `(fun hp => Or.inr hp)` has type `P → Q ∨ P` (correct for `h₁`). The second `(fun hq => Or.inl hq)` has type `Q → Q ∨ P` (correct for `h₂`). This is actually **correct**. The order is `(P → R)` then `(Q → R)`. **Retracting — not an error.**

---

### M15. Ch. 3 `not_example`: `decide` on `¬(1 = 2)` Works But For Wrong Reason
**WHAT:** `03-propositions-and-proofs/05-and-or-not.md` lines 54-55:
```lean
theorem not_example : ¬(1 = 2) := by decide
```

**WHY:** `decide` works here because `1 = 2` is a decidable *closed* proposition (both sides are numerals). The text says "equality of `Nat` literals is decidable" (line 122). This is correct. But the mathematical reading (lines 120-127) says "Underlying this is exactly the same fact used throughout this book: distinct constructors of an inductive type (`Nat.succ`, applied a different number of times) are disjoint, so `1 = 2` has no proof to begin with." This is correct for `Nat`, but `decide` uses the `Decidable` instance which for `Nat` equality is computational (kernel reduction), not the constructor-disjointness proof. The explanation conflates the *metatheoretic* reason (constructor disjointness) with the *implementation* (kernel computation).

**IMPACT:** Low — technically accurate but slightly confused explanation.

**FIX:** Clarify: "`decide` uses the kernel's computational equality check, which reduces both sides and sees they are different constructors. This computational check is sound *because* distinct constructors are disjoint."

---

## Minor Concerns (Severity: LOW)

### m1. Ch. 3 Index: Cross-Reference to Ch. 1 Section 5 Uses Wrong Path
**WHAT:** `03-propositions-and-proofs/01-prop.md:66`: `[Chapter 1, Section 5](../01-basics/05-pi-sigma-and-coc.md)`

**WHY:** The path `../01-basics/05-pi-sigma-and-coc.md` is correct relative to `03-propositions-and-proofs/`. But the link text says "Chapter 1, Section 5" while the file is `05-pi-sigma-and-coc.md`. This is fine. **No error.**

---

### m2. Ch. 3 Section 2: "Skip ahead to Chapter 3, Section 3" Self-Reference
**WHAT:** `03-propositions-and-proofs/02-logic-recap.md:11`: "Skip ahead to [Chapter 3, Section 3](03-theorem-lemma.md)"

**WHY:** This section *is* Chapter 3, Section 2. The link is correct (relative path `03-theorem-lemma.md`). The text "Chapter 3, Section 3" is accurate. **No error.**

---

### m3. Ch. 5 Section 2: Girard Citation Confusion
**WHAT:** `05-rigor-check/02-universes.md:103`: "Girard, *'Interprétation fonctionnelle...'* Thèse d'État, 1972 (not yet in the bibliography)... [Girard1971] (the 1971/1970 paper... already in the bibliography) is a different, earlier paper and is not that source."

**WHY:** The bibliography entry `[Girard1971]` is cited but the text says it's the *wrong* paper. This is confusing. Either cite the correct paper or remove the misleading citation.

**IMPACT:** Low — bibliographic hygiene.

**FIX:** Add the 1972 thesis to bibliography, or remove the `[Girard1971]` citation from this section.

---

### m4. Ch. 5 Section 3: Python `TypeVar` Comparison Overstates Similarity
**WHAT:** `05-rigor-check/03-typing-rules-and-safety.md:141-157` compares Lean's `identity {α : Type} (x : α) : α := x` to Python's `TypeVar`.

**WHY:** The comparison is useful but the claim "It is a much lighter version of the same extra generality" is misleading. Python's `TypeVar` is *prenex* polymorphism (System F style), while Lean's `{α : Type}` is *dependent* polymorphism (Π-type). They are fundamentally different: Lean's version allows the return type to depend on the *value* of `α` (e.g., `Vec α n`), Python's does not. The text acknowledges this at line 163-165 but the initial comparison overstates the similarity.

**IMPACT:** Low — pedagogical simplification, but flagged.

---

### m5. Ch. 6 Section 4: `Perm3.ext` Proof Uses `cases` on Structure
**WHAT:** `06-groups/04-permutations-example.md:132-139`:
```lean
theorem Perm3.ext {f g : Perm3} (h : ∀ x, f.toFun x = g.toFun x)
    (h' : ∀ x, f.invFun x = g.invFun x) : f = g := by
  cases f
  cases g
  simp only [mk.injEq]
  constructor
  · funext x; exact h x
  · funext x; exact h' x
```

**WHY:** `cases f` on a structure with 4 fields produces 4 variables. `cases g` produces 4 more. `simp only [mk.injEq]` then changes the goal to equality of the 4-tuples. This works but is fragile (depends on field order). Better: `ext <;> simp_all [Perm3.toFun, Perm3.invFun] <;> aesop` or use `Structure.ext_iff`. The current proof is acceptable but not idiomatic Lean 4.

**IMPACT:** Low — style only.

---

### m6. Ch. 7 Section 1: `variable` Declaration Uses Implicit `{G : Type}`
**WHAT:** `07-group-theorems/01-setup.md:18`: `variable {G : Type} (Grp : Group G)`

**WHY:** This makes `G` implicit in all subsequent theorems. The theorems then have signature `theorem id_unique (e' : G) ...` where `G` is implicit. This is fine, but the mathematical reading (lines 24-30) says "Everything proved under this `variable` is a statement quantified over *all* groups. A theorem about the group `Grp` is really `∀ (G : Type) (Grp : Group G), ...`". This is correct. However, the implicit `{G}` means users must sometimes `@id_unique` to provide `G` explicitly. Not an error, but worth noting.

**IMPACT:** Low — Lean technicality.

---

### m7. Ch. 7 Section 4: `#eval` on `perm3Group.inv` Requires `Perm3.toFun` to Be Computable
**WHAT:** `07-group-theorems/04-theorem-3.md:86-93` uses `#eval` on `perm3Group.inv (...)`.toFun`.

**WHY:** `Perm3.inv` (Ch. 6 line 73-78) swaps `toFun` and `invFun`. Both are defined by `match` on `Fin 3`, so they are computable. `#eval` will work. **No error.**

---

### m8. Ch. 3 Section 7: `congr_example` Uses `rw` But Could Use `congr_arg`
**WHAT:** `03-propositions-and-proofs/07-equality.md:27-29`:
```lean
theorem congr_example {a b : Nat} (h : a = b) : a + 1 = b + 1 := by
  rw [h]
```

**WHY:** This is fine. `congr_arg (fun x => x + 1) h` would be more direct but `rw` is the "workhorse" as the text says. **No error.**

---

### m9. Ch. 5 Section 4: Proof Irrelevance Explanation Confuses Definitional and Propositional
**WHAT:** `05-rigor-check/04-defeq-vs-propeq.md:105-115`: "If `h1 h2 : a = b` are two different proof *terms* of the same propositional equality, `h1` and `h2` are definitionally equal to each other..."

**WHY:** This is correct for `Prop`-valued equalities in Lean (proof irrelevance). But the section is about *definitional vs propositional equality*, and this note says proofs of propositional equality are *definitionally* equal. This is a meta-level point that is true but can confuse readers who are still distinguishing the two equality notions.

**IMPACT:** Low — clarification needed.

**FIX:** Add: "This is a separate fact (proof irrelevance for `Prop`), not a consequence of definitional vs propositional equality."

---

### m10. Ch. 6 Section 6: "Why Bundle Proofs With Data?" — Mathlib Equivalent Uses `add_assoc`/`mul_assoc` But Book Uses `assoc`
**WHAT:** `06-groups/06-why-bundle.md:22-23`:
```lean
example (a b c : Int) : (a + b) + c = a + (b + c) := add_assoc a b c
example (f g h : Equiv.Perm (Fin 3)) : (f * g) * h = f * (g * h) := mul_assoc f g h
```

**WHY:** The book's `Group` structure has field `assoc`, while Mathlib's `Group` class inherits `Mul` and has `mul_assoc`. The correspondence is correct. **No error.**

---

### m11. Ch. 3 Section 8: Exercise 2 Hint Suggests `match` But `Or.elim` Is Already Taught
**WHAT:** `03-propositions-and-proofs/08-exercises.md:43-44`: "Prove `theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P` (hint: use `Or.elim` or pattern matching with `match`)."

**WHY:** `match` on `P ∨ Q` is not taught in Ch. 3 (only `Or.elim` is). The hint is slightly ahead of the material. **Minor pedagogical issue.**

---

### m12. Ch. 5 Section 5: Exercise 1 Asks to Predict `rfl` on `n * 2 = n + n`
**WHAT:** `05-rigor-check/05-exercises.md:41-45`: "Predict whether `example (n : Nat) : n * 2 = n + n := rfl` type-checks (hint: which argument does `Nat.mul` recurse on?)"

**WHY:** `Nat.mul` recurses on its *first* argument (`n * 2` = `n + n` by definition of `mul` as repeated addition on the first arg). Actually, in Lean 4, `Nat.mul` is defined by recursion on the *first* argument: `0 * m = 0`, `(n + 1) * m = m + n * m`. So `n * 2` reduces to `n + n` only when `n` is known. For variable `n`, `n * 2` is stuck. `n + n` is not stuck. So `rfl` fails. The hint says "compare with `Nat.add` recursion pattern" — `Nat.add` recurses on *second* argument. This is a good exercise. **No error.**

---

### m13. Ch. 6 Section 7: Exercise 1 `Bool.xor` Group — `inv := fun a => a` Is Correct
**WHAT:** `06-groups/07-exercises.md:39-42`: `boolXorGroup` with `op = Bool.xor`, `id = false`, `inv = fun a => a`.

**WHY:** In `Bool`, `a ⊕ a = false`, so every element is its own inverse. Correct. **No error.**

---

### m14. Ch. 7 Section 5: Exercise 1 `inv_inv` Can Use Theorem 2
**WHAT:** `07-group-theorems/05-exercises.md:38-41`: Hint says "consider whether this matches the shape of a lemma already in hand (Theorem 2 again)."

**WHY:** Theorem 2 (`left_inverse_unique`) says: if `b * a = e` then `b = a⁻¹`. To prove `inv (inv a) = a`, note that `a * inv a = e` (by `inv_right`), so `a` is a left inverse of `inv a`, hence `a = inv (inv a)` by Theorem 2. Correct hint. **No error.**

---

### m15. Ch. 3 Section 1: Table Row "Proof by cases on a disjunction" Maps to `cases` Tactic
**WHAT:** `03-propositions-and-proofs/01-prop.md:36`: "| proof by cases on a disjunction | pattern match / [`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) | `Or.elim`, `cases h with ...` |"

**WHY:** The table mixes term-mode (`Or.elim`) and tactic-mode (`cases`). This is fine but the link goes to the tactic reference for `cases`. **No error.**

---

## Verification Log

| File | Lines Read | Issues Found |
|------|------------|--------------|
| 03-propositions-and-proofs/00-index.md | 75 | M2, M7 |
| 03-propositions-and-proofs/01-prop.md | 127 | M15 |
| 03-propositions-and-proofs/02-logic-recap.md | 308 | m2 |
| 03-propositions-and-proofs/03-theorem-lemma.md | 26 | — |
| 03-propositions-and-proofs/04-implication.md | 25 | — |
| 03-propositions-and-proofs/05-and-or-not.md | 131 | M14, M15 |
| 03-propositions-and-proofs/06-quantifiers.md | 131 | M4, m1 |
| 03-propositions-and-proofs/07-equality.md | 45 | m8 |
| 03-propositions-and-proofs/08-exercises.md | 55 | m11 |
| 05-rigor-check/00-index.md | 78 | M2, M7 |
| 05-rigor-check/01-structure-vs-class.md | 133 | — |
| 05-rigor-check/02-universes.md | 110 | M3, m3 |
| 05-rigor-check/03-typing-rules-and-safety.md | 277 | M10, M11, m4 |
| 05-rigor-check/04-defeq-vs-propeq.md | 172 | m9 |
| 05-rigor-check/05-exercises.md | 70 | m12 |
| 05-rigor-check/06-checkpoint-project.md | 79 | M1 |
| 06-groups/00-index.md | 73 | M2, M7, M8 |
| 06-groups/01-definition.md | 57 | — |
| 06-groups/02-translating.md | 105 | M12 |
| 06-groups/03-integers-example.md | 81 | — |
| 06-groups/04-permutations-example.md | 224 | M5, M9, m5 |
| 06-groups/05-accessing-fields.md | 48 | — |
| 06-groups/06-why-bundle.md | 35 | m10 |
| 06-groups/07-exercises.md | 59 | m13 |
| 07-group-theorems/00-index.md | 67 | M2, M7 |
| 07-group-theorems/01-setup.md | 48 | m6 |
| 07-group-theorems/02-theorem-1.md | 85 | — |
| 07-group-theorems/03-theorem-2.md | 87 | M6 (retracted) |
| 07-group-theorems/04-theorem-3.md | 133 | M13 (retracted), m7 |
| 07-group-theorems/05-exercises.md | 56 | m14 |

**Total files:** 20  
**Total lines:** ~2,850  
**Major concerns:** 8 (M1–M8)  
**Minor concerns:** 15 (m1–m15)

---

## Final Assessment

The slice is **mathematically coherent and pedagogically well-structured** but has **critical regressions from v1.5.0** (version pins missing, "Story"/"Sections" not removed from markdown) and **several concrete Lean 4 errors** (universe calculation, `decide` on non-decidable prop, `rfl` on function composition) that prevent code from compiling. The learning objectives are partially misaligned. Cross-references are mostly sound but the version inconsistency undermines reproducibility.

**Grade: C+** — Pass with required fixes before publication.

---

<<<REPORT_END>>>