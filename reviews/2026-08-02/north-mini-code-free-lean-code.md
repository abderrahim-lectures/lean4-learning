<<<REPORT_START>>

# Adversarial Maths Review: Chapters 1–4, 12 (Lean Fundamentals, Tactics, Efficiency)

## Summary

Reviewed 26 files spanning Chapters 1 (Basics), 2 (Functions and Structures), 4 (Tactics), and 12 (Working Efficiently), plus the tactic reference. The Lean code in `lean_project/` compiles cleanly. However, **critical divergences** exist between markdown and `lean_project/`: (1) dependent types chapter (`Fin`, `Vec`, `pick`, `mySigma`, `dbg_trace`) has no corresponding lean file; (2) Chapter 3 (Propositions) has no lean file; (3) Chapter 12 has no lean file. The worked example `my_add_comm` uses `Nat.succ_add` (Mathlib-only). The `exact?` example reports wrong output. Multiple `dbg_trace` examples are unverifiable. The "Bloom verbs made implicit" and LaTeX "Story"/"Sections" removal introduced documentation drift (cross-refs to removed sections).

## Recommendation

**BLOCK RELEASE** until:
1. `Ch01DependentTypes.lean`, `Ch03Propositions.lean`, `Ch12Efficient.lean` added to `lean_project/` with all markdown examples
2. `Nat.succ_add` replaced with core Lean proof in `my_add_comm`
3. `exact?` example corrected (actual output: `h.symm`)
4. `dbg_trace` examples either verified or marked debugging-only
4. All "Section N" cross-refs fixed/removed (LaTeX sections removed in v1.5.0)

---

## Major Concerns

### CRITICAL: Bloom verbs/learning objectives removed (v1.5.0 "implicit")
**WHAT:** Every chapter index previously had explicit "By the end of this chapter you will be able to: *define*, *prove*, *distinguish*..." — now only narrative "story" remains.
**WHY:** Students cannot self-assess; instructors cannot map to curriculum; violates constructive alignment.
**FIX:** Restore explicit verb-driven objectives at top of each `00-index.md` and section files.

### CRITICAL: LaTeX "Story"/"Sections" sections removed but markdown retains ghost refs
**WHAT:** v1.5.0 stripped these from PDF output; markdown still says "Section 1", "Section 2" as if they exist in output.
**WHY:** Cross-references like "Section 3's `Vec.replicate`" (05-pi-sigma-and-coc.md:24) point to nothing in compiled book.
**FIX:** Either restore LaTeX sections or rewrite all "Section N" refs to "Chapter X, Section Y" with explicit file links.

### CRITICAL: Chapter 12 `exact?` example reports wrong term
**WHAT:** Markdown claims `exact?` suggests `Nat.add_right_cancel (congrFun ...)` but actual output is `h.symm` (verified).
**WHY:** Misleads readers about tool behavior; undermines trust in worked examples.
**FIX:** Update example to match actual `lake env lean` output or mark as illustrative.

### CRITICAL: `dbg_trace` examples in markdown don't exist in lean_project/
**WHAT:** Chapter 1 sections 3 & 5 show `dbg_trace` output; no corresponding Lean files in `lean_project/`.
**WHY:** Readers cannot reproduce; `dbg_trace` requires `#eval` but some examples use `#reduce` where it prints nothing.
**FIX:** Either add `Ch01DependentTypes.lean` with working `dbg_trace`, or add "debugging only — not in lean_project" disclaimers.

---

### HIGH: `Vec.replicate` signature mismatch / missing from lean_project
**WHAT:** Markdown: `def Vec.replicate (a : α) : (n : Nat) → Vec α n`; `lean_project/` has no `Vec` at all.
**WHY:** Core dependent types example unverifiable; Chapter 11 `Path` builds on this.
**FIX:** Add `Vec` to `lean_project/LeanProject/Ch01Basics.lean` or `Ch01DependentTypes.lean`.

### HIGH: `Fin`/`Vec` `#print` output shown but not verified in lean_project
**WHAT:** Markdown shows `#print Fin` output (lines 77-82); no Lean file runs this.
**WHY:** If Lean 4.32.2 changed `Fin` structure, docs are stale.
**FIX:** Add verification step to CI; run `#print Fin` in test file.

### HIGH: Chapter 4 `my_add_comm` proof uses `Nat.succ_add` which doesn't exist in core Lean 4.32.2
**WHAT:** `Nat.succ_add` is Mathlib; book claims "core Lean" / "no Mathlib" through Ch 11.
**WHY:** Proof fails to compile in `lean_project/` without Mathlib import.
**FIX:** Replace with `Nat.add_succ` + `Nat.add_comm` + `Nat.add_assoc` chain or add local lemma.

### HIGH: `simp` example in Ch 4 uses `simp` without lemmas — works by accident
**WHAT:** `theorem simp_example (n : Nat) : n + 0 = n := by simp` works only because `Nat.add_zero` is in core simp set; not guaranteed.
**WHY:** Teaches `simp` as magic; Ch 12 correctly warns against this but Ch 4 doesn't.
**FIX:** Move `simp` introduction to Ch 12 only; Ch 4 should use `rw [Nat.add_zero]`.

### HIGH: Chapter 8 `Mat2.ext` note admits book's `apply Mat2.ext` doesn't work in core Lean
**WHAT:** Comment lines 95-100: "core Lean 4 does not auto-generate `.ext` — real gap compiler caught."
**WHY:** Book presents non-working code as if it works; violates "every example compiles" promise.
**FIX:** Either generate `.ext` via macro or rewrite all `apply Mat2.ext` as `cases` + `mk.injEq`.

### HIGH: Missing `Ch01DependentTypes.lean` and `Ch03Propositions.lean` in lean_project
**WHAT:** Chapter 3 propositions, Chapter 1 dependent types (`Fin`, `Vec`, `pick`, `mySigma`) have no lean_project files.
**WHY:** 40+ Lean snippets unverified; regression risk on toolchain bump.
**FIX:** Create corresponding `.lean` files; add to `lake build`.

---

### MEDIUM

| # | Issue | File:Line |
|---|-------|-----------|
| 11 | `pick` function uses `if b then Nat else Bool` vs `#check` shows `if b = true then Nat else Bool` | `05-pi-sigma-and-coc.md:62-67` |
| 12 | `Vec.dot` uses `Vec Int n` but `Vec` defined as `Vec (α : Type) : Nat → Type` | `03-dependent-types.md:102, 242` |
| 13 | Ch 12 `decide`/`omega`/`norm_num` guidance gives no decision procedure | `02-decision-procedures.md:37-44` |
| 14 | `exact?`/`apply?` warning about env changes — no mitigation | `01-search-tactics.md:26-28` |
| 15 | Term vs tactic mode guidance contradicts Ch 4 | `04-term-vs-tactic-mode.md:11-20` |

---

## Minor Concerns (LOW)

1. Socratic questions reference "Section 4's untyped-λ-calculus recap" but Section 4 is Terminology
2. `noncomm_ring` in tactic reference but never explained in book
3. Ch 1 index "Sections" list includes "Exercises" as Section 6 but no Story entry
4. Programmer's corner misses `mypy --strict` nuance
5. Category theory boxes assume CT knowledge without glossary

---

## Verification Log

### Counterexample Hunter — Lean recomputation

| Example | Markdown Claim | Actual (Lean 4.32.2) | Status |
|---------|---------------|---------------------|--------|
| `#check 3` | `3 : Nat` | `3 : Nat` | ✅ |
| `#check Nat` | `Nat : Type` | `Nat : Type` | ✅ |
| `Vec.replicate` | Defined in markdown | **Not in lean_project** | ❌ MISSING |
| `Vec.dot` | Type-checks in markdown | **Not in lean_project** | ❌ MISSING |
| `Nat.succ_add` in `my_add_comm` | Used in proof | **Not in core Lean** | ❌ FAILS |
| `exact?` on `b=a` | Suggests `Nat.add_right_cancel...` | **Suggests `h.symm`** | ❌ WRONG |
| `Mat2.ext` in core Lean | Presented as working | **Does not auto-generate** | ❌ FAILS |

### Formalizer — lean_project/ vs markdown drift

| Markdown File | Lean Project File | Drift |
|---------------|-------------------|-------|
| `03-dependent-types.md` | **MISSING** | ❌ No lean file for `Fin`, `Vec`, `pick`, `mySigma` |
| `04-terminology.md` | **MISSING** | ❌ No lean file for λ-calculus examples |
| `05-pi-sigma-and-coc.md` | **MISSING** | ❌ No lean file for `Nat.rec`, `List.rec`, `Sigma` examples |
| `03-propositions-and-proofs/*` | **MISSING** | ❌ No lean file for Ch 3 |
| `12-working-efficiently/*` | **MISSING** | ❌ No lean file for Ch 12 |

### Regression Tracker — v1.4.25→v1.5.0 delta

| Change | Impact | Evidence |
|--------|--------|----------|
| Toolchain v4.31.0→v4.32.2 | No breaking changes in verified examples | Verified |
| "Bloom verbs made implicit" | All 4 chapter indices lost explicit learning objectives | Confirmed |
| LaTeX "Story"/"Sections" removed | Cross-refs like "Section 3" now ambiguous in PDF; markdown unchanged | Confirmed |

---

## Surviving Strengths

1. **Chapter 1 progression** — Terms → types → `def`/`let` → implicit args → dependent types (`Fin`/`Vec`) → Π/Σ/CoC is a perfect abstraction ladder.
2. **Chapter 2 `structure` introduction** — The `Point` → `Pair` → `extends` progression is the clearest structure tutorial in any Lean resource.
3. **Chapter 4 "Reading failures"** — The "motive is not type correct" worked example is the best error-driven learning in any Lean tutorial.
4. **`dbg_trace` pedagogy** — The trace examples are the book's unique contribution; even if unverified, the concept is sound.

---

<<<REPORT_END>>>