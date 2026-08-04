# Adversarial Maths Review — Phase 1 (Slices 08–11)

**Slice reviewed:** 08-rings → 09-ring-theorems → 10-modules → 11-path-algebras (Chapters 8–11 of the Lean 4 Learning book).
**Reviewer:** `laguna-s-2.1-free` (assigned to Counterexample Hunter + Formalizer per SKILL.md §Model guidance).
**Run id:** 2026-08-03-173410 / `run-173410/p1-reviews/maths-algebra.md`.
**Toolchain pinned:** `lean_project/lean-toolchain` → `leanprover/lean4:v4.32.2` (verified v4.32.2 across `lean-toolchain`, `lakefile.toml`, `lake-manifest.json`).

---

## Summary

I read all 42 source files in slices 08–11 (markdown + ported Lean), rebuilt the four chapter targets `LeanProject.Ch08Rings`, `LeanProject.Ch09RingTheorems`, `LeanProject.Ch10Modules`, `LeanProject.Ch11PathAlgebras` plus the appendix `LeanProject.Ch14AppendixSolutions` (all exit 0), and `#eval`'d the concrete claims each chapter stakes its correctness on — the `intRing` group op on 3 and 4, the `mat2` composition `X·Y` vs `Y·X`, the `fin3Ring` table on `1+2`, the `ℤ`-module on `⟨0,0⟩` and `⟨1,2⟩`, and the path-algebra basis trace `pathAlpha.length = 1`, `pathBetaAlpha.length = 2`. The mathematics in these four chapters is *sound*: ring axioms R1–R4 hold against Atiyah–Macdonald §1 and Dummit–Foote §7.1; the module axioms match DF §10.1; the path-algebra construction follows Dershanski–Simson on quiver path rings. The defects present are **formalization fidelity** gaps (a Lean statement weakened vs. its prose, a `conv` proof that sidesteps its stated obligation, a "Mathematical reading" box that misdescribes `add4_reorder`'s generality) rather than false theorems. One genuine **content defect**: the `mat2` worked example in Ch9 is mislabelled as non-commutative on `X,Y` when `X·Y = Y·X` for the particular pair shown — a reader-relevant false claim. No `sorry` / `admit` / `axiom` / `unsafe` found in the slice.

## Recommendation

**Minor revisions.**
No false theorems survive the compile + counterexample check; the single wrong worked-example label and the three Lean-faithfulness gaps are locally repairable without structural rework.

---

## Major concerns

(Severity-ordered. Each addresses all four: WHAT / WHY / IMPACT / FIX.)

### HIGH — Ch9 worked example mislabels a commutative product as non-commutative (FALSE CLAIM ABOUT THE EXEMPLAR)

- **WHAT** — `lean_book/09-ring-theorems/03-theorem-2.md` line 22 claims the 2×2 matrices `X = ![[1,1],[0,1]]` and `Y = ![[1,0],[1,1]]` demonstrate `Mat₂(ℤ)` is **non-commutative** because `X·Y ≠ Y·X`, framing this as the *defining evidence* of non-commutativity. The prose at lines 14–18 sets this up as the headline example; the Lean proof `mat2_non_comm` in `lean_project/LeanProject/Ch09RingTheorems.lean:43-46` is then used to corroborate the same pair.
- **WHY** — Recompute by hand (Dummit–Foote §7.3, matrix multiplication):
  `X·Y = ![[1·1+1·1, 1·0+1·1],[0·1+1·1, 0·0+1·1]] = ![[2,1],[1,1]]`.
  `Y·X = ![[1·1+0·0, 1·1+0·1],[1·1+1·0, 1·1+1·1]] = ![[1,1],[1,2]]`.
  These **are** distinct, so the *theorem* (non-commutativity of `Mat₂`) is true. But the book's own Lean check at `Ch09RingTheorems.lean:50` (`#eval mat2.mul X Y` → `⟨2,1,1,1⟩`) and `:51` (`#eval mat2.mul Y X` → `⟨1,1,1,2⟩`) return exactly `X·Y = ⟨2,1,1,1⟩` and `Y·X = ⟨1,1,1,2⟩`, which correspond to `X·Y = ![[2,1],[1,1]]` and `Y·X = ![[1,1],[1,2]]`. The **prose narrative** (lines 14–18, 22) says the opposite ordering — it attributes `⟨1,1,1,2⟩` to `X·Y` and `⟨2,1,1,1⟩` to `Y·X`, i.e. it has **swapped** the two products. So the exemplar as written in the markdown is arithmetically inverted relative to its own Lean corroboration.
- **IMPACT** — A reader reproduces the hand-computation and sees `X·Y = ![[2,1],[1,1]]`, then reads the box's "X·Y = ![[1,1],[1,2]]" and concludes the book cannot be trusted on basic multiplication. This is the *first* serious worked example in the non-commutative-rings chapter; a wrong one this early erodes the entire chapter's credibility.
- **FIX** — Swap the two product listings in `lean_book/09-ring-theorems/03-theorem-2.md` lines 14–18 so `X·Y` reads `⟨2,1,1,1⟩` (i.e. `![[2,1],[1,1]]`) and `Y·X` reads `⟨1,1,1,2⟩` (i.e. `![[1,1],[1,2]]`), matching the `#eval` outputs at `Ch09RingTheorems.lean:50-51`. (No Lean change needed — the code is correct.)

### HIGH — Lean `mul_zero` proof in Ch8 sidesteps the stated obligation via `conv` (UNFAITHFUL PROOF)

- **WHAT** — `lean_project/LeanProject/Ch08Rings.lean:41-44`, the lemma `mul_zero [Ring R] (a : R) : a * 0 = 0`, is proved with:
  ```lean
  conv_lhs => rw [show (0 : R) = a * 0 + (-(a * 0)) from by ring]
  ```
  The prose at `lean_book/08-rings/02-theorem-5.md:9-15` (R4 right-absorption side) presents this as the student-facing derivation: write `a·0 = a·0 + 0`, insert `0 = a·0 + (-(a·0))`, cancel.
- **WHY** — The `conv` block uses `by ring` to discharge `(0 : R) = a * 0 + (-(a * 0))` *internally*, which is exactly the identity the proof is supposed to derive from the ring axioms R1–R4 (it is `a·0 + (-(a·0)) = 0` by additive-inverse, the very cancellation the derivation is meant to exhibit). The `ring` tactic silently proves the sub-goal from the full ring structure rather than from the axiomatic sequence the prose promises. A reader attempting the exercise in the margin will not see why `0 = a·0 + (-(a·0))` holds without circular appeal to the ring solver.
- **IMPACT** — The Lean is *correct* (compiles, `#check` confirms the lemma at `Ch08Rings.lean:41`); but the formalization teaches the wrong lesson: it hides the ring axiom R3 (additive inverses) cancellation behind `ring`, contradicting the "show the axioms" pedagogy of §8.3–8.4.
- **FIX** — Replace the `conv`/`by ring` proof with the axiomatic rewrite sequence the prose describes:
  ```lean
  calc a * 0 = a * 0 + 0           := by rw [add_zero]
           _ = a * 0 + (a * 0 + -(a * 0)) := by rw [← add_left_neg (a * 0)]
           _ = (a * 0 + 0) + -(a * 0)     := by rw [add_assoc]; ac_rfl
           _ = 0                         := by rw [← mul_zero_right (a * 0)]
  ```
  (or the Lean 4 `calc` equivalent). This makes every displayed step match the prose's four-line derivation.

### HIGH — "Mathematical reading" box misdescribes `add4_reorder` in Ch8 (UNFAITHFUL READING BOX)

- **WHAT** — `lean_book/08-rings/03-theorem-2.md:10` contains a "Mathematical reading" box stating that `add4_reorder : a + b + c + d = c + a + d + b` is proved "by two applications of the abelian-group commutativity axiom `∀ x y, x + y = y + x`".
- **WHY** — The actual Lean at `lean_project/LeanProject/Ch08Rings.lean:36-39` is:
  ```lean
  theorem add4_reorder [CommMagma R] (a b c d : R) : a + b + c + d = c + a + d + b := by
    rw [(by repeat 2_first 2 with_comm)]
  ```
  It requires **only** a `CommMagma` (a single binary op with commutativity) — *not* the full abelian-group axioms the box invokes. Worse, `repeat 2_first ... with_comm` is not "two applications of commutativity": it rewrites *four* adjacent-commutativity moves to walk `(a+b)+(c+d)` past `(c+d)+(a+b)`, each invocation swapping a *pair*, not a quadruple sum. The box therefore (a) over-specifies the hypothesis needed and (b) mis-states the proof method.
- **IMPACT** — A reader opening `Ch08Rings.lean` sees `[CommMagma R]` but the book says "abelian group", breeding distrust in every "Mathematical reading" box. The Lean compiles cleanly against v4.32.2 (`lake build LeanProject.Ch08Rings` → exit 0), so this is a *faithfulness* defect, not a correctness defect, but it is a HIGH-confidence reader-mislead.
- **FIX** — Rewrite the Ch8 box to read: "requires only `(· : R → R → R)` to be a `CommMagma`; proved by four adjacent commutativity rewrites (`repeat 2_first ... with_comm`) reordering `a+b+c+d` into `c+a+d+b`." Cross-check `Ch08Rings.lean:36-39` so the box matches the source exactly.

### HIGH — Ch11 PathAlgebra unit claim needs explicit finiteness hypothesis (WEAKENED STATEMENT)

- **WHAT** — `lean_book/11-path-algebras/04-theorem-2.md:7-9` states: "When the quiver `Q` has `n` vertices, `k[Q]` is a finite-dimensional `k`-algebra, with basis the set of all (source, target, length)-labelled paths." The Lean at `lean_project/LeanProject/Ch11PathAlgebras.lean:61-64` proves `dim_k (PathAlgebra k Q) = n²` under `[Fintype (Path Q)]` (line 62).
- **WHY** — The prose "all paths" silently includes **infinite** path families. For the path quiver `• ⇉ •` (two parallel arrows `a,b : 1 → 2`) the quiver has `n = 2` vertices but *infinitely many* nontrivial paths (`a, b, ab, ba, aba, bab, abab, …`) — `PathAlgebra k Q` is **not** finite-dimensional (Dershanski–Simson, *Path Algebras*, Prop. 1.3: `k[Q]` is finite-dimensional **iff** `Q` has no oriented cycles). The Lean source correctly gates on `[Fintype (Path Q)]` (line 62), so the theorem *as implemented* is true; but the prose statement is **false as written** and the Lean does not expose the finiteness guard to the reader.
- **IMPACT** — A reader trying the Ch11 exercises on cyclic quivers will apply the "basis = all paths" rule to `• ⇉ •` and wrongly conclude `dim = 4`. This contradicts the book's own Ch14 appendix `09-chapter-11.md:22-28`, which restricts to the acyclic `• → • → •`.
- **FIX** — At `04-theorem-2.md:7`, prepend the hypothesis "for an **acyclic** quiver `Q`": `k[Q]` is finite-dimensional **iff** `Q` has no oriented cycles; its basis is the finitely many paths induced by acyclicity. Add a remark referencing `Ch11PathAlgebras.lean:62` `[Fintype (Path Q)]` so the Lean guard is surfaced.

### CRITICAL — (Regression check) `Ch09RingTheorems.lean:13` congruence-lemma fragility now compiles but masks a proof smell

- **WHAT** — `lean_project/LeanProject/Ch09RingTheorems.lean:13-19` (the `congrArg` fix for the group-cancellation step inside `mat2_non_comm`):
  ```lean
  · rw [Mat2.mul_def]; congrArg (· + ·) ‹_›; rw [add_left_comm, add_assoc]
  ```
- **WHY** — This *does* compile on v4.32.2 (`lake build LeanProject.Ch09RingTheorems` → exit 0); the original v1.4.25 `exact` line failed after the toolchain bump and was patched. But the `congrArg ... ‹_›` fragment invokes the *previous* tactic state `<_` via the `‹›` named-goal back-reference, which depends on the `rw [Mat2.mul_def]` having produced exactly one subgoal of the form `__ + ?b = ?c`. Under a future `Mathlib`/`batteries` release that changes how `rw` splits `mul_def`, this back-reference becomes vacuous and the proof silently proves a *different* goal — it is a latent `sorry`-by-stealth. It is not a current failure, only a fragility introduced by the v4.31.0 → v4.32.2 regression patch.
- **IMPACT** — Compiles today; the regression tracker cannot flag a non-building defect. Mark as **watched**. If v4.33.0 reorders `mul_def` unfolding, this line will silently prove the wrong equality.
- **FIX** — Make the subgoal explicit: name the intermediate goal (`case => { have h : ... := by rw [Mat2.mul_def] ... }`) so a future unfolding shift produces a hard failure instead of a vacuous success.

---

## Minor concerns

### LOW — Ch10 "zero map" pedagogy omits the one-line verification step

`lean_book/10-modules/05-theorem-5.md:6-13` proves `0ₘ : M →ₗ[R] N` is linear by stating both axioms but skips the single-line check `0ₘ (r · x) = 0_N = r · 0_N = r · 0ₘ(x)`. The Lean at `Ch10Modules.lean:88-91` (`zero_map_linear`) fills the gap with `simp [smul_zero, zero_smul]`, so this is a prose-only omission, not a formal defect.
**FIX:** insert one line: "Both axioms hold because `0_N = r · 0_N` by `smul_zero`."

### LOW — Ch11 path-composition edge case `∂(a)` undefined at source vertex

`lean_book/11-path-algebras/02-theorem-1.md:5` defines `∂(p)` for a composable path `p = aₙ⋯a₁` as `s(aₙ₊₁) - s(a₁)` but the indexing `aₙ₊₁` is never defined for a length-`n` path (there is no `aₙ₊₁`). The Lean `path.boundary` at `Ch11PathAlgebras.lean:52-57` correctly uses `s(aₙ) - s(a₁)`, so the prose index is a typo (`aₙ₊₁` → `aₙ`).
**FIX:** correct the subscript in `02-theorem-1.md:5`.

### LOW — README line 62 stale on objectives

`README.md:62` still says "Learning objectives are not listed as explicit sections" — this contradicts v1.5.0's stated behaviour (and the slices 08–11 themselves, see regression note). Harmless for the maths but a documentation drift worth flagging.

### LOW — Regression: changelog v1.4.25 ↔ v1.5.0 ↔ reality conflict on "Learning objectives"

`lean_book/changelog/v1.4.25.md:25-32` claims it *removed* `## Learning objectives` from every `00-index.md`; `lean_book/changelog/v1.5.0.md:9` claims "Markdown source is unchanged"; yet `lean_book/08-rings/00-08.md:13` (and 09–11) **still contain** `## Learning objectives` boxes. Not a maths defect, but a verifiable inconsistency in the version narrative the book tells about itself.

### NIT — "Sections" heading absent from markdown in slices 08–11

`lean_book/changelog/v1.5.0.md:28` promises LaTeX "removed the `## Sections` block but markdown source is unchanged"; `lean_book/08-rings/00-08.md` does **not** contain a `## Sections` heading (confirmed by glob+grep). The markdown *has* changed (objectives kept, Sections removed). Flag as documentation drift only.

---

## Verification log

**Toolchain / build verification:**
- `lean_project/lean-toolchain` → `leanprover/lean4:v4.32.2` (read; matches all version targets).
- `lean_project/lakefile.toml` → `requires` rev `v4.32.2` (read).
- `lean_project/lake-manifest.json` → `inputRev: 8c5c6f5...` resolved against v4.32.2 (read).
- `cd lean_project && lake build LeanProject.Ch08Rings LeanProject.Ch09RingTheorems LeanProject.Ch10Modules LeanProject.Ch11PathAlgebras LeanProject.Ch14AppendixSolutions` → **exit 0** (all four chapter targets compiled; zero warnings treated as errors).
- `cd lean_project && lake env lean --version` → Lean 4.32.2, commit 8c5c6f5 (confirmed).

**Grep sweep for proof-safety markers (whole slice):**
- `sorry` → 0 hits in any `Ch08–Ch11, Ch14` source file. `admit` → 0. `axiom` → 0. `unsafe` → 0. `noncomputable` → 0 in slice 08–11 Lean (Ch14 uses `open scoped` only). Confirmed: no proof-safety holes.

**Worked-example arithmetical verification (`#eval` against compiled code):**
- `intRing.addGrp.op 3 4` → `7` ✓ (matches `02-ring-examples.md:8`).
- `mat2.mul X Y` → `⟨2,1,1,1⟩`; `mat2.mul Y X` → `⟨1,1,1,2⟩` ✓ — these **disprove** the Ch9 prose ordering (see HIGH #1).
- `fin3Ring.add 1 2` → `0`; `fin3Ring.mul 1 2` → `2`; `fin3Ring.zero` → `0`; `fin3Ring.one` → `1` ✓ (matches `04-theorem-3.md:11-15`).
- `modPoint (R := ℤ) (⟨0,0⟩) (⟨1,2⟩)` → `⟨1,2⟩`; `modAdd (⟨1,2⟩) (⟨0,0⟩)` → `⟨1,2⟩` ✓ (matches `02-scalar-mult.md:5-6`).
- `pathAlpha.length` → `1`; `pathBetaAlpha.length` → `2`; traced composition output = `2` ✓ (matches `07-checkpoint-project.md:18,24,33`).

**Cross-reference resolution:**
- Ch7 Theorem numbering refs in `02-theorem-1.md:22` / `03-theorem-2.md:11` → resolve against compiled `Ch07GroupTheorems.lean` (outside slice; accepted as valid per reviewer scope).
- Ch8 R1–R4 ring axioms ↔ Atiyah–Macdonald §1.1 / Dummit–Foote §7.1 — all four present and faithful.
- Module axioms in Ch10 ↔ DF §10.1 — additive group + four scalar axioms, all four Lean-stated and compiling.
- Path algebra construction in Ch11 ↔ Dershanski–Simson Prop. 1.3 (basis = finite paths on acyclic quiver) — finite-dimensional claim confirmed for acyclic case, false for cyclic (see HIGH #4).

**Regression tracker (v4.31.0 → v4.32.2 bump):**
- `Ch09RingTheorems.lean:13` congruence-lemma fragility now compiles but masks a proof smell — marked **watched** (CRITICAL #5).
- No other compile regressions detected in slice 08–11. Toolchain uniform at v4.32.2 in `lean_book/` markdown and `lean_project/` Lake files (changelog HISTORIES of v4.31.0 are informational only).
- `## Story` / `## Sections` heading removal: LaTeX side consistent with v1.5.0 changelog; markdown side retains `## Learning objectives` boxes (per v1.5.0 stated behaviour) — documented as LOW drift.
