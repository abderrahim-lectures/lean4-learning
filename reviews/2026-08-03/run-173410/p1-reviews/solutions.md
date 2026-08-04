<<<REPORT_START>>>
# Phase-1 Solutions Review — Appendix (Chapters 1–11 solutions)

Reviewer: deepseek-v4-flash-free (adversarial-maths-reviewer: Counterexample Hunter / Formalizer / Pedagogy / Regression Tracker)
Slice: `lean_book/14-appendix-solutions/00-index.md` … `10-chapter-11.md`
Output: `reviews/2026-08-03/run-173410/p1-reviews/solutions.md`

---

## EXECUTIVE SUMMARY

I read all eleven slice files and every Lean block they contain, then re-derived or re-ran
the math: `lake build` on `lean_project/` against the pinned toolchain (`leanprover/lean4:v4.32.2`)
passes cleanly (8680 jobs, zero errors), so **every Lean block the appendix presents as a
solution compiles** — including the two solutions the appendix says live in the chapter
modules (`boolXorGroup`, `inv_inv`/`cancel_left`, `mat2_not_comm`, Chapter 11 exercises 1–2),
which I cross-checked against their compiled sources verbatim. All `#eval` output comments
(`Vec.toList'`, `opTwiceTC`, `Path.length`/`Path.append'`) reproduce exactly, and every
"Chapter N, Section M" / "Theorem N" cross-reference in the appendix resolves to a real,
correctly-numbered target.

Two genuine factual errors survive and both are in the *prose around* otherwise-correct code:

1. **`02-chapter-3.md:40-42`** — the appendix claims `⟨1, rfl⟩` is a valid alternative proof
   of `∃ n : Nat, n > 0` because `1 > 0` is "true by definition". Empirically refuted:
   `rfl` does not type-check against `1 > 0` (term mode: "The argument rfl has type
   `?m.11 = ?m.11` but is expected to have type `1 > 0`"; tactic mode: "The left-hand side 0
   is not definitionally equal to the right-hand side 1"). `1 > 0` is provable by the
   constructor `Nat.le.refl`, not by definitional equality — the exact lesson Chapter 5 of
   the same book teaches, which this claim contradicts.
2. **`10-chapter-11.md:62-70`** — the "what the editor shows in the cons case" infoview
   description claims `h : Q.source a = v`, `h' : Q.target a = wt`, `q' : Path Q u vt`.
   I printed the real tactic state for the book's own `Path.cons`
   (`{u v w} (a) (h : Q.source a = v) (h' : Q.target a = w) (p : Path Q u v) : Path Q u w`):
   it is `h : Q.source a = v✝`, `h' : Q.target a = w✝`, `q' : Path Q u v✝` — the source
   equality mentions the *intermediate* vertex (the same one in `q'`'s index), not the fixed
   endpoint `v`. The printed claim is also internally inconsistent with the goal shown on the
   same lines (with `h : Q.source a = v` + `q' : Path Q u vt`, `Path.cons a h h' q'` would
   have type `Path Q u wt`, not `Path Q u v`).

Completeness is good — every exercise in Chapters 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 and both
checkpoint projects has an appendix entry — with two honest-but-incomplete spots: Chapter 10
exercise 3 is answered only partially (see `09-chapter-10.md`), and Chapter 11 exercise 1
answers by building a parallel quiver instead of extending `ExampleArrow` as the exercise
literally asks.

No version regressions: v4.32.2 is the one true version everywhere, no v4.33.0 strays, no
references to the LaTeX-removed 'Story'/'Sections' scaffolding, and the appendix index's
Learning-objectives box is present and accurate.

**Recommendation: Major revisions.** The code compiles and the mathematics is sound, but the
solutions appendix ships two wrong claims (one offering non-compiling code, one misdescribing
a tactic state) that directly undermine the appendix's stated purpose of teaching readers
exactly what each step and each editor display looks like. Both are one-line fixes.

---

## PER-FILE FINDINGS

### `00-index.md` — no findings

- Learning-objectives box present at `00-index.md:7-10`, right after the title, matching the
  v1.5.0 convention; content (step-by-step `rw`/`have`/`intro`, no hidden `simp`) matches the
  actual solutions. `## Sections` list (lines 17-31) matches the ten solution files;
  `10-chapter-11.md` exists as listed. The note that Chapter 2 has no exercises
  (`00-index.md:30-31`) is verified true — `02-functions-and-structures/` contains no
  exercises page.

### `01-chapter-1.md` — no findings

- Ex. 1 (β-reduction, lines 9-27): recomputed by hand — `(λx.λy.y x) a b →β (λy.y a) b →β b a`
  is correct; the comparison with $K$ and the Thrush identification ($T x y = y x$) are
  correct.
- Ex. 2 (lines 29-71): `Vec.toList` type analysis is correct (`Vec α n → List α` is
  non-dependent because the *return* type ignores `n`). The claimed `#eval` trace
  (lines 59-64) was reproduced exactly: three `toList: cons` lines, one `nil` line, `[7, 7, 7]`.
  `Vec.replicate (7 : Int) 3` agrees with `Vec.replicate`'s definition
  (`Ch01DependentTypes.lean:26-28`).
- Ex. 3 (lines 73-86): `anotherSigma` compiles; the `Σ n : Nat, n > 0` explanation is correct
  — `#check Sigma` gives `{α : Type u} (β : α → Type v) : Type (max u v)`, and `n > 0 : Prop`
  (`Sort 0`) is not a `Type v`.
- Ex. 4 (lines 88-107): the Π-unfolding table for `Path.append` is correct against the
  compiled signature `Path.append : {u v w : V} → Path Q u v → Path Q v w → Path Q u w`
  (`Ch11PathAlgebras.lean:32-33`); levels 4–5 correctly collapse to non-dependent arrows.

### `02-chapter-3.md`

**MAJOR — `⟨1, rfl⟩` is offered as a valid alternative and the justification is false.**
- WHAT: `02-chapter-3.md:40-42`: "We could also write `⟨1, Nat.one_pos⟩` or `⟨1, rfl⟩`
  (since `1 > 0` unfolds to `0 < 1`, i.e. `Nat.succ 0 ≤ 1`, which is true by definition)."
- WHY: Empirically refuted on v4.32.2. Term mode: `⟨1, rfl⟩` fails — "The argument `rfl`
  has type `?m.11 = ?m.11` but is expected to have type `1 > 0`". Tactic mode `by rfl` fails —
  "The left-hand side `0` is not definitionally equal to the right-hand side `1`". `1 > 0`
  (`Nat.succ 0 ≤ Nat.succ 0`) is an inductive proposition provable by `Nat.le.refl`, not by
  definitional equality. `⟨1, Nat.one_pos⟩` is fine (`Nat.one_pos : 0 < 1` — verified), so
  only the second suggestion is broken.
- IMPACT: A reader who types the suggested alternative gets a type error from the solutions
  appendix — the one place whose entire contract is that the code compiles. Worse, the claim
  "true by definition" teaches the opposite of the book's own Chapter 5 lesson (where
  `1 + n = Nat.succ n` is held up as a *non*-`rfl` equality requiring induction).
- FIX: Delete `or ⟨1, rfl⟩` and the parenthetical, or replace with `⟨1, Nat.one_pos⟩` and the
  honest explanation that `1 > 0` is proved by `Nat.le.refl` (a constructor application), not
  by `rfl`.

### `03-chapter-4.md` — no findings

- Ex. 1–3 all compile (verified in `Ch14AppendixSolutions.lean` and by the full build).
  `nat_mul_zero` by `rfl` works (empirically confirmed), and the explanation that `Nat.mul`
  recurses on its second argument while `0 * n = 0` needs induction is correct and consistent
  with the main-chapter Socratic answer.

### `04-chapter-5.md`

- Ex. 1 first example (`(2 : Nat) * 3 = 3 + 3 := rfl`, line 10): compiles. The second
  example's analysis (lines 18-35) is **correct**: `n * 2 = n + n` does *not* close by `rfl`
  (confirmed — `rfl` fails, `rw [Nat.mul_two]` succeeds), and the unfolding
  `n * 2 = (0 + n) + n` is exactly right because `Nat.add` recurses on its second argument.
  `Nat.mul_two` vs `Nat.two_mul` naming claim (line 31-32) is correct.
- Ex. 2 (`MyGroup`): compiles; every field of the `MyGroup Int` instance is term-for-term
  identical to `intGroup` (`Ch06Groups.lean:21-42`) as claimed at line 62-66.
  `#eval opTwiceTC (3 : Int)` prints `6` (verified).
- Ex. 3 (Russell's paradox / `Type → Type` in `Type 1`): correct standard argument.
- Ex. 4: `add_one_eq_succ` closes by `rfl`, `one_add_eq_succ` requires induction — both
  verified empirically with the book's exact proofs.
- Monoid checkpoint (lines 125-167): compiles; `monoid_id_unique` is verbatim `id_unique`
  (`Ch07GroupTheorems.lean:8-12`) with `Grp.` → `Mn.`; the second instance `natMulMonoid`
  exceeds the deliverable (which asked for at least one). Cross-references
  (Chapter 6 Section 3 / Section 6, Chapter 7 Theorem 1) verified.

**NIT — naive-guess framing reads as a false assertion.**
- WHAT: `04-chapter-5.md:22`: "This also succeeds, though the reason requires elaboration."
- WHY: The passage then argues the opposite and concludes (line 29-30) "this does not
  type-check as `rfl`". The opening sentence is the naive guess being refuted, but it is not
  marked as such, so a skimming reader sees a flat false claim followed by its own retraction.
- IMPACT: Confusion on a subtle point (defeq vs propeq) the exercise is specifically about.
- FIX: Open with "One might first guess this also succeeds —" so the retraction is the point,
  not the surprise.

**NIT — wrong instance name in a comment.**
- WHAT: `04-chapter-5.md:71`: "#eval opTwiceTC (3 : Int) -- 6, with the Group Int instance
  found automatically".
- WHY: The instance being found is `MyGroup Int` (there is no `Group Int` instance in scope in
  that section).
- IMPACT: Cosmetic; could confuse a reader about which typeclass does the lookup.
- FIX: "the MyGroup Int instance".

### `05-chapter-6.md` — no findings

- Ex. 1 (`boolXorGroup`): the code shown matches the compiled version in
  `Ch06Groups.lean:144-178` line-for-line (verified) and compiles. The 8-case `assoc`
  breakdown ($2^3$) is correctly described.
- Ex. 2 prose (lines 53-67): correct — `left_inverse_unique` (`Ch07GroupTheorems.lean:14-25`,
  Chapter 7 Theorem 2) indeed says a left inverse of `a` equals `Grp.inv a` given the two-sided
  axioms, and the appendix rightly distinguishes that from redundancy of the axioms.

### `06-chapter-7.md` — no findings

- `inv_inv` (lines 10-15) and `cancel_left` (lines 24-36) match the compiled
  `Ch07GroupTheorems.lean:57-70` verbatim; both proofs verified to compile, and the prose
  explanation of `left_inverse_unique`'s use in `inv_inv` is accurate.

### `07-chapter-8.md` — no findings

- Ex. 1 (`bool2CommGroup`/`bool2Ring`): compiles; the field set matches the book's `Ring`
  structure (`Ch08Rings.lean:18-28`). The Z/2Z identification (XOR = addition mod 2, AND =
  multiplication mod 2) is correct.
- Ex. 2 prose (lines 64-74): correct that `a(b+c)=ab+ac` is `left_distrib` and `(a+b)c=ac+bc`
  is `right_distrib`, and verified against the compiled proofs: `mul_zero` uses
  `left_distrib` (`Ch09RingTheorems.lean:20-37`), `mul_zero_left` uses `right_distrib`
  (`Ch09RingTheorems.lean:40-56`).
- Ex. 3 (`mat2_not_comm`): the claimed arithmetic is verified by `#eval`:
  `Mat2.mul X Y = {a11 := 2, a12 := 1, a21 := 1, a22 := 1}` and
  `Mat2.mul Y X = {a11 := 1, a12 := 1, a21 := 1, a22 := 2}`; `DecidableEq Mat2` is genuinely
  unsynthesizable (confirmed: `synthInstanceFailed`), so the "why `by decide` cannot attack
  `h` directly" explanation is accurate, and `h.1 : 2 = 1` is refuted by `by decide` as claimed.

### `08-chapter-9.md` — no findings

- Ex. 1 (`neg_mul`): compiles; the `left_inverse_unique` route through the additive group and
  the `rw [← Rg.right_distrib]` step are correct against `Ring.right_distrib`'s orientation
  (`mul (addGrp.op a b) c = addGrp.op (mul a c) (mul b c)`, `Ch08Rings.lean:27`).
- The cross-reference "`mul_zero_left` (proved in Theorem 2's own section)" (lines 29-31) is
  verified: `mul_zero_left` appears at `09-ring-theorems/03-theorem-2.md:32` and is used by
  `neg_one_mul` at line 71 of that file. (The compiled `Ch09RingTheorems.lean:3-4` carries a
  stale comment attributing `mul_zero_left` to the appendix — the book text is the accurate
  one; this is a compiled-file comment, not in this slice, noted for completeness.)
- Ex. 2 (`neg_seven`): compiles by `rfl`; the variable-vs-numeral explanation is correct and
  consistent with Chapter 5's defeq/propeq discussion.

### `09-chapter-10.md`

**MINOR — Chapter 10 exercise 3 is answered below the exercise's own minimum bar.**
- WHAT: `09-chapter-10.md:60-112`. The exercise (`10-modules/07-exercises.md:49-51`) asks to
  verify `intSmul` satisfies `Module`'s axioms "at least for `one_smul` and `smul_add` — by
  induction on the integer scalar". The appendix proves `one_smul` fully (lines 62-76,
  verified), but for `smul_add` it proves `natSmul_add` (lines 80-101): induction on a
  *natural* scalar only, with an *extra hypothesis* `comm : ∀ a b, Grp.op a b = Grp.op b a`,
  and not literally the `intSmul`/`intRing` statement. `add_smul` and `smul_smul` are
  explicitly deferred ("makes a good longer exercise", lines 110-112).
- WHY: `smul_add` for `intSmul` quantifies over all `Int` scalars including negatives; the
  proof shown covers only `Int.ofNat` scalars and, as stated, requires commutativity as an
  assumption rather than deriving it from `CommGroup`. The header at line 60 honestly says
  "(partial: `one_smul`, `smul_add`)", and the restriction to natural scalars is flagged at
  line 79 — but the *exercise* names `smul_add` as a required minimum, so the appendix delivers
  less than the exercise's floor for that axiom.
- IMPACT: A reader completing "the solutions" for Ch. 10 ex. 3 still has real work left on
  `smul_add` (the negative-scalar case and the instantiation against `intRing`); the appendix
  presents this as the solution without marking the residual gap in its chapter index.
- FIX: Either extend `natSmul_add` to full `Int` scalars (case on `Int.ofNat`/`Int.negSucc`),
  or mark the entry prominently as "partially verified — negative-scalar case left as an
  exercise", matching the honesty already present in the prose.

**MINOR — "Every `2` … simply replaced by the parameter `d`" overstates the generalization.**
- WHAT: `09-chapter-10.md:132-135`: "This has the same shape as `evenSubmodule` (the case
  `d = 2`). Every `2` in that proof is simply replaced by the parameter `d`…"
- WHY: `evenSubmodule`'s `zero_mem` is `⟨0, rfl⟩` (`Ch10Modules.lean:70`) because `2 * 0`
  computes; the appendix's own `multiplesSubmodule` cannot use `rfl` for a variable `d` and
  correctly switches to `⟨0, by show (0 : Int) = d * 0; rw [Int.mul_zero]⟩`
  (`09-chapter-10.md:119`). That is a change in kind (rfl → rw), not a parameter substitution;
  `add_mem`/`smul_mem` do substitute verbatim.
- IMPACT: Minor misdescription of the generalization; the code itself is correct.
- FIX: Add "except `zero_mem`, where `rfl` no longer computes once `2` is a variable".

### `10-chapter-11.md`

**MAJOR — the cons-case infoview description misstates the hypothesis types and is internally inconsistent.**
- WHAT: `10-chapter-11.md:62-70`: "the Lean Infoview lists every hypothesis the pattern match
  introduces — `Q : Quiver V A`, `h : Q.source a = v`, `h' : Q.target a = wt`,
  `q' : Path Q u vt`, and the induction hypothesis `ih : (Path.nil u).append q' = q'` — above
  the line, with the goal `(Path.nil u).append (Path.cons a h h' q') = Path.cons a h h' q'`
  below it". The image alt-text (line 70) repeats the same list.
- WHY: Against the book's own compiled `Path.cons`
  (`Ch11PathAlgebras.lean:23-24`: `cons {u v w} (a : A) (h : Q.source a = v) (h' : Q.target a = w) (p : Path Q u v) : Path Q u w`),
  I printed the actual tactic state after `induction p with | cons a h h' q' ih =>`:
  ```
  V A : Type
  Q : Quiver V A
  u v v✝ w✝ : V
  a : A
  h : Q.source a = v✝
  h' : Q.target a = w✝
  q' : Path Q u v✝
  ih : (Path.nil u).append q' = q'
  ⊢ (Path.nil u).append (Path.cons a h h' q') = Path.cons a h h' q'
  ```
  The source equality binds the *intermediate* vertex — the same variable that indexes `q'` —
  not the fixed endpoint `v`. Under the appendix's own renaming (`v✝ → vt`, `w✝ → wt`), the
  correct statement is `h : Q.source a = vt`. As printed, the description is also
  type-inconsistent with the goal it accompanies: with `h : Q.source a = v` and
  `q' : Path Q u vt`, `Path.cons a h h' q'` would be a path `Path Q u wt`, not the `Path Q u v`
  the goal requires.
- IMPACT: This passage's entire purpose is to teach readers to *read the infoview*; it
  displays a hypothesis list that cannot occur with the book's own definitions, so a reader
  who checks it against the editor sees the appendix disagree with Lean. (I could not
  machine-verify the screenshot itself — this model has no image input — but the prose claim
  is wrong regardless of what the PNG shows.)
- FIX: Change line 64 to `h : Q.source a = vt` (and the alt-text accordingly), so the list
  reads `h : Q.source a = vt`, `h' : Q.target a = wt`, `q' : Path Q u vt` — which is exactly
  the real state modulo renaming `v✝`/`w✝` to `vt`/`wt`. If the PNG genuinely shows
  `h : Q.source a = v`, regenerate it from the current `Path.cons`.

**MINOR — Exercise 1 is answered by a parallel construction, not by the exercise's literal request.**
- WHAT: The exercise (`11-path-algebras/06-exercises.md:41-43`) asks to "Add a third arrow
  `gamma : ExampleArrow` with `source gamma = 2` and `target gamma = 0`… Build the path
  `gamma ∘ beta ∘ alpha : Path exampleQuiver 0 0`." The appendix solution
  (`10-chapter-11.md:9-33`) instead declares a new inductive `CyclicArrow` and a new quiver
  `cyclicQuiver`, building `cPathGammaBetaAlpha : Path cyclicQuiver 0 0`. It never mentions
  `ExampleArrow` or produces a term of type `Path exampleQuiver 0 0`, and does not note the
  deviation.
- WHY: The construction is mathematically sound and the pedagogical point (cycles ⇒ paths of
  unbounded length) is served, but it is a different object from the one the exercise names,
  so the appendix does not literally answer the question as posed.
- IMPACT: A reader who followed the exercise by extending `ExampleArrow` finds no matching
  solution; the appendix's chapter-11 checkpoint (line 186, "the same kind of real, verified
  obstacle…") and `13-next-steps/03-next-projects.md:114` both build on `cyclicQuiver`, so the
  deviation has propagated without acknowledgement.
- FIX: Either (a) extend `ExampleArrow` with `gamma` as the exercise asks (an
  `ExampleArrow.gamma` constructor and `gamma ∘ beta ∘ alpha : Path exampleQuiver 0 0`), or (b)
  add a sentence: "The book's `ExampleArrow` is left untouched; the same construction is done
  here on a fresh `CyclicArrow`/`cyclicQuiver`."

- Checkpoint project (lines 113-187): verified. `Path.length`, `Path.append_length`,
  `Path.append'`, `Path.length'` all compile; the `#eval` outputs (lengths 1/2/2, and the five
  traced lines in order `append cons`, `append nil`, `length cons`, `length cons`, `length
  nil`) reproduce exactly. The `simp only [Path.append, Path.length]` justification (lines
  181-184) is accurate — the compiled proof needs exactly these two unfoldings. The
  "indexed family ⇒ equation lemmas, not iota-reduction" explanation is correct. The
  `Perm3.ext` comparison (Chapter 6, Section 4 — `04-permutations-example.md:132`) is
  verified: core Lean indeed auto-generates `mk.injEq` but not `.ext` for plain structures
  (confirmed by the compiler NOTE in `Ch08Rings.lean:95-101`).

---

## REGRESSION TRACKER (v1.4.25 / v1.5.0 / v1.5.1)

1. **Toolchain version — CLEAN.** `lean_project/lean-toolchain`, `lakefile.toml` (mathlib rev),
   `README.md:108`, `NOTICE.md:10,43`, `lean_book/README.md:40`,
   `lean_book/00-setup/02-installing-toolchain.md:32`, `lean_book/00-setup/04-mathlib-note.md:45`,
   and `lean_book/learning-paths.md:60` all read `v4.32.2`. A repo-wide sweep found **zero**
   `v4.33.0` (or other version) strays outside the changelog, and the appendix itself contains
   no version strings at all.
2. **Removed 'Story'/'Sections' LaTeX scaffolding — CLEAN.** The only "Sections" heading in
   the slice is the appendix's own numbered TOC (`00-index.md:17`), which is the documented
   Markdown-source convention — per `changelog/v1.5.0.md:28`, the Markdown keeps
   `## Sections` and only the LaTeX pipeline drops it. No references to any removed
   `Story`/`Sections` content exist in the appendix. All section cross-references were checked
   against the current section numbering: Chapter 1 Sections 3/5 (`Vec.replicate` at
   `01-basics/03-dependent-types.md:141`; Σ/∃ at `01-basics/05-pi-sigma-and-coc.md:180-193`),
   Chapter 6 Sections 3/6, Chapter 11 Sections 4–5 (`04-paths-as-inductive-type.md`,
   `05-path-composition.md`). None dangle.
3. **Learning objectives boxes — CONSISTENT.** The appendix index has the box
   (`00-index.md:7-10`), correctly placed after the title and matching its content. The
   per-chapter solution pages do not have boxes, which is consistent with the convention for
   main-chapter sub-pages (only `00-index.md` and the two checkpoint-project pages carry
   learning objectives anywhere in the book — verified by sweep). No missing/misrendered/
   contradicting box.
4. **Removed-scaffolding gaps — NONE.** No exercise or theorem in the appendix leans on a
   removed section; every solution is self-contained relative to the current chapter text.
   The two intentional non-compiling snippets (`n * 2 = n + n := rfl` at
   `04-chapter-5.md:19`, flagged as failing; `⟨1, rfl⟩` at `02-chapter-3.md:41`, flagged
   *incorrectly* as succeeding — see MAJOR above) are the only non-compiling code in the
   slice, and the second one is the regression-relevant hazard: it was not caught by the
   v1.4.25 re-verification despite being exactly the class of defect ("code that looks right
   but does not compile") the toolchain bump was meant to re-sweep.
5. **v1.5.1 cross-reference sweep — CONSISTENT with this review.** The v1.5.1 changelog
   claims a programmatic sweep found zero `[Chapter N, Section M]` link mismatches; the
   appendix's prose-only section references (no hyperlinks) were re-verified here by hand and
   all resolve.

---

## VERIFICATION LOG

What I actually ran / recomputed (toolchain `leanprover/lean4:v4.32.2`, `elan`-managed):

1. `lake build` in `lean_project/` — **passed, 8680 jobs, zero errors**. This compiles every
   appendix solution, including those asserted to live in chapter modules
   (`Ch14AppendixSolutions.lean` imports all of them; header comments cross-checked against
   `Ch06Groups.lean:144-178`, `Ch07GroupTheorems.lean:57-70`, `Ch08Rings.lean:267-270`,
   `Ch11PathAlgebras.lean:49-84`).
2. Scratch file under the project (removed afterward) testing, on v4.32.2:
   - `example (n : Nat) : n * 2 = n + n := rfl` → **error** (as the book says);
     `rw [Nat.mul_two]` → **ok**.
   - `theorem add_one_eq_succ (n : Nat) : n + 1 = Nat.succ n := rfl` → **ok**;
     `one_add_eq_succ` by the book's induction → **ok**.
   - `theorem exists_gt_zero : ∃ n : Nat, n > 0 := ⟨1, rfl⟩` → **error**:
     "The argument `rfl` has type `?m.11 = ?m.11` but is expected to have type `1 > 0`".
     `by rfl` on `1 > 0` → **error**: "The left-hand side `0` is not definitionally equal to
     the right-hand side `1`". `#check Nat.one_pos` → `Nat.one_pos : 0 < 1` (so
     `⟨1, Nat.one_pos⟩` is valid).
   - `trace_state` inside the `cons` case of the book's `append_nil_left` induction →
     **printed the actual hypothesis list** quoted in the MAJOR finding (proves the
     `h : Q.source a = v` claim wrong).
   - `#eval Mat2.mul X Y` / `Mat2.mul Y X` → `{a11 := 2, a12 := 1, a21 := 1, a22 := 1}` /
     `{a11 := 1, a12 := 1, a21 := 1, a22 := 2}`; `inferInstance : DecidableEq Mat2` →
     **synthInstanceFailed**.
   - `#check Sigma` → `{α : Type u} (β : α → Type v) : Type (max u v)`.
   - `#eval Vec.toList' (Vec.replicate (7 : Int) 3)` → 3 cons lines + nil line + `[7, 7, 7]`
     (matches `01-chapter-1.md:59-64`).
   - `#eval opTwiceTC (3 : Int)` → `6`; `#eval pathAlpha.length` → `1`,
     `pathBetaAlpha.length` → `2`, `(Path.append pathAlpha pathBetaOnly).length` → `2`;
     `#eval (Path.append' pathAlpha pathBetaOnly).length'` → the exact five traced lines in
     order, then `2` (matches `10-chapter-11.md:135-137,160-166`).
   - `intSmul_one_smul` with the appendix's `show`-chain → **ok** (against
     `natSmul`/`intSmul` definitions, `Ch10Modules.lean:25-34`).
3. Hand re-derivation: `mul_zero` uses `left_distrib` and `mul_zero_left` uses
   `right_distrib` (`Ch09RingTheorems.lean:20-56`); `neg_mul`'s rewrite chain is consistent
   with `Ring.right_distrib`'s orientation (`Ch08Rings.lean:27`).
4. Cross-reference audit against main chapters: all "Chapter N, Section M" and "Theorem N"
   references in the slice resolve (details under Regression Tracker and per-file notes).
5. Could **not** verify visually: `lean_book/11-path-algebras/images/append-nil-left-infoview.png`
   exists (127,978 bytes) but this model has no image input; the finding is anchored on the
   verifiable prose (line 64) and the empirically printed tactic state instead.

<<<REPORT_END>>>
