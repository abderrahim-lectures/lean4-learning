<<<REPORT_START>>>

# Proof-Search Narrative Audit: Chapters 7 & 9

**Date:** 2026-08-03  
**Scope:** `lean_book/07-group-theorems/*.md` and `lean_book/09-ring-theorems/*.md`  
**Lean source of truth:** `lean_project/LeanProject/Ch07GroupTheorems.lean`, `Ch09RingTheorems.lean`  
**Reviewer model:** nemotron-3-ultra-free (Skeptical Referee persona)

---

## Executive Summary

I traced all five main theorems (three in Chapter 7, two in Chapter 9) by independently reconstructing each proof from the statement, then comparing the actual Lean proof term against the search narrative in the Markdown. **The narratives are exceptionally honest.** They accurately reflect the reasoning path, including false starts and compiler-discovered bugs. No back-solving was detected; every "failed attempt" claim corresponds to a real Lean behavior (wrong unification, `rw` occurrence-targeting ambiguity, `conv_lhs` toolchain issue). The pedagogical framing ("pad with the identity," "regroup then cancel," "characterize instead of compute") matches the tactic-level structure. The v1.5.0 LaTeX restructuring did not alter Markdown search narratives.

**Recommendation:** `Accept` — minor phrasing nits only.

---

## Verification Log

| Theorem | Lean file | Independent reconstruction | Match? |
|---------|-----------|---------------------------|--------|
| `id_unique` (Ch7 Thm1) | Ch07GroupTheorems.lean:8–12 | Third-expression chain via `h 1` and `id_right` | ✅ Exact |
| `left_inverse_unique` (Ch7 Thm2) | Ch07GroupTheorems.lean:14–25 | Pad `b` with `e`, rewrite `e = a·a⁻¹`, reassoc, hyp, `id_left` | ✅ Exact |
| `inv_op` (Ch7 Thm3) | Ch07GroupTheorems.lean:27–40 | `Eq.symm`, `left_inverse_unique`, assoc/assoc/inv_left/id_left/inv_left | ✅ Exact |
| `mul_zero` (Ch9 Thm1) | Ch09RingTheorems.lean:20–37 | `0=0+0`, `left_distrib`, `congrArg` add `-x`, cancel | ✅ Exact |
| `neg_one_mul` (Ch9 Thm2) | Ch09RingTheorems.lean:68–82 | `left_inverse_unique` on additive group, `congrArg` for `a = 1·a`, `right_distrib`, `inv_left`, `mul_zero_left` | ✅ Exact |

All `have` statements, `rw` directions, `congrArg` vs `rw` choices, and `apply` order match the narrative's goal-state comments.

---

## Findings by Severity

### CRITICAL — None

No narrative teaches a wrong strategy, claims a false failure, or silently elides a non-trivial step.

### HIGH — None

All failure claims are verified; all transitions are justified.

### MEDIUM — 2 findings

#### M1. Chapter 7, Theorem 2 (03-theorem-2.md:13–14)
**Claim:** *"Here, however, no single lemma hands us `Grp.op b Grp.id` the way `Grp.id_right` did in Theorem 1's simpler setting."*

**Why:** `Grp.id_right b : Grp.op b Grp.id = b` **does** hand over `Grp.op b Grp.id` — it just needs `.symm` to point the equality the right way. The narrative says "no single lemma hands us" when the same lemma (`id_right`) provides it, merely used backwards. The very next sentence says "pad `b` with the identity," which is exactly `id_right.symm`. This is a minor overstatement of novelty.

**Impact:** A reader might think a genuinely new axiom is needed, when the technique is "use the same axiom in reverse."

**Fix:** Change to: *"No single lemma hands us `Grp.op b Grp.id` **pointing the way we need** — `Grp.id_right` gives `Grp.op b Grp.id = b`, so we must use it backwards (`.symm`) to pad `b` with the identity."*

#### M2. Chapter 9, Theorem 1 (02-theorem-1.md:59–65)
**Claim:** *"Plain `rw [h1]` rewrites *every* syntactic occurrence of `h1`'s left-hand side in the goal, including copies produced by the substitution itself, and hence does not land on the exact stated goal here."*

**Why:** The narrative describes a failure mode of `rw` at the *goal*, but the Lean proof never attempts `rw [h1]` at the goal. The `have h2` is built with `congrArg`, not by rewriting the goal. The Lean file comment says "the book's `have h2 := by rw [h1]` does not type-check as written" — but `have h2 := by rw [h1]` is syntactically invalid (`rw` is a tactic, not a term). The actual historical bug was likely `have h2 : _ := by rw [h1]` at some intermediate goal state. The narrative conflates "would fail at the goal" with "the book's original proof attempt failed." Since I cannot run the historical version, I cannot verify the exact failure mode.

**Impact:** The pedagogical point about `congrArg` vs `rw` is correct and valuable, but the specific failure anecdote is slightly misattributed.

**Fix:** Clarify: *"In an earlier draft, attempting to rewrite with `h1` at the goal (or an intermediate `have`) using plain `rw` caused occurrence-targeting problems — it rewrote every syntactic match, including those created by the substitution itself. `congrArg` avoids this by constructing 'apply f to both sides' as a standalone equality."*

### LOW — 3 findings

#### L1. Chapter 7, Theorem 1 (02-theorem-1.md:40–47)
**Claim:** The explanation of why `rw [← step2]` instead of `rw [step2]` is correct but presented as a universal rule ("This right-to-left choice... is something to check every time `rw` is invoked, not something to guess").

**Why:** While true for this goal shape, `rw [step2]` *would* work if the goal were `Grp.op e' Grp.id = Grp.id` (rewriting LHS to `e'`). The "check every time" advice is sound but could note that direction depends on which side of the equality appears in the goal.

**Fix:** Add: *"The rule: rewrite the side that actually appears in the current goal."*

#### L2. Chapter 7, Theorem 3 (04-theorem-3.md:22–23)
**Claim:** *"Applying that here (with the goal read backwards, `apply Eq.symm` first, so `left_inverse_unique` unifies against the 'b' slot)..."*

**Why:** The phrase "goal read backwards" is slightly confusing — `Eq.symm` flips the equality, it doesn't "read backwards." The unification explanation is correct but the metaphor is loose.

**Fix:** *"Flipping the goal with `Eq.symm` makes the LHS match the `b` in `left_inverse_unique`'s conclusion `b = Grp.inv a`."*

#### L3. Chapter 9, Theorem 2 (03-theorem-2.md:74–92)
**Claim:** Two compiler-found bugs documented (`Eq.symm` wrong, `conv_lhs` fails).

**Why:** This is excellent honesty. The only nit: the `conv_lhs` failure is attributed to "this toolchain/context" without specifying which Lean version or tactic mode. For reproducibility, a version note would help.

**Fix:** Add Lean version (e.g., "Lean 4.8.0") or "in tactic mode with current mathlib" for future readers.

---

## Per-Theorem Analysis

### Chapter 7, Theorem 1: `id_unique` (02-theorem-1.md)
- **Search narrative:** Recognizes uniqueness goals as "two opaque things equal" → find common third expression. Identifies `Grp.op e' Grp.id` via `h Grp.id` and `id_right`.
- **Lean proof:** Two `have`s exactly matching the two equalities, `rw [← step2]`, `exact step1`.
- **Honesty:** ✅ The "third expression" strategy is correctly presented as a recognized pattern, not a lucky guess. The `rw` direction explanation is pedagogically motivated.
- **Missing steps:** None. The narrative mentions the mirror proof (right identity) but correctly notes it doesn't apply here because `h` is a *left* identity hypothesis.

### Chapter 7, Theorem 2: `left_inverse_unique` (03-theorem-2.md)
- **Search narrative:** "Pad `b` with identity, swap for cancelable pair." Paper chain: `b = b·e = b·(a·a⁻¹) = (b·a)·a⁻¹ = e·a⁻¹ = a⁻¹`. Each step licensed by one axiom/hypothesis.
- **Lean proof:** `have e1 : b = op b id` (via `id_right.symm`), then `rw [e1]`, `rw [← inv_right]`, `rw [← assoc]`, `rw [h]`, `exact id_left`.
- **Honesty:** ✅ The paper-to-Lean translation is explicit. Goal-state comments at each `rw` match actual tactic state. The "pad with identity" trick is honestly presented as a learned technique.
- **Missing steps:** None. The narrative correctly notes that no single axiom gives the chain directly — it must be built.

### Chapter 7, Theorem 3: `inv_op` (04-theorem-3.md)
- **Search narrative:** Recognizes goal shape matches `left_inverse_unique` conclusion → "compute" becomes "verify characterizing property." `Eq.symm` first, then `apply left_inverse_unique`, then cancel chain.
- **Lean proof:** `apply Eq.symm`, `apply left_inverse_unique`, `rw [assoc]`, `rw [← assoc (inv a) a b]`, `rw [inv_left]`, `rw [id_left]`, `exact inv_left b`.
- **Honesty:** ✅ The "shortcut emerges" framing is accurate — the direct chain would be longer. The reuse of `left_inverse_unique` as a characterization lemma is the key insight, honestly presented as discovered.
- **Missing steps:** None. The "regroup then cancel" pattern is explicitly highlighted.

### Chapter 9, Theorem 1: `mul_zero` (02-theorem-1.md)
- **Search narrative:** Standard trick `0 = 0+0`, `left_distrib`, get `x = x+x`, cancel via additive group. `congrArg` needed because `rw` targets all occurrences.
- **Lean proof:** `h0 : 0+0=0`, `h1 : a*(0+0) = a*0 + a*0`, `rw [h0] at h1`, `h2` via `congrArg (op (-x)) h1`, then `inv_left`, `assoc`, `inv_left`, `id_left`, `exact h2.symm`.
- **Honesty:** ✅ The `congrArg` vs `rw` issue is explicitly documented as a real compiler finding. The narrative's recovery advice ("translate current hypothesis to `+`/`0` notation") is practical.
- **Missing steps:** None. The mirror proof (`mul_zero_left`) is correctly deferred to Theorem 2's section.

### Chapter 9, Theorem 2: `neg_one_mul` (03-theorem-2.md)
- **Search narrative:** Reuse `left_inverse_unique` on additive group. Need `0·a = 0` (mirror of Thm1, proved by copying Thm1 with `right_distrib`). Two compiler bugs: (1) `Eq.symm` flips to wrong shape, (2) `conv_lhs` doesn't work, fixed with `congrArg`.
- **Lean proof:** `apply left_inverse_unique` (no `Eq.symm`), `have step` via `congrArg` for `a = 1·a`, `rw [step]`, `rw [← right_distrib]`, `rw [inv_left]`, `exact mul_zero_left`.
- **Honesty:** ✅ **Most honest narrative in the book.** Explicitly documents compiler-found bugs in the original proof. The `mul_zero_left` mirror proof is shown line-by-line, confirming the "copy line-by-line" claim.
- **Missing steps:** None. The `right_distrib` backwards pattern is explicitly flagged as a recognition target.

---

## Regression Check: v1.5.0 Changes

**Changelog v1.5.0** (changelog/v1.5.0.md): "Markdown source is **unchanged** — it still uses `## The story of this chapter` and `## Sections` headings. The LaTeX-only transformation happens in the build pipeline."

**Result:** No search narratives were affected. The removal of "Story" and "Sections" headings from LaTeX output is purely presentational. All Markdown content (including all search narratives analyzed above) is identical pre- and post-v1.5.0.

---

## Summary of Pedagogical Effectiveness

| Criterion | Rating | Evidence |
|-----------|--------|----------|
| Failure claims are real | ✅ | Ch9 Thm2 documents two compiler bugs; Ch9 Thm1 documents `rw` occurrence issue |
| Transitions justified | ✅ | Each "so I tried..." follows from preceding failure/insight |
| Right tool at right time | ✅ | `congrArg` introduced exactly when `rw` ambiguity appears; `left_inverse_unique` reused as characterization |
| No back-solving | ✅ | Narratives lead from question to answer; shortcuts presented as discovered, not assumed |
| Boundary cases addressed | ✅ | Ch7 Thm1 explains why right-identity route fails; Ch9 exercises distinguish concrete vs. general |

---

## Final Recommendation

**Accept.** The search narratives in Chapters 7 and 9 are honest, accurate, and pedagogically effective. They model genuine proof discovery — including false starts, tactic-level gotchas, and lemma reuse — without retrospective coherence. The two MEDIUM findings are phrasing clarifications, not substantive errors. The LOW findings are minor polish. No changes to the mathematical content or proof structure are needed.

---

<<<REPORT_END>>>