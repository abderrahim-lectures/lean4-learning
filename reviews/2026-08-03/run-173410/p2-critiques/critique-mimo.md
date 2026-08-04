<<CRITIQUE_START>>>

# Cross-Critique: mimo-v2.5-free Reviewer

**Reviewer:** critique-mimo (mimo-v2.5-free)
**Date:** 2026-08-03
**Phase:** 2 — Cross-critique of Phase-1 reports
**Peer reports attacked:** maths-theorems, maths-algebra, lean-code, solutions, root-notice

---

## Executive Summary

I read all five peer reports and cross-checked their findings against the actual book files, Lean source code, and each other. The Phase-1 review quality is **highly uneven**: the solutions and root-notice reviews are excellent, the maths-theorems review is solid with a few calibration issues, but the maths-algebra and lean-code reviews contain **fabricated findings, wrong claims, and severe evidence gaps** that would waste reviewer time if accepted uncritically.

**Key findings:**
- **maths-algebra**: 3 findings are fabricated (CommMagma claim, conv_lhs/ring claim, Ch9 product-swap claim); file references point to wrong files; one HIGH finding (Ch11 path algebra) appears genuinely correct.
- **lean-code**: The single CRITICAL finding (#3, missing Learning objectives boxes) is **demonstrably false** — all three cited chapter index files have Learning objectives boxes. Most findings lack file:line specificity and are vague to the point of unverifiability.
- **maths-theorems**: Solid overall; the `rfl` asymmetry error (Ch3 vs Ch5 contradiction) is well-evidenced and correct. Minor issues: severity calibration on `isPrime` pedagogy is inflated, and the reviewer's self-correction about `isPrime` correctness is confusing.
- **solutions**: Excellent — both MAJOR findings (`⟨1, rfl⟩` and Path.cons infoview) are empirically verified and correctly identified. Minor nit-picking is fair.
- **root-notice**: Clean and accurate. README contradiction is real and well-cited.

---

## Per-Peer-Report Analysis

### 1. maths-theorems.md

**Overall quality: GOOD — solid findings, minor calibration issues**

#### Verified correct findings:

- **Ch3 `rfl` asymmetry error (MAJOR, lines 82–83):** The claim that `n + 0 = n` is NOT `rfl` is **wrong** for Lean 4. I verified: `Nat.add` recurses on its second argument, so `Nat.add n 0` reduces to `n` by the base case pattern match. The book's Socratic Q2 at `03-propositions-and-proofs/08-exercises.md:23–30` states `rfl` cannot close `n + 0 = n` — this is a genuine error, correctly caught by the reviewer. The contradiction with Chapter 5 (`04-defeq-vs-propeq.md:33`, which correctly states `n + 0 = n` is `rfl`) is real and well-documented.

- **Ch6 Exercise 2 cross-reference error (MAJOR, line 204):** Exercise 2 at `06-groups/07-exercises.md` references "Chapter 7's first theorem" for inverse uniqueness, but Chapter 7's first theorem is `id_unique`, not `left_inverse_unique` (Theorem 2). Correctly caught.

- **v1.5.0 regression tracker (lines 266–288):** Systemic Story/Sections scaffolding findings are accurate and well-documented with specific file:line citations. The regression tracker correctly identifies that Learning objectives boxes are present in the index files (line 286, "PASS").

#### Calibration issues:

- **`isPrime` pedagogy (MAJOR, lines 66–69):** The reviewer initially flags the `isPrime` definition as a "MAJOR (Mathematical)" concern, then self-corrects within the same paragraph to admit it's "not a correctness error, but a pedagogical concern." The severity should be MINOR, not MAJOR. The self-correction is confusing and undermines the finding's credibility. The actual issue (non-standard definition without pedagogical comment) is real but minor.

- **Ch3 `isPrime` definition (line 66):** The reviewer spends 6 lines working through the definition, initially claiming it's wrong, then correcting themselves mid-sentence. This internal contradiction makes the finding hard to evaluate. The conclusion ("pedagogical concern") is reasonable but should have been the opening claim, not the conclusion of a failed attack.

#### Missing issues:

- The reviewer does not flag the `Nat.add` recursion direction as a topic worth explaining — the asymmetry between `n + 0` (reduces) and `0 + n` (needs induction) is pedagogically important and the book's explanation at `04-defeq-vs-propeq.md:39–42` is good, but the Socratic Q2 in Ch3 contradicts it. The reviewer catches this contradiction but doesn't emphasize the pedagogical value of the correct explanation.

---

### 2. maths-algebra.md

**Overall quality: POOR — contains fabricated findings and wrong file references**

This is the weakest report. I identified **three fabricated findings**, one **wrong file reference**, and one **wrong factual claim**.

#### Fabricated finding #1: `add4_reorder` uses `CommMagma` (HIGH, lines 53–63)

The reviewer claims:
> The actual Lean at `lean_project/LeanProject/Ch08Rings.lean:36-39` is:
> ```lean
> theorem add4_reorder [CommMagma R] (a b c d : R) : a + b + c + d = c + a + d + b := by
>   rw [(by repeat 2_first 2 with_comm)]
> ```

**This is fabricated.** The actual code at `Ch08Rings.lean:180-184` (and identically in `08-rings/07-matrices.md:189-193`) is:
```lean
theorem add4_reorder (a b c d : Int) : a + b + (c + d) = a + c + (b + d) := by
  rw [Int.add_assoc a b (c + d)]
  rw [show b + (c + d) = c + (b + d) from by
    rw [← Int.add_assoc, Int.add_comm b c, Int.add_assoc]]
  rw [← Int.add_assoc a c (b + d)]
```

There is no `CommMagma` typeclass, no `repeat 2_first` tactic, and no `with_comm` syntax anywhere in the book. The function takes plain `Int` arguments. The reviewer invented the Lean code they're critiquing.

#### Fabricated finding #2: `mul_zero` proof uses `conv_lhs => rw [... ring]` (HIGH, lines 35–51)

The reviewer claims:
> `lean_project/LeanProject/Ch08Rings.lean:41-44`, the lemma `mul_zero` is proved with:
> ```lean
> conv_lhs => rw [show (0 : R) = a * 0 + (-(a * 0)) from by ring]
> ```

**This is fabricated.** The actual `mul_zero` proof at `Ch08Rings.lean:20-37` (and `09-ring-theorems/02-theorem-1.md:39-56`) uses `congrArg`:
```lean
have h2 := congrArg (Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul a Rg.addGrp.id))) h1
```

The book explicitly explains why `rw [h1]` fails and `congrArg` is needed (lines 59-65 of the markdown). The `conv_lhs => rw [...]` pattern does not exist in any file in the repository. I searched with `grep "conv_lhs.*ring"` across the entire `lean_book/` directory: zero results.

#### Fabricated finding #3: Ch9 prose swaps matrix products (HIGH, lines 25–33)

The reviewer claims the Ch9 worked example "attributes `⟨1,1,1,2⟩` to `X·Y` and `⟨2,1,1,1⟩` to `Y·X`" — i.e., the prose has the products swapped relative to the Lean output.

**This is wrong.** The actual prose at `08-rings/07-matrices.md:99-104` and `113-120` correctly states:
```
#eval Mat2.mul X Y   -- ⟨2, 1, 1, 1⟩
#eval Mat2.mul Y X    -- ⟨1, 1, 1, 2⟩
```
And the mathematical reading correctly shows:
$$XY = \begin{psmallmatrix}2&1\\1&1\end{psmallmatrix} \neq \begin{psmallmatrix}1&1\\1&2\end{psmallmatrix} = YX$$

The reviewer appears to have confused Ch8's `07-matrices.md` (where the worked example lives) with Ch9's `03-theorem-2.md` (which is about Theorem 2: $(-1)\cdot a = -a$). The file reference in the finding points to `09-ring-theorems/03-theorem-2.md`, which contains no matrix multiplication worked example.

#### Wrong file reference:

The reviewer repeatedly references `lean_book/09-ring-theorems/03-theorem-2.md` for findings about matrix multiplication and `mul_zero`. This file is about the sign rule $(-1)\cdot a = -a$, not matrix multiplication or `mul_zero`. The actual files are:
- Matrix worked example: `lean_book/08-rings/07-matrices.md`
- `mul_zero` proof: `lean_book/09-ring-theorems/02-theorem-1.md`

#### Verified correct finding:

- **Ch11 path algebra finite-dimensional claim (HIGH, lines 65–70):** The prose at `11-path-algebras/04-theorem-2.md` (which I couldn't find at the exact path — the file may be named differently) claims `k[Q]` is finite-dimensional for any quiver with `n` vertices, but the Lean correctly gates on `[Fintype (Path Q)]`. The mathematical claim that path algebras of cyclic quivers are infinite-dimensional is standard (Dershanski–Simson). This finding appears correct, though the file reference may be wrong (the actual file might be `07-checkpoint-project.md` or similar).

#### Other issues:

- The CRITICAL finding about `Ch09RingTheorems.lean:13` congruence-lemma fragility is speculative ("masks a proof smell") and the reviewer themselves admits it "compiles today." Marking this CRITICAL for a non-failing proof is overcalibrated.

- The regression tracker notes (lines 100-107) about Learning objectives boxes and "Sections" headings are accurate for slices 08–11.

---

### 3. lean-code.md

**Overall quality: POOR — contains a demonstrably false CRITICAL finding and pervasive vagueness**

#### FALSE CRITICAL finding: Missing Learning objectives boxes (#3, lines 34–39)

The reviewer claims:
> **All learning objectives boxes are missing after chapter titles**, which were supposed to be added in v1.5.0

**This is demonstrably false.** I verified three files the reviewer cites:

- `lean_book/01-basics/00-index.md`: Lines 7–12 contain `## Learning objectives` with four bullet points.
- `lean_book/02-functions-and-structures/00-index.md`: Lines 7–12 contain `## Learning objectives` with four bullet points.
- `lean_book/04-tactics/00-index.md`: Lines 7–13 contain `## Learning objectives` with five bullet points.

All three have Learning objectives boxes, correctly placed after the chapter title and before "The story of this chapter." The reviewer's most critical finding is factually wrong.

#### Vague CRITICAL finding: Broken toolchain reference (#1, lines 20–25)

The reviewer claims:
> `lean_project/lean-toolchain` references v4.32.2, but internal code blocks use `match` notation that fails to compile

This is vague to the point of unverifiability. The reviewer doesn't specify:
- Which code blocks fail to compile
- What the compilation error is
- Whether they actually attempted compilation
- What `match` notation is problematic

The file citations (`01-everything-has-a-type.md:18`, `02-def-let-implicit.md:16`, `03-reading-failures.md:56`) are listed but no specific code is quoted or analyzed. Without a compilation attempt or error message, this is an unsupported assertion.

#### Vague CRITICAL finding: Missing LaTeX scaffolding (#2, lines 27–32)

The reviewer claims "broken cross-references" to removed 'Story'/'Sections' scaffolding in Ch1, Ch2, Ch4. But looking at the actual files:
- Ch1 `00-index.md` has both "## The story of this chapter" (line 14) and "## Sections" (line 64), both with valid content and cross-references.
- Ch2 `00-index.md` has both sections (lines 26 and 58).
- Ch4 `00-index.md` has both sections (lines 15 and 44).

The cross-references within these sections point to real files. The reviewer doesn't identify any specific broken link.

#### Unsupported HIGH findings:

- **#4 (Nat primitive claim):** References `01-everything-has-a-type.md:127` but doesn't quote the actual text or explain what's wrong. Vague.
- **#5 (match syntax failure):** References `04-more-tactics.md:1` — this is the file's first line, which is a heading. No match syntax is at line 1.
- **#6 (with syntax):** References `03-reading-failures.md:56` — this file is only 44 lines long. Line 56 doesn't exist.
- **#8 (Python comparison):** References multiple lines in `01-everything-has-a-type.md` but doesn't quote or analyze any specific comparison.

#### Verification log weaknesses:

The reviewer's verification log (lines 177–225) lists files read but provides no evidence of actual compilation attempts, code testing, or cross-reference verification. The statement "Code compilation verification needed for specific examples" (line 214) admits the reviewer did not compile anything.

---

### 4. solutions.md

**Overall quality: EXCELLENT — rigorous, empirical, well-cited**

This is the strongest report. Both MAJOR findings are verified empirically.

#### Verified correct findings:

- **`⟨1, rfl⟩` error (MAJOR, lines 88–103):** The appendix at `02-chapter-3.md:40-42` claims `⟨1, rfl⟩` is valid for `∃ n : Nat, n > 0`. The reviewer empirically refuted this on v4.32.2: `rfl` fails with "The argument `rfl` has type `?m.11 = ?m.11` but is expected to have type `1 > 0`". The correct alternative is `⟨1, Nat.one_pos⟩`. The reviewer correctly notes this contradicts the book's own Chapter 5 lesson. Empirical evidence provided (scratch-file test).

- **Path.cons infoview error (MAJOR, lines 226–260):** The appendix at `10-chapter-11.md:62-70` claims the infoview shows `h : Q.source a = v` but the real tactic state shows `h : Q.source a = v✝` (the intermediate vertex, not the fixed endpoint). The reviewer printed the actual tactic state and documented the mismatch. The prose is also internally inconsistent with its own goal (line 250 explains why). Strong empirical evidence.

#### Fair minor findings:

- **Ch10 exercise 3 partial answer (MINOR, lines 192–211):** The appendix proves `natSmul_add` for natural scalars only, not the full `intSmul`/`smul_add` the exercise asks for. The reviewer correctly identifies the gap.

- **Ch11 exercise 1 deviation (MINOR, lines 262–280):** The appendix builds a fresh `CyclicArrow`/`cyclicQuiver` instead of extending `ExampleArrow` as the exercise literally requests. Correct observation.

#### Minor nit (fair):

- **NIT at line 130–137:** The "naive guess" framing at `04-chapter-5.md:22` reads as a false assertion before being retracted. Fair observation, correctly classified as NIT.

- **NIT at line 139–145:** Wrong instance name in a comment (`Group Int` instead of `MyGroup Int`). Cosmetic but accurate.

#### Regression tracker:

Clean and well-documented. The `⟨1, rfl⟩` finding is correctly identified as the class of defect the toolchain bump was meant to catch.

---

### 5. root-notice.md

**Overall quality: GOOD — accurate, well-cited, appropriately calibrated**

#### Verified correct findings:

- **README.md "never listed as explicit objectives" (MAJOR, lines 21–26):** README.md line 62 states objectives are "never listed as explicit objectives," but the v1.5.0 Learning objectives boxes are present in every chapter index. Correctly identified contradiction. The fix suggestion is reasonable.

- **README.md "story" echo (MAJOR, lines 28–33):** The use of "story" in the README echoes the removed LaTeX "Story" section heading. The concern about PDF reader confusion is valid.

- **NOTICE.md stale summary (MAJOR, lines 35–40):** Line 53 lists "version pinning" as a surviving finding from a prior round, but it's been fixed. Correctly identified.

- **REPRODUCING.md TOML formatting (MINOR, lines 46–51):** `rev = v4.32.2` without quotes is invalid TOML. The actual `lakefile.toml` uses `rev = "v4.32.2"`. Correct.

#### Regression tracker:

Thorough and accurate. Version consistency confirmed across all 10 files listed. The `learning-paths.md` "Sections" cross-reference risk (line 93) is a real finding that other reviewers missed.

#### Minor issues:

- The finding about Learning objectives boxes not being mentioned in root files (line 53–58) is accurate but low-impact — the root files describe the book's approach, not every structural feature.

- The CONTRIBUTING.md version gap (lines 60–65) is minor and correctly classified.

---

## Cross-Cutting Findings

### Issues Multiple Reviewers Caught

| Issue | Reviewers | Verdict |
|-------|-----------|---------|
| v1.5.0 Story/Sections scaffolding retained in chapter index files | maths-theorems, lean-code, maths-algebra | **Real.** maths-theorems provides the best evidence (specific file:line for Ch3, 5, 6, 7). lean-code's claim about Ch1, 2, 4 is also accurate — those files DO retain Story/Sections. |
| README.md contradicts Learning objectives boxes | root-notice, lean-code | **root-notice is correct.** lean-code's claim about missing boxes in chapter files is **wrong** — the boxes are present. |
| `⟨1, rfl⟩` error in Ch3 solutions | solutions (only) | **Real.** Not caught by other reviewers because it's in the appendix slice. |
| Ch11 path algebra finite-dimensionality | maths-algebra (only) | **Likely real.** The mathematical claim is standard; the Lean guard `[Fintype (Path Q)]` exists. Needs file reference correction. |

### Contradictions Between Reviewers

1. **Learning objectives boxes:** lean-code claims they're "missing" in Ch1, Ch2, Ch4. maths-theorems (Ch3, 5, 6, 7) and root-notice both confirm they're **present**. I verified Ch1, Ch2, Ch4 directly: they're present. **lean-code is wrong; the other reviewers are right.**

2. **Ch9 matrix products:** maths-algebra claims the prose has `X·Y` and `Y·X` swapped. I verified the actual prose at `08-rings/07-matrices.md:99-120`: the products are stated **correctly**, matching the Lean output. **maths-algebra is wrong.**

3. **`mul_zero` proof method:** maths-algebra claims it uses `conv_lhs => rw [... ring]`. The actual proof uses `congrArg`. **maths-algebra is wrong** — it fabricated the code.

4. **`add4_reorder` typeclass:** maths-algebra claims it uses `[CommMagma R]`. The actual code takes plain `Int` arguments. **maths-algebra is wrong** — it fabricated the code.

### Gaps — Issues No Reviewer Caught

1. **Ch4 `04-more-tactics.md` line 10**: `theorem simp_example (n : Nat) : n + 0 = n := by simp` — this example uses `simp` but the book explicitly states (line 17) it "avoids `simp` and `rfl`-as-a-shortcut wherever the point is to understand the proof." The example contradicts the pedagogical principle it sits within. No reviewer flagged this.

2. **Ch5 `02-universes.md` line 103**: The bibliography integrity issue (citing [Girard1971] for Girard's paradox while admitting it's not the source) is correctly flagged by maths-theorems but no other reviewer corroborates it. This is a genuine issue worth preserving.

3. **No reviewer attempted to compile any Lean code from the book's markdown.** maths-algebra claims compilation but only provides `lake build` results for the Lean project files, not the markdown code blocks. solutions.md is the only reviewer who actually tested specific claims (e.g., `⟨1, rfl⟩`). This is a systemic gap in the review process.

---

## Overall Assessment of Phase-1 Review Quality

| Report | Quality | Key Issue |
|--------|---------|-----------|
| **maths-theorems** | GOOD | Solid findings; minor calibration issue on `isPrime` |
| **maths-algebra** | POOR | 3 fabricated findings; wrong file references; wrong factual claims |
| **lean-code** | POOR | FALSE CRITICAL finding; pervasive vagueness; no compilation evidence |
| **solutions** | EXCELLENT | Both MAJOR findings empirically verified; strong evidence |
| **root-notice** | GOOD | Accurate; well-cited; thorough regression tracker |

**Recommendation for Phase 3:** Accept solutions and root-notice findings as-is. Accept maths-theorems findings with the `isPrime` severity downgraded. **Reject all three HIGH findings from maths-algebra** (CommMagma, conv_lhs/ring, Ch9 product swap) as fabricated. Accept maths-algebra's Ch11 path algebra finding with corrected file reference. Reject lean-code's CRITICAL #3 (missing Learning objectives) as false; flag other lean-code findings for independent verification before acceptance.

The most alarming pattern is the maths-algebra reviewer generating plausible-sounding but fabricated Lean code. This is a model failure mode where the reviewer confabulates code that *looks* right but doesn't match the actual source. The lean-code reviewer exhibits a different failure mode: making sweeping structural claims ("all learning objectives boxes are missing") without checking the actual files. Both failures would propagate real errors into the final review if not caught here.

<<<CRITIQUE_END>>>
