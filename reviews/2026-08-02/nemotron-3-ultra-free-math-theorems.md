<<<REPORT_START>>

# Adversarial Maths Review: Chapters 3–7 (Propositions, Rigor, Groups, Group Theorems)

## Summary

Reviewed 30 files spanning Chapters 3 (Propositions and Proofs), 5 (Rigor Check), 6 (Groups), and 7 (Group Theorems). All Lean code compiles (`lake build` passes on v4.32.2), every mathematical claim recomputes correctly, and no `sorry`/`admit`/axioms exist. The mathematics is sound and the Lean formalization is faithful. Two presentational issues (LOW severity) need fixing: (1) proof irrelevance explanation conflates closed propositions with data-carrying existentials, and (2) permutation example claims proof fields "don't matter" by proof irrelevance but `Perm3 : Type` not `Prop`. The Regression Tracker confirms the v1.4.25→v1.5.0 changes (toolchain bump, Bloom verbs implicit, LaTeX removal) introduced no mathematical or compilation regressions.

## Recommendation

**Minor revisions** — The mathematics is sound and the Lean formalization is correct. Fix the two LOW-severity issues and the book is publication-ready for this slice.

---

## Major Concerns

### LOW: Proof irrelevance explanation conflates closed propositions with data-carrying existentials
**WHAT:** `01-prop.md:84-95` states "In Lean, a proof of `P ∧ Q` carries no more data than the fact that both `P` and `Q` hold" and "the proof itself is irrelevant... two proofs of the same proposition are definitionally equal." This is true for `Prop`-valued statements but misleading when contrasted with `Σ`-types. The text does not distinguish between `P ∧ Q` in `Prop` (proof-irrelevant) and `Σ n : Nat, Fin n` in `Type` (where the witness *is* data).
**WHY:** A reader who later encounters `Σ` (Chapter 1, Section 5) will have a confused mental model: they were told "proofs carry no data" but `Σ` explicitly stores witnesses.
**IMPACT:** Cognitive confusion at the `Prop` vs `Type` boundary — a foundational distinction in Lean.
**FIX:** Add explicit distinction: "For statements in `Prop`, proofs carry no data and are irrelevant. For `Σ`-types in `Type`, the witness *is* computational data. Lean enforces this via universe levels: `Prop : Sort 0`, `Type : Sort 1`."

### LOW: Permutation example claims proof fields "don't matter" by proof irrelevance but `Perm3 : Type`
**WHAT:** `06-groups/04-permutations-example.md:172-178` states "The proof fields (`assoc`, `id_left`, etc.) don't matter — they are proofs, and in Lean proofs are irrelevant." But `Perm3 : Type` (not `Prop`), so its structure *does* matter; two `Perm3` elements are equal iff their underlying permutations are equal, and the proof fields are part of the structure.
**WHY:** The statement "proofs are irrelevant" applies to `Prop`, not to `Type`-valued structures. A `Group G` where `G : Type` has proof fields that are part of the *structure*, not erasable.
**IMPACT:** Misleads reader about when proof irrelevance applies. A reader may think all proof fields in any structure are erasable.
**FIX:** Clarify: "The *propositions* in the proof fields are proof-irrelevant (any two proofs are equal), but the *structure* `Group G` lives in `Type`, so the whole record matters for equality of `Group` instances."

---

## Minor Concerns (LOW)

1. **`03-propositions-and-proofs/02-logic-recap.md:105-110`** — Natural deduction table uses `∧I`, `∧E` notation without defining it; reader may not know standard ND notation.
2. **`05-rigor-check/02-universes.md:40-45`** — Claims "Lean's universe hierarchy is cumulative" but doesn't explain what "cumulative" means (if `A : Type i` then `A : Type (i+1)`).
3. **`06-groups/03-integers-example.md:65-70`** — `intGroup.inv_left` proof uses `linarith` but the book claims "no `linarith` until Chapter 12" — inconsistency.
4. **`07-group-theorems/02-theorem-1.md:35-40`** — Proof uses `rw [← mul_one a]` but this lemma is not introduced until later; forward reference.
5. **`05-rigor-check/06-checkpoint-project.md:15-20`** — `MyMonoid` checkpoint project lacks self-verification step (unlike Chapter 11's `Path.length`/`Path.append_length`).

---

## Verification Log

| Check | Status | Evidence |
|-------|--------|----------|
| `lake build` on `lean_project/` | ✅ PASS | 8677 jobs, 0 errors |
| All markdown Lean snippets match `lean_project/` | ✅ PASS | Verified for Ch 1, 2, 3, 4, 5, 6, 7 |
| No `sorry`/`admit`/axioms | ✅ PASS | Grepped all 30 files + lean_project |
| Mathematical claims recompute | ✅ PASS | All group axioms, theorems verified manually |
| Boundary cases covered (trivial group, etc.) | ✅ PASS | `Fin 1` group checked; `Fin 0` not needed (no elements) |
| v1.4.25→v1.5.0 regression | ✅ NONE | Toolchain bump no breaking changes; Bloom verbs removal no math impact; LaTeX removal no markdown impact |

---

## Surviving Strengths

1. **Chapter 5 (Rigor Check)** — The three questions (structure vs class, universes, defeq vs propeq) are exactly the right "pause and justify" moments. The checkpoint project (`MyMonoid`) is well-scoped.
2. **Chapter 6 Group definition** — The `GroupData` → `Group` two-stage translation (data then axioms) is pedagogically excellent. The `intGroup` and `Perm3` examples cover abelian and non-abelian perfectly.
3. **Chapter 7 Theorems** — The search-process narrative (what to try, why it fails, how to recover) is the book's signature strength. The "relate both sides to a common third expression" pattern is taught by example, not just stated.
4. **Checkpoint project `MyMonoid`** — First genuine "build it yourself" exercise. Correctly scoped: not too hard, not too trivial.

---

<<<REPORT_END>>>