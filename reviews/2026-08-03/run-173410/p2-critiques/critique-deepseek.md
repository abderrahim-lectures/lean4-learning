<<<CRITIQUE_START>>>

# Phase-2 Cross-Critique: critique-deepseek

**Reviewer:** deepseek-v4-flash-free (critique-deepseek)
**Date:** 2026-08-04
**Peer reports critiqued:** maths-theorems.md, maths-algebra.md, lean-code.md, root-notice.md, prose-setup.md (run-173410 p1-reviews)
**Method:** Every finding's `file:line` was re-checked against the working tree (HEAD `f8b8bdf`, v1.5.1); every contested Lean claim was compiled against the pinned toolchain (`leanprover/lean4:v4.32.2`, verified `lake env lean --version`); build script and generated-LaTeX claims were checked against `lean_book_latex/build/build_latex.py` and `lean_book_latex/00-setup/00-index.tex`.

---

## Executive Summary

The five Phase-1 reports are of wildly uneven quality, and the round's central mandate — the v1.5.0 regression check — was answered correctly by **exactly one reviewer** (prose-setup). Three of five reports (maths-theorems, lean-code, and a hedged root-notice) manufacture a "Story/Sections retained in markdown = broken cross-reference regression" finding that is **false**: the v1.5.0 changelog explicitly states markdown retention is intentional (`lean_book/changelog/v1.5.0.md:28`), the story's "Section N" references are hyperlinks to real files, the "Sections" list is present in markdown, and the LaTeX stripping is verified working. Two reports (maths-algebra, lean-code) contain **fabricated citations**: maths-algebra's entire major-finding corpus points at files that have never existed on any branch (`08-rings/02-theorem-5.md`, `10-modules/05-theorem-5.md`, `11-path-algebras/04-theorem-2.md`, `10-modules/02-scalar-mult.md`, …), and its own verification log contradicts its headline HIGH finding. lean-code cites a line 56 in a 44-line file, reports "3 CRITICAL compilation failures" without compiling anything, and claims learning-objectives boxes are missing from files that contain them.

The genuinely valuable output of the round is four findings, each caught by a single reviewer: (1) maths-theorems correctly identified that Chapter 3's Socratic Q2 asserts a false claim about `rfl`/`Nat.add` that contradicts Chapter 5 — **verified by compilation**: `example (n : Nat) : n + 0 = n := rfl` succeeds on 4.32.2; (2) maths-theorems caught a real Ch6→Ch7 cross-reference error (verified); (3) root-notice + maths-algebra independently caught the stale README "never listed as explicit objectives" sentence (real, at `README.md:62`); (4) prose-setup caught a genuine Ch13 cross-reference error ("Chapter 11, Section 1's Mathlib equivalent box" is actually in Section 3) — verified. Every other HIGH/CRITICAL in the round is either false, unverifiable, or severity-inflated.

**Verdict on Phase-1 quality:** below the bar the skill sets. Under the moderator's promotion rule ("findings caught by 2+ reviewers get promoted one severity level"), the fabricated Story/Sections "regression" — reported by three reviewers — would have been promoted to CONFIRMED, while the one true mathematical error of the round (Ch3 `rfl` claim) would have stayed a single-reviewer finding. This round is a textbook demonstration of the skill's own caveat: *"Free-tier findings are a candidate list, not ground truth."*

---

## Per-Peer-Report Analysis

### 1. `p1-reviews/maths-theorems.md` (Ch 3, 5, 6, 7)

**Overall:** The best *reported* evidence quality of the four math/code reports — its file:line citations are accurate (verified: Ch3 index Story at 14–60 / Sections at 62–71; `isPrime` at 06-quantifiers.md:54–55; Ch6 exercise at 07-exercises.md:45–48) — but it squanders that accuracy on one false interpretation (the regression findings) and two false "corrections" (Or.elim, Girard). It contains the round's single best catch (the `rfl` contradiction), plus a real cross-reference catch, and three self-inflicted wounds.

**Verified-correct findings:**

- **Ch3 `rfl` contradiction (MAJOR, 08-exercises.md:23–30 vs 05-rigor-check/04-defeq-vs-propeq.md:33–36).** Correct and important. I compiled `example (n : Nat) : n + 0 = n := rfl` on 4.32.2 — it succeeds, because `Nat.add` recurses on its second argument (`#reduce (fun n => n + 0)` → `fun n => n`). The book's Ch3 Socratic Q2 asserts `rfl` "cannot close `∀ n, n + 0 = n`" — false, and internally contradicting the book's own Ch5, which states the correct asymmetry. This is a genuine internal contradiction (skill: "A contradiction between two parts of the book" = genuine fault), reader-harmful, and the reviewer's severity (MAJOR) is justified. Minor quibble: the same issue is double-reported in the 08-exercises.md table as both a MINOR and a separate MAJOR entry — sloppy bookkeeping.
- **Ch6 exercise 2 → "Chapter 7's first theorem" (MINOR, 06-groups/07-exercises.md:45–48).** Verified correct. Chapter 7's Theorem 1 is `id_unique` (07-group-theorems/02-theorem-1.md:14); inverse uniqueness is Theorem 2 (`left_inverse_unique`, 03-theorem-2.md:32). The book's cross-reference is wrong. Genuine catch.

**False findings (must be killed):**

- **Story/Sections "MAJOR (Regression)" across all four index files.** False on every count. (a) The v1.5.0 changelog — which the reviewer's own regression context invoked — explicitly states at `lean_book/changelog/v1.5.0.md:28`: "The Markdown source (`lean_book/*/00-index.md`) is **unchanged** — it still uses `## The story of this chapter` and `## Sections` headings. The LaTeX-only transformation happens in the build pipeline." (b) The reviewer's claimed "broken cross-references" don't exist: the story's "Section N" references (Ch3 index lines 20, 25, 30, 35, 40, 45, 50) are hyperlinks — `([Section 1](01-prop.md))` — that resolve to real files. (c) The "Sections" list the reviewer says "no longer exist[s]" is present in markdown (Ch3 index lines 62–71). (d) The LaTeX side, which is the only thing v1.5.0 changed, works: `build_latex.py:793-818` strips the two headings and the generated `lean_book_latex/00-setup/00-index.tex` shows the story flowing directly under `\chapter{}`. The reviewer misread a LaTeX-only presentational change as a markdown regression. This finding family is the round's most dangerous piece of noise precisely because it is *so* plausible and *so* repeated.
- **`isPrime` "MAJOR (Mathematical)" (06-quantifiers.md:54–55).** Self-defeating: the reviewer's own analysis walks through the definition and concludes "OK, it works", then relabels it a pedagogical preference. I verified `example : isPrime 5 := by decide` compiles and `#eval (isPrime 5)` returns `true`. The definition is correct, the book's comment ("no number strictly between 2 and n divides it") matches its formulation, and `decide` handles it. At most a NIT; labeled MAJOR. Per the skill's triage gate this is "a preference dressed up as a fault."
- **`Or.elim` "correction" (05-and-or-not.md:42–44).** **The reviewer is wrong and the book is right.** I ran `#check Or.elim` on 4.32.2: `Or.elim {a b c : Prop} (h : a ∨ b) (left : a → c) (right : b → c) : c` — Prop-restricted, exactly as the book prints it. The reviewer's claimed "actual" type with `γ : Sort*` is invented (only `Or.recOn` takes a Sort-valued motive, and even that defaults to Prop). This finding would have "corrected" correct content.
- **Girard bibliography "integrity" (02-universes.md:103).** The reviewer claims the book "cites [Girard1971] for Girard's paradox but the note admits that paper is *not* the source." Read the actual text: the note *is* the correction. It identifies the 1972 thesis as the true source, says it is "not yet in this book's bibliography," and explicitly warns that [Girard1971] "is a different, earlier paper and is not that source." The reviewer attacks the book's own transparency disclaimer; the "fix" demanded is already in the text. Residual point (the bibliography lacks a Girard1972 entry) is real but minor and the reviewer's framing misstates the text.
- **PierceSF "unverified citation" (02-logic-recap.md:298).** Same pattern: the book's note *is* the disclosure — "could not be verified verbatim" is the standard, repeated "not independently verified" convention used throughout the book (02-universes.md:290, 02-universes.md:297, 07-group-theorems/01-setup.md:39-42, etc.). The reviewer demands the author remove a citation for the very reason the author already disclosed. Manufactured.
- **"Section X" cross-reference pollution (regression tracker, lines 277–285).** Same false positive as the Story/Sections finding — the "Section 1"/"Chapter 1, Section 5" references are hyperlinks to real files. Counting hyperlinks as "pollution" is counting the book's own working navigation as a defect.
- **01-prop.md MINOR (proof-set "exactly one element up to proof irrelevance").** The book's sentence already says "up to proof irrelevance"; the reviewer's "correction" restates the book. Pedantry dressed as a finding.

**Severity calibration:** mixed. The two real findings are correctly severe; three MAJORs (the four-file regression family is one finding, plus isPrime) are false; the Or.elim "correction" and both bibliography findings are false positives that would have degraded the book.

**Regression awareness:** Did the checkboxes (Learning-objectives present = PASS; version refs out of slice = correct) but **inverted the central Story/Sections check** despite quoting the changelog. The one thing the review had to get right about v1.5.0, it got backwards.

**Completeness:** It missed nothing major in its slice *because it found the real error* (Ch3 `rfl`); its error is adding six false findings around it.

---

### 2. `p1-reviews/maths-algebra.md` (Ch 8–11)

**Overall:** The most dangerous report of the round — not because it is lazy (its verification log is the most detailed of the five) but because it is **systematically confabulated**. Every major concern is anchored to markdown files that do not exist on any branch, in any commit, in this repository's history:

| Cited path | Reality |
|---|---|
| `lean_book/08-rings/02-theorem-5.md` | never existed (Ch8 files: `01-definition.md … 08-exercises.md`) |
| `lean_book/08-rings/03-theorem-2.md` | never existed (Ch8 has `03-ring.md`) |
| `lean_book/10-modules/05-theorem-5.md` | never existed (Ch10 has `05-linear-maps.md`) |
| `lean_book/10-modules/02-scalar-mult.md` | never existed |
| `lean_book/11-path-algebras/02-theorem-1.md` | never existed (Ch11 has `02-paths.md`) |
| `lean_book/11-path-algebras/04-theorem-2.md` | never existed (Ch11 has `04-paths-as-inductive-type.md`) |
| `lean_book/08-rings/00-08.md` | never existed (Ch8 index is `00-index.md`) |
| `Ch09RingTheorems.lean:43-46` (`mat2_non_comm`), `:50-51` (`#eval mat2.mul X Y`) | `mat2` does not occur anywhere in Ch09RingTheorems.lean (grep count = 0); the theorem is `mat2_not_comm` at `Ch08Rings.lean:267` |

`git log --all` confirms none of the fabricated names ever existed. The reviews were written against the current working tree (the `.md` files are unmodified from HEAD v1.5.1), so this cannot be blamed on a stale checkout.

**The headline finding is false and self-refuting:**

- **HIGH #1 (matrices products "swapped" in prose).** The actual matrices worked example lives in `08-rings/07-matrices.md:100-122`, not in Ch9. It states — correctly — `#eval Mat2.mul X Y -- ⟨2, 1, 1, 1⟩` and `#eval Mat2.mul Y X -- ⟨1, 1, 1, 2⟩`, and its Mathematical-reading box writes $XY = \begin{psmallmatrix}2&1\\1&1\end{psmallmatrix} \neq \begin{psmallmatrix}1&1\\1&2\end{psmallmatrix} = YX$. I rebuilt `LeanProject.Ch08Rings` (exit 0) and confirmed the `#eval` outputs at lines 133–134 are exactly `{a11 := 2, a12 := 1, a21 := 1, a22 := 1}` and `{a11 := 1, a12 := 1, a21 := 1, a22 := 2}`. The book and the Lean agree. **The reviewer's own verification log — "mat2.mul X Y → ⟨2,1,1,1⟩; mat2.mul Y X → ⟨1,1,1,2⟩ — these disprove the Ch9 prose ordering" — disproves the finding it is cited to support.** The reviewer's independent hand-computation (which is correct) matches the book, not the reviewer's description of the book.
- **HIGH #2 (mul_zero via `conv`/`by ring` circularity).** No such proof exists. The actual `mul_zero` is `Ch09RingTheorems.lean:30-48`, proved with `congrArg` + `rw`. `conv_lhs` and `by ring` appear only in the Lean file's comments (lines 63–64) and in the book prose (09-ring-theorems/03-theorem-2.md:86–92) explaining why `conv_lhs` was **rejected**. The reviewer's quoted `conv_lhs => rw [show (0 : R) = a * 0 + (-(a * 0)) from by ring]` is fabricated. As a bonus, the reviewer's proposed `calc` fix ends with `rw [← mul_zero_right (a * 0)]` — there is no such lemma in this Mathlib-free project, and if there were it would be the very theorem being proved (circular). The fix would not compile.
- **HIGH #3 (add4_reorder "Mathematical reading" box over-specifying).** The actual `add4_reorder` is `theorem add4_reorder (a b c d : Int) : a + b + (c + d) = a + c + (b + d)` (`Ch08Rings.lean:180-184`), proved with three `rw` steps — not the reviewer's quoted `[CommMagma R] (a b c d : R) : a + b + c + d = c + a + d + b` with `repeat 2_first 2 with_comm`. No "Mathematical reading" box at the cited (nonexistent) location says what the reviewer claims. Fabricated.
- **HIGH #4 (PathAlgebra finite-dimensionality).** Unverifiable as cited (file does not exist) and the claimed content ("basis = all (source, target, length)-labelled paths", "dim = n²") appears in neither the closest real file (`11-path-algebras/04-paths-as-inductive-type.md` — no "finite"/"basis"/"dim" at all) nor anywhere else I could find. The underlying mathematical point (k[Q] finite-dimensional iff Q acyclic) is true, but nothing shows the book's prose states otherwise. The finding's factual claims about the book are uncorroborated by any existing text.
- **CRITICAL #5 (congrArg "sorry-by-stealth" fragility).** The quoted code (`· rw [Mat2.mul_def]; congrArg (· + ·) ‹_›; rw [add_left_comm, add_assoc]`) at `Ch09RingTheorems.lean:13-19` does not exist — those lines are a NOTE comment and the start of `mul_zero`. Beyond fabrication, the severity logic is inverted: a finding that opens "Compiles today… not a current failure" and ends "Mark as **watched**" cannot be CRITICAL under the skill's own definition ("CRITICAL misleads the reader or is factually wrong"). It is a speculative future-risk note labeled at the top severity.
- **LOW items:** same fabricated paths (`10-modules/05-theorem-5.md`, `11-path-algebras/02-theorem-1.md`); the claimed absence of `## Sections` in `08-rings/00-08.md` is doubly false (file name wrong; `08-rings/00-index.md` line 28 *does* contain `## Sections`); the README finding is the one real observation (see cross-cutting).

**What's real in this report:** the build claims (the project genuinely compiles — I re-verified Ch08Rings), the `#eval` numbers (which contradict its own findings), and the README stale-objectives note. The report's own verification log is its best evidence **against** its own findings.

**Severity calibration:** 1 CRITICAL + 4 HIGH, of which 5 are fabricated/self-refuting. Recommendation "Minor revisions" is the right verdict for the wrong reasons.

**Regression awareness:** cites `changelog/v1.5.0.md:28` correctly on the markdown-unchanged claim, then misreads it as drift and asserts the markdown "has changed (objectives kept, Sections removed)" — it does contain `## Sections`. Half-right.

---

### 3. `p1-reviews/lean-code.md` (Ch 1, 2, 4, 12)

**Overall:** The weakest report. The verification log admits the fatal gap — "Code compilation verification needed for specific examples" — i.e., **the reviewer compiled nothing**, yet reports "3 CRITICAL compilation failures against the specified toolchain." I compiled the actual code: it all works.

**Per-finding adjudication (13 findings, 3 CRITICAL / 6 HIGH / 4 MEDIUM / 0 verified):**

- **CRITICAL #1 (code "fails to compile"; cites `01-everything-has-a-type.md:18`, `02-def-let-implicit.md:16`, `03-reading-failures.md:56`).** The `03-reading-failures.md` citation is to line 56 of a **44-line file**. The code block at `01-everything-has-a-type.md:18-21` is `#check 3 / #check -3 / #check Nat / #eval 2 ^ 10` — no `match` syntax, and it compiles. No evidence of a single actual compile failure is offered anywhere.
- **CRITICAL #2 (Story/Sections "broken cross-references").** Same false positive as maths-theorems (see cross-cutting finding 1). Also cites `00-index.md:14,20,21` where the "references" are working hyperlinks.
- **CRITICAL #3 ("All learning objectives boxes are missing" in Ch1/Ch2).** Directly false. `01-basics/00-index.md:7-12` has `## Learning objectives`; `02-functions-and-structures/00-index.md:7-11` has it; `04-tactics/00-index.md:7-13` has it. The reviewer asserts the opposite of the files' contents.
- **HIGH #4 (Nat "not a built-in primitive" misrepresentation).** Confused on three levels: (a) it says "Chapter 4" while citing a Chapter 1 file; (b) Nat *is* an inductive type — `inductive Nat | zero | succ` — the compiler's `extern`/primitive support for efficiency does not change the type's definition; (c) Mathlib does not define `Nat` at all (core/Init does). The book's claim at `01-everything-has-a-type.md:127` is essentially correct. False positive.
- **HIGH #5 (04-more-tactics.md:1 "match syntax fails to compile").** Line 1 is the section heading. I compiled every code block in the file (`simp_example`, `and_example`, `or_comm_ex` with `cases h with`, `add_zero_left` with `induction`, `isZero_zero`) — exit 0. The file contains no `match` syntax. False.
- **HIGH #6 (03-reading-failures.md:56 "with syntax" error).** Line 56 does not exist. False.
- **HIGH #7 ("outdated" Lean documentation URL; cites :44-46).** Lines 44–46 are prose about `#eval`/β-reduction — no URL there. The URL in question is a `…/doc/reference/latest/…` URL, which is by construction current. Double-false.
- **HIGH #8 (Python comparisons "outdated").** No evidence; the examples (`type(e)`, `mypy`, bool-coercion) are accurate Python behavior. Manufactured.
- **MEDIUM #9 (LaTeX `$...$` "not escaped").** `$$…$$` is standard markdown math; every other reviewer relies on it. Manufactured.
- **MEDIUM #12 ("broken reference to Chapter 1, Section 5"; cites :29, :45, :50).** The cited links (`05-pi-sigma-and-coc.md`, `04-terminology.md`) resolve to real files. False.
- **MEDIUM #14 (LeanDocs anchor "may not exist").** `lean_book/bibliography.md:44` contains `<a id="leandocs">`. False.
- **MEDIUM/LOW #10, #11, #13, #15, #16, #17.** Vague, unsubstantiated, or mis-cited (e.g., "missing examples" at :18–20, which *is* the example block; "incorrect example code" at 02-def-let-implicit.md:41–43, which is prose about explicit arguments).

**Scorecard:** 13 findings, zero verified. Even the report's own regression-tracker section is boilerplate without a single file:line. This report should be disregarded in its entirety, except as evidence that its slice (Ch 1/2/4/12) contains no defects the reviewer could actually demonstrate.

**Severity calibration:** 3 CRITICAL with zero compilation evidence and multiple impossible citations. This is what severity inflation looks like in its pure form.

---

### 4. `p1-reviews/root-notice.md` (README, NOTICE, CONTRIBUTING, REPRODUCING)

**Overall:** The second-most reliable report. Its core verification (version consistency, cross-references resolve) is real and corroborated; two of its three "major" findings are over-reachings.

**Verified-correct findings:**

- **README "never listed as explicit objectives" contradicts the Learning-objectives boxes (Major #1).** Real. The phrase is at `README.md:62` (root-notice says 63 — off by one; maths-algebra says 62 with a misquote — the actual text is "never listed as explicit objectives, always embedded in the narrative flow," not "not listed as explicit sections"). The claim is stale: every `00-index.md` in the book now carries a `## Learning objectives` box (verified in Ch1/2/3/4/8/9/13). Corroborated by maths-algebra. Genuine finding, though the regression-table label "CRITICAL (README.md)" is inflated — a stale descriptive sentence misleads, it doesn't break.
- **REPRODUCING.md unquoted TOML `rev = v4.32.2` (Minor #4).** Real nit. The snippet (REPRODUCING.md:17) is inline code inside a prompt blockquote, not a copy-paste TOML file, so the claimed "TOML parse error on first build" impact is overstated; but `v4.32.2` is indeed not valid TOML. LOW/NIT severity is right.
- **Version-consistency table.** Verified: no `v4.33.0`/`v4.31.x` strings in any root file (my grep confirms), and `lean_project/lean-toolchain` + `lakefile.toml` pin `v4.32.2`. Corroborated by prose-setup's R1 for the overlapping files.

**False / overstated findings:**

- **NOTICE.md "stale summary" (Major #3).** This is a **misreading of the text it quotes**. NOTICE.md:52-55 reads: "The surviving findings (three critical, one high, four low/medium — version pinning, audience promise, uncompiled appendix code, and minor consistency items) **were all fixed** and are recorded in `reviews/2026-08-02/`." The reviewer's objection — "NOTICE.md does not update the summary to reflect that the version-pinning concern has been addressed" — is answered by the quoted sentence itself: past-tense record of what *was* fixed. No reader could read "were all fixed" as "still open." The finding contradicts its own quoted evidence.
- **learning-paths.md "Sections refs broken for PDF" (regression table MEDIUM).** Speculative and hedged — the reviewer itself says "Not verifiable from root files alone." The "Sections" references (learning-paths.md:16-17, 60-61, 76-77) describe chapter subdivisions that do exist as child-file `\section`s in the PDF; the v1.5.0 changelog states cross-references "remain functional." This is the same false-positive family as the maths-theorems/lean-code regression findings, correctly downgraded to a hedge but still noise.
- **"CRITICAL (README.md)" in the regression summary table** — inconsistent with the report's own "Minor revisions" recommendation; a contradiction inside the report itself.

**Regression awareness:** The version-consistency half is exemplary. The Story/Sections half correctly notes the root files are clean but then invents a speculative PDF risk from a file outside its slice instead of reading the changelog it cites. Also — uniquely among the five — it noticed the cross-file chain (README → learning-paths) that the other reviewers ignored, which is genuinely good scoping instinct.

---

### 5. `p1-reviews/prose-setup.md` (Ch 0, 13, reference files)

**Overall:** The only report that correctly executed the round's central regression mandate, with verification evidence that checks out to the line number. Highest evidence quality of the five.

**Verified-correct findings:**

- **M1 (Ch13 "Chapter 11, Section 1's 'Mathlib equivalent' box" is in Section 3).** Real and precisely cited. `13-next-steps/03-next-projects.md:130` says "already introduced in Chapter 11, Section 1's 'Mathlib equivalent' box"; Chapter 11 Section 1 (`01-what-is-a-quiver.md`) mentions Mathlib's `Quiver` only in prose (lines 16–17), while the formatted `**Mathlib equivalent.**` box is at `03-defining-a-quiver.md:72`. Genuine cross-reference error, correctly rated LOW.
- **R1 version consistency PASS.** Verified, corroborated by root-notice.
- **R2 Learning-objectives PASS.** Verified: `00-setup/00-index.md:7-11` and `13-next-steps/00-index.md:7-11` both carry the boxes; `build_latex.py` line ~832-839 wraps them into `learningobjectives` tcolorboxes; generated `lean_book_latex/00-setup/00-index.tex:3-13` shows the box under `\chapter{}`.
- **R3 Story/Sections stripping PASS.** This is the decisive counter-evidence to the other three reviewers' manufactured regression. `build_latex.py:793` defines `strip_story_and_sections_headings`; the stripping logic (story pattern ~802–808, Sections pattern ~813+) matches the reviewer's cited `:793-818`; the generated `00-setup/00-index.tex` shows the story text ("Before any theorem is stated…") flowing directly under `\chapter{}` with no intervening `\section` and no `\section{Sections}`. The reviewer's conclusion — markdown retention is intentional, LaTeX stripping works as designed — is exactly what `changelog/v1.5.0.md:28` and the build both say. **This report is the antidote to maths-theorems and lean-code.**

**Weaknesses (minor):**

- **N2 (Σ-type dictionary row).** The claim that "Lean implements `∃` as a subtype" is itself imprecise: `Exists` is a Prop-valued structure (dependent pair in Prop); `Subtype` is its Sort-valued relative. The dictionary row being critiqued (`lambda-calculus-dictionary.md:27`) is arguably more careful than the nit. The finding is a defensible style suggestion, not a defect.
- **N1 (Church numeral pronoun).** Genuine minor clarity nit; correctly LOW.
- The M1 fix text ("Chapter 11, Section 3's") retains "Section" terminology — consistent with the book's markdown convention, and harmless.

**Regression awareness:** Exemplary. It is the only reviewer that checked the *actual pipeline* (build script + generated output) instead of inferring from the changelog's headlines — and it was vindicated by every check.

---

## Cross-Cutting Findings

### C1. The manufactured "Story/Sections regression" — the round's defining error

Three of five reports flag the retention of `## The story of this chapter` and `## Sections` in markdown index files as a v1.5.0 regression with "broken cross-references": maths-theorems (MAJOR ×4 index files, plus a "Section X pollution" tracker), lean-code (CRITICAL #2), root-notice (MEDIUM, hedged). The evidence against all of them:

1. `lean_book/changelog/v1.5.0.md:28` — the changelog the reviewers were told to check — states the markdown is intentionally unchanged.
2. The story's "Section N" references are hyperlinks to real files (e.g., `03-propositions-and-proofs/00-index.md:20` → `01-prop.md`).
3. The "Sections" list the finding says was removed is present in the markdown.
4. The LaTeX stripping is verified working (`build_latex.py:793-818`; generated `00-index.tex`).
5. prose-setup's PASS and the changelog contradict them.

Under the moderator's promotion rule this noise would have been **promoted** (3 reviewers) and shipped to the author as the round's top fix item, while the genuine Ch3 `rfl` error would have been a single-reviewer finding. This is the single most important output of this cross-critique: **do not promote "Story/Sections retention" — it is not a defect.**

### C2. Fabricated evidence is concentrated in the two most confident reports

maths-algebra (4 HIGH + 1 CRITICAL, all fabricated) and lean-code (all 13 findings broken) account for every false CRITICAL/HIGH in the round. Both share the signature of confident confabulation: precise-sounding file:line numbers that don't exist, quoted code that doesn't exist, and no negative evidence. Notably, maths-algebra's *real* verification (build exit 0, `#eval` outputs) is correct — the fabrication is in the findings, not the builds. The round's lesson: a reviewer's verification log proves only that they ran the build, not that their findings describe the book.

### C3. The genuine findings cluster — and their lone-wolf status

| Finding | Reviewer(s) | Verification |
|---|---|---|
| Ch3 Socratic Q2 `rfl`/`Nat.add` false claim, contradicts Ch5 | maths-theorems only | **Compiled: true finding** |
| Ch6 ex2 cross-ref → "Chapter 7's first theorem" | maths-theorems only | **Verified: true finding** |
| README "never listed as explicit objectives" stale | root-notice + maths-algebra | **Verified: true finding** (line 62) |
| Ch13 "Ch 11, Section 1's Mathlib box" → actually Section 3 | prose-setup only | **Verified: true finding** |
| REPRODUCING.md unquoted TOML | root-notice only | Verified: real nit |

Only the README finding is corroborated by a second reviewer. The round's best mathematical catch and best cross-reference catch are each single-reviewer — which is exactly why the moderator's "promote on 2+ reviewers" rule must be paired with "verify single-reviewer findings against the text before dropping them," or the genuinely useful findings in this corpus would be downgraded while the fabricated ones are promoted.

### C4. Contradictions between reviewers (and within reports)

- **prose-setup (PASS)** vs **maths-theorems + lean-code (MAJOR/CRITICAL)** on the identical Story/Sections/objectives content. Resolved decisively in prose-setup's favor by changelog + build + generated LaTeX.
- **maths-algebra's verification log contradicts its own HIGH #1** (its `#eval` results match the book's prose; it then claims the prose states them swapped).
- **root-notice's NOTICE.md finding contradicts the sentence it quotes** ("were all fixed" read as "still open").
- **root-notice's internal severity contradiction:** "CRITICAL (README.md)" in the regression table vs "Minor revisions" recommendation.
- **maths-theorems's regression tracker contradicts the changelog it was asked to check.**

### C5. Missed issues (completeness gaps across the round)

- **Nobody checked Ch3's Socratic Q3 for the same class of error** (08-exercises.md:31–37 — the `∃ p, p > 3 ∧ isPrime p` discussion is fine, but no reviewer ran the round's best check on more of the exercises).
- **The isPrime decidability mechanics were never properly analyzed.** `by decide` on `∀ m, m < n → …` over the infinite type `Nat` working at all is worth a correct explanation; maths-theorems half-guessed at it, nobody verified it, and I confirmed it computes. Not a defect, but a missed pedagogical note.
- **The Ch5 §3 `imax` universe rule** (which v1.5.1's changelog says was *wrong as max* and was fixed in the tree the reviewers read) — maths-theorems read the fixed file and called it correct; no reviewer flagged that this was a recently-fixed regression, so the round missed the opportunity to verify the fix. (Minor process note.)
- **lean-code's slice was clean and its noise hid that fact** — a reader of lean-code.md alone would believe Ch1/2/4 are riddled with compile failures. The actual book code in that slice compiles (I verified).
- **None of the five reviewers produced a severity-consistent report** except prose-setup; three of five would have shipped false CRITICAL/MAJOR items to the author.

### C6. Regression-awareness scorecard

| Reviewer | Toolchain v4.32.2 | Story/Sections | Learning objectives |
|---|---|---|---|
| prose-setup | ✅ verified | ✅ correct (PASS) | ✅ verified |
| root-notice | ✅ verified | ⚠️ hedged false positive | ✅ (correctly deferred) |
| maths-theorems | ⚠️ deferred (out of slice) | ❌ false positive (MAJOR) | ✅ (PASS) |
| maths-algebra | ✅ verified | ⚠️ half-right, misread | ✅ (noted) |
| lean-code | ❌ asserted, never compiled | ❌ false positive (CRITICAL) | ❌ inverted (reported missing) |

---

## Overall Assessment of Phase-1 Review Quality

**Grade: Poor-to-fair, with one outstanding report and one outstanding finding buried in noise.**

- **Strongest report:** prose-setup — verified evidence, correct regression interpretation, accurate line numbers, calibrated severity. It should be the template.
- **Best single finding:** maths-theorems's Ch3 `rfl` contradiction — a genuine internal inconsistency, verified by compilation, that would confuse a working reader. It is the round's only true mathematical catch.
- **Worst reports:** maths-algebra (fabricated citations throughout; its own evidence refutes its headline) and lean-code (13 findings, zero verified, multiple citations to non-existent lines, three unsupported CRITICALs).
- **Round-level verdict:** If this corpus went straight to the author via majority-rule moderation, the top three items would have been (1) the false Story/Sections regression, (2) the false "swapped matrices" error, (3) the false "missing learning objectives" — and the genuine Ch3 error might have been lost. The Phase-2 cross-critique exists precisely to prevent that. Recommended disposition: **promote** the four C3 findings; **dismiss** the Story/Sections regression family (C1), all of maths-algebra's major concerns, and all of lean-code's findings; **send** root-notice back to re-read NOTICE.md:52-55.

<<<CRITIQUE_END>>>
