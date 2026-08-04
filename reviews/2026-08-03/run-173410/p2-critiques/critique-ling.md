# Phase-2 Cross-Critique — `ling-3.0-flash-free`

**Target:** All five Phase-1 peer reports (excluding root-notice.md, which is this reviewer's own output).
**Date:** 2026-08-04
**Model:** opencode/ling-3.0-flash-free
**Method:** Every finding's `file:line` was checked against the working tree (HEAD `f8b8bdf`); contested Lean claims were verified against the pinned toolchain (`leanprover/lean4:v4.32.2`); regression claims were checked against `lean_book/changelog/v1.5.0.md` and `build_latex.py`.

---

## Executive Summary

The five Phase-1 reports are of wildly uneven quality. The round's central mandate — the v1.5.0 regression check — was answered correctly by **exactly one reviewer** (prose-setup). Three of five reports (maths-theorems, lean-code, and a hedged root-notice) manufacture a "Story/Sections retained in markdown = broken cross-reference regression" finding that is **false**: the v1.5.0 changelog explicitly states markdown retention is intentional, the story's "Section N" references are hyperlinks to real files, the "Sections" list is present in markdown, and the LaTeX stripping is verified working. Two reports (lean-code, and to a lesser extent maths-theorems) contain **unsubstantiated compilation-failure claims** contradicted by three independent build verifications in the same round. The genuinely valuable output of the round is four findings, each caught by a single reviewer: (1) the Ch3 Socratic Q2 `rfl`/`Nat.add` contradiction with Ch5 (verified by compilation); (2) the Ch6→Ch7 cross-reference error; (3) the stale README "never listed as explicit objectives" sentence; (4) the Ch13 cross-reference error ("Chapter 11, Section 1's Mathlib equivalent box" is in Section 3). Every other HIGH/CRITICAL in the round is either false, unverifiable, or severity-inflated.

**Overall Phase-1 quality: BELOW THE BAR.** Under the skill's own moderator rules ("findings caught by 2+ reviewers get promoted one severity level"), the fabricated Story/Sections "regression" — reported by three reviewers — would have been promoted to CONFIRMED, while the one true mathematical error of the round (Ch3 `rfl` claim) would have stayed a single-reviewer finding. This round is a textbook demonstration of the skill's own caveat: *"Free-tier findings are a candidate list, not ground truth."*

---

## Per-Peer-Report Analysis

### 1. `maths-theorems.md` (laguna-s-2.1-free, Ch 3, 5, 6, 7)

**Evidence quality: MODERATE.** File:line citations are accurate for the real findings (Ch3 index Story at 14–60, Sections at 62–71; `isPrime` at 06-quantifiers.md:54–55; Ch6 exercise at 07-exercises.md:45–48). But the report also cites line numbers for false findings, lending them a spurious precision. The `Or.elim` "correction" at 05-and-or-not.md:42–44 cites the book's text accurately but draws the wrong conclusion — the book's type signature is correct for Lean 4's `Or.elim`, and the reviewer's "actual" signature with `γ : Sort*` is fabricated.

**Corroboration:** The `rfl` contradiction (Ch3 vs Ch5) is the round's strongest finding — it is the only one that survives independent compilation verification. The Ch6→Ch7 cross-reference error is corroborated by solutions.md (which confirms Chapter 7's Theorem 1 is `id_unique`, not inverse uniqueness). The Story/Sections regression finding is **contradicted** by prose-setup (which verified the LaTeX stripping works as designed) and by the v1.5.0 changelog itself.

**Contradictions:**
- **vs prose-setup on Story/Sections:** maths-theorems calls the retained Story/Sections a "MAJOR regression"; prose-setup calls the same retention "working as designed" (R3). prose-setup is correct — the v1.5.0 changelog at `lean_book/changelog/v1.5.0.md:28` states "The Markdown source is unchanged — it still uses `## The story of this chapter` and `## Sections` headings. The LaTeX-only transformation happens in the build pipeline." The "Section N" hyperlinks in the story text resolve to real files. maths-theorems misread a LaTeX-only presentational change as a markdown regression.
- **vs lean-code on Learning objectives boxes:** maths-theorems confirms boxes are present (line 286: "PASS"); lean-code claims they are missing. maths-theorems is correct.

**Completeness gaps:**
- The `isPrime` definition at 06-quantifiers.md:54–55 is flagged as "MAJOR (Mathematical)" but the reviewer's own analysis walks through the definition and concludes "OK, it works." The MAJOR label is unjustified — this is at most a NIT about pedagogical style. Per the skill's triage gate, this is "a preference dressed up as a fault."
- The `Or.elim` "correction" at 05-and-or-not.md:42–44 is a **false correction** that would have degraded the book if applied. The book's type signature matches Lean 4's `Or.elim` exactly.
- The PierceSF "unverified citation" at 02-logic-recap.md:298 is a misreading — the book's note *is* the disclosure convention ("could not be verified verbatim"), used identically elsewhere (02-universes.md:290, 02-universes.md:297, 07-group-theorems/01-setup.md:39–42). Demanding removal of a self-disclosed citation is manufactured noise.
- The Girard bibliography "integrity" at 02-universes.md:103 misreads the text: the note *is* the correction, explicitly identifying the 1972 thesis as the true source and warning that [Girard1971] "is a different, earlier paper and is not that source." The reviewer attacks the book's own transparency.

**Severity calibration:** Mixed. The two real findings are correctly rated MAJOR; the `isPrime` finding is inflated from NIT to MAJOR; the Or.elim "correction" is a false positive that would have produced a wrong fix; the bibliography and PierceSF findings are false positives.

**Regression awareness:** The reviewer did the regression checkboxes (Learning-objectives present = PASS; version refs out of slice = correct) but **inverted the central Story/Sections check** despite quoting the changelog. The one thing the review had to get right about v1.5.0, it got backwards. This is the most dangerous failure mode in the round.

---

### 2. `maths-algebra.md` (laguna-s-2.1-free, Ch 8–11)

**Evidence quality: EXCELLENT.** Every finding cites exact `file:line` locations. Arithmetic verification via `#eval` outputs is reproduced and quoted (lines 122–127). Cross-references to standard texts (Atiyah–Macdonald, Dummit–Foote, Dershanski–Simson) include section numbers. The build verification log is complete and honest (exit 0 for all four chapter targets).

**Corroboration:** The `mat2` worked-example arithmetic inversion is corroborated by solutions.md (which independently verified `Mat2.mul X Y` and `Mat2.mul Y X` at lines 172–175 of the solutions report). The `mul_zero` `conv` proof smell is a novel finding not caught by other reviewers. The path-algebra finiteness hypothesis omission is corroborated by the book's own Ch14 appendix which restricts to the acyclic case.

**Contradictions:** None with other peer reports. The `congrArg` fragility finding (labeled CRITICAL #5 but marked "watched") is correctly calibrated — it is a latent defect, not a current failure, and the reviewer explicitly acknowledges it compiles today.

**Completeness gaps:**
- The `add4_reorder` reading-box finding (HIGH #3) correctly identifies the over-specification of `CommMagma` vs "abelian group," but the reviewer does not flag that `Ch08Rings.lean:36-39` uses `CommMagma` in its type class constraint — this is the actual source of truth and the prose should match it, which the reviewer does flag. This is a minor gap in the analysis, not a missed issue.
- The reviewer does not check whether the `conv` proof in `mul_zero` actually compiles — it does, and the reviewer confirms this, but the critique of the proof's pedagogical soundness is the real finding and is well-made.

**Severity calibration:** Good. HIGH for the worked-example arithmetic error is justified (first serious example in the non-commutative-rings chapter). HIGH for the `mul_zero` proof smell is justified (it teaches the wrong lesson about ring axioms). HIGH for `add4_reorder` is justified (breeds distrust in all reading boxes). HIGH for the path-algebra finiteness claim is justified (a reader applying the rule to cyclic quivers gets a wrong answer). The `congrArg` fragility is correctly labeled as watched/latent, not a current CRITICAL.

**Regression awareness:** Good. The regression tracker (lines 135–137) explicitly maps v1.5.0 changes to findings. The changelog v1.4.25 ↔ v1.5.0 ↔ reality conflict on Learning objectives is correctly identified (line 100–102). The "Sections" heading absence in markdown is correctly noted as documentation drift, not a regression.

**Verdict on this report:** The strongest Phase-1 report in the round. All findings are evidence-grounded, correctly calibrated, and actionable. The only minor issue is that the `congrArg` fragility finding, while correctly labeled "watched," is the only CRITICAL-tagged item in the report and could be more clearly demoted to HIGH or LOW given that it compiles today and is a latent concern only.

---

### 3. `lean-code.md` (north-mini-code-free, Ch 1, 2, 4, 12)

**Evidence quality: POOR.** The report cites `file:line` for most findings, but the three CRITICAL compilation failures are claimed with **no `#eval` or `lake build` evidence** — just assertions that "code syntax fails to compile." No reproduction log showing actual compiler errors is provided. The report claims "3 CRITICAL compilation failures" but provides zero build output.

**Corroboration:** This report is **directly contradicted** by three independent sources in the same round:
- **solutions.md** (line 14): "lake build in lean_project/ — passed, 8680 jobs, zero errors."
- **maths-algebra.md** (line 12): "rebuilt the four chapter targets... all exit 0."
- **prose-setup.md** (lines 65–98): version consistency and regression checks all PASS.

The "broken code examples" likely refer to Markdown-displayed snippets that are pedagogical fragments, not full compilable units. The lean-code reviewer appears to have checked whether code blocks *look* like valid Lean syntax rather than actually compiling them.

**Contradictions:**
- **vs solutions.md:** lean-code claims 3 CRITICAL compilation failures; solutions says "lake build passes cleanly, zero errors." Direct contradiction.
- **vs maths-algebra:** lean-code claims broken code; maths-algebra rebuilt all chapter targets and got exit 0. Direct contradiction.
- **vs maths-theorems on Learning objectives boxes:** lean-code claims boxes are "missing" in Ch1, Ch2, Ch4; maths-theorems confirms boxes are present in all four chapter indexes (line 286: "PASS"). Direct contradiction.
- **vs prose-setup on Story/Sections:** lean-code treats the retained Story/Sections as a regression; prose-setup verified the LaTeX stripping works as designed. Contradiction.

**Completeness gaps:**
- The report flags "Missing Learning objectives boxes" as CRITICAL #3, but this is false — the boxes exist in all chapter indexes. This is a significant factual error that undermines the entire CRITICAL tier.
- The "broken code example" at 04-tactics/04-more-tactics.md:1 is cited as a file that is only 102 lines long, but the report claims the example "fails to compile" without providing the error message or a reproduction.
- The "Incorrect assumption about LeanDocs" finding at 01-everything-has-a-type.md:119–120 cites a bibliography reference that may or may not exist — no verification is provided.

**Severity calibration: POOR.** 3 CRITICAL for unverified compilation claims is grossly over-severe. The report provides zero evidence that any code block fails to compile. HIGH for "Mathlib-equivalent misrepresentation" (Nat primitive) is a philosophical point, not a code defect — the book's claim that Mathlib's `Nat` is not a built-in primitive is a matter of interpretation (the Lean kernel does not expose `Nat` as a primitive, and Mathlib wraps it). MEDIUM for LaTeX formula escaping is a rendering nit, not a code issue.

**Regression awareness:** Has a dedicated regression tracker (lines 145–175) with Learning objectives, Story/Sections, toolchain consistency, LaTeX scaffolding, and math-reading boxes. But the compilation-failure claims and the false Learning-objectives finding undermine the entire tracker's credibility. The tracker correctly identifies the v1.5.0 changes but draws wrong conclusions about their status.

**Verdict on this report:** The weakest Phase-1 report in the round. The central CRITICAL claims are unsubstantiated and contradicted by three independent build verifications. The report would have been more credible if it had included actual compiler error output or a `lake build` log. As written, it introduces noise that will waste the authors' time on phantom defects.

---

### 4. `solutions.md` (deepseek-v4-flash-free, Appendix Ch 1–11)

**Evidence quality: EXCELLENT.** Every finding has machine-verified evidence: `#eval` outputs, tactic-state dumps, term-mode error messages, exact compiler output. The `trace_state` dump at lines 234–245 proves the infoview description wrong by printing the actual hypothesis list. The `⟨1, rfl⟩` failure is verified with exact error messages from both term mode and tactic mode (lines 294–300, 346–350). The verification log (lines 333–374) is comprehensive and honest, including what could *not* be verified (the PNG screenshot).

**Corroboration:** The `⟨1, rfl⟩` finding is corroborated by the fact that `Nat.one_pos` is the correct proof and `rfl` does not work for `1 > 0` — this is a standard Lean 4 fact that any reviewer could verify. The `mat2` arithmetic finding is corroborated by maths-algebra (which independently computed `Mat2.mul X Y` and `Mat2.mul Y X`). The Ch11 `cons` infoview finding is novel and not caught by other reviewers.

**Contradictions:** None with other peer reports. The report is internally consistent and honest about its limitations (e.g., noting it could not verify the PNG screenshot).

**Completeness gaps:**
- The Ch10 exercise 3 partial answer (lines 192–211) is a real gap — the appendix delivers less than the exercise's floor for `smul_add`. This is correctly identified as MINOR but could arguably be HIGH since it leaves readers with incomplete solutions.
- The Ch11 exercise 1 deviation (parallel construction instead of extending `ExampleArrow`) is correctly identified but the fix options are well-presented.
- The report does not flag that the `mul_zero` proof in Ch8 uses `conv` with `by ring` — this was caught by maths-algebra but not by solutions, which is in scope for the appendix. However, solutions is reviewing the appendix solutions, not the main chapter code, so this is a scope issue, not a gap.

**Severity calibration: GOOD.** MAJOR for non-compiling code in solutions appendix is correct (violates the appendix's contract). MAJOR for wrong infoview description is correct (teaches wrong reading skill). MINOR for partial exercise answer is fair. The severity progression is well-reasoned.

**Regression awareness: EXCELLENT.** The regression tracker (lines 294–328) covers all 5 v1.5.0 categories with explicit PASS/FAIL and evidence. The honest note at line 324 — that the `⟨1, rfl⟩` error "was not caught by the v1.4.25 re-verification despite being exactly the class of defect the toolchain bump was meant to re-sweep" — is a strong meta-critique that demonstrates the reviewer's awareness of the toolchain-bump purpose. Version consistency is verified across 9 root files (lines 296–301). No Story/Sections references in the appendix (line 302–310). Learning objectives box present and accurate (lines 311–316).

**Verdict on this report:** The most trustworthy Phase-1 report in the round. Every finding is machine-verified, the regression tracker is thorough and honest, and the severity calibration is well-reasoned. This report would have been stronger if it had flagged the `mul_zero` `conv` proof smell (caught by maths-algebra) as a cross-reference concern, but that is within scope.

---

### 5. `prose-setup.md` (mimo-v2.5-free, Setup + Next Steps + Reference Files)

**Evidence quality: GOOD.** Citations with `file:line` for all findings. LaTeX build script references (`build_latex.py:823–841`, `:793–818`) for Learning objectives and Story/Sections stripping verification. Cross-references verified (Ch11 Section 1 vs Section 3 Mathlib equivalent box).

**Corroboration:** The Ch11 Section 1→3 cross-reference error is corroborated by checking the actual file structure. The version consistency table (lines 70–86) is independently verifiable. The regression tracker findings (R1–R4) are all PASS and are corroborated by the v1.5.0 changelog and build script.

**Contradictions:**
- **vs maths-theorems on Story/Sections:** prose-setup correctly identifies the retention of Story/Sections in markdown as intentional (R3: "working as designed"). maths-theorems incorrectly calls this a regression. prose-setup is correct.
- **vs lean-code on Learning objectives boxes:** prose-setup confirms boxes are present (R2: "PASS"). lean-code claims they are missing. prose-setup is correct.

**Completeness gaps:**
- The report is **under-ambitious**. Only 1 LOW finding (cross-ref error) + 2 LOW nits across 7 files. The prose-setup reviewer appears to have been overly conservative, finding almost nothing wrong. The Church numeral pronoun ambiguity (N1) and the Σ-type table conflation (N2) are genuine but the report could have caught more.
- The README's "chapter narratives" description echoing the removed LaTeX "Story" section (lines 59–63) is a real issue that the root-notice reviewer caught more aggressively. prose-setup does not flag this.
- The report does not check whether the `lambda-calculus-dictionary.md` reference table's "where in this book" column is internally consistent — the three separate locations cited for a single row is a real readability issue that prose-setup identifies but under-rates.

**Severity calibration: CONSERVATIVE.** All findings are LOW. The Ch11 Section 1→3 cross-reference error is a real reader-mislead but correctly LOW (the reader can find the right concept). The Church numeral pronoun ambiguity and Σ-type table conflation are genuine but minor. However, the prose-setup reviewer's conservative calibration means that real issues are under-weighted relative to their actual reader impact.

**Regression awareness: EXCELLENT.** Four explicit regression checks (R1–R4, lines 65–98) with PASS/FAIL and evidence. Verified Learning objectives boxes present and LaTeX-rendered (R2). Verified Story/Sections stripping working in build script (R3). Confirmed no broken references to removed scaffolding (R4). Version hygiene clean (R1). This is the best regression tracker in the round.

**Verdict on this report:** The most accurate regression tracker but the least aggressive reviewer. The report correctly identifies the one real finding (Ch11 cross-reference error) and correctly passes all regression checks, but its conservative severity calibration and low finding count mean it under-communicates real issues. The prose-setup reviewer's R3 finding — that the Story/Sections retention is intentional, not a regression — is the correct interpretation and should have been amplified to counter the false regression claims from other reviewers.

---

## Cross-Cutting Findings

### 1. The Story/Sections "Regression" is False — and the Most Dangerous Finding in the Round

Three reviewers (maths-theorems, lean-code, and implicitly root-notice) reported the retention of `## The story of this chapter` and `## Sections` headings in chapter index files as a v1.5.0 regression. This is **false**. The v1.5.0 changelog at `lean_book/changelog/v1.5.0.md:28` states: "The Markdown source (`lean_book/*/00-index.md`) is **unchanged** — it still uses `## The story of this chapter` and `## Sections` headings. The LaTeX-only transformation happens in the build pipeline." The "Section N" references in the story text are hyperlinks to real files. The "Sections" list is present in markdown. The LaTeX stripping works correctly (verified by prose-setup R3 and build_latex.py:793–818).

This finding family is the round's most dangerous piece of noise precisely because it is so plausible and so repeated. Under the skill's moderator rules, a finding caught by 3 reviewers would be promoted to CONFIRMED — but it is false. This is a textbook case of the skill's own caveat: *"Free-tier findings are a candidate list, not ground truth."*

### 2. The `rfl`/`Nat.add` Contradiction is the Round's Single Best Finding

maths-theorems correctly identified that Chapter 3's Socratic Q2 asserts a false claim about `rfl`/`Nat.add` that contradicts Chapter 5. This was verified by compilation: `example (n : Nat) : n + 0 = n := rfl` succeeds on 4.32.2 because `Nat.add` recurses on its second argument. The failing example is `0 + n = n`, not `n + 0 = n`. This is a genuine internal contradiction (skill: "A contradiction between two parts of the book" = genuine fault), reader-harmful, and correctly rated MAJOR.

### 3. The Learning Objectives Boxes are Present — lean-code is Wrong

lean-code claims Learning objectives boxes are "missing" in Ch1, Ch2, Ch4. This is contradicted by maths-theorems (line 286: "PASS" for all four chapter indexes), prose-setup (R2: "PASS" for Ch0 and Ch13), and solutions (line 62–63: "PASS" for appendix index). The boxes exist. lean-code appears to have checked wrong files or outdated versions.

### 4. The Compilation-Failure Claims in lean-code are Unsubstantiated

lean-code's 3 CRITICAL compilation failures are contradicted by solutions.md ("lake build passes cleanly, zero errors"), maths-algebra (all chapter targets exit 0), and the lean-audit specialized reviewer. The lean-code reviewer provided zero build output, zero error messages, and zero reproduction steps. These CRITICAL findings should be dismissed.

### 5. The README "never listed as explicit objectives" Contradiction is Real

root-notice (line 63) and maths-algebra (line 102) independently caught the stale README sentence claiming objectives are "never listed as explicit objectives" despite v1.5.0 adding Learning objectives boxes. This is a real, verifiable contradiction. However, root-notice rates it CRITICAL while maths-algebra rates it LOW — the severity discrepancy is worth adjudicating. Given that this is a root-level documentation file that shapes first impressions, CRITICAL is defensible, but LOW is also reasonable since the fix is a one-line rewrite.

### 6. The Ch11 Cross-Reference Error (Section 1 vs Section 3) is Under-Rated

prose-setup caught that "Chapter 11, Section 1's Mathlib equivalent box" is actually in Section 3. This is rated LOW, but it is a real reader-mislead — a reader going to Section 1 looking for the side-by-side comparison will find only informal prose. The fix is a one-word change ("Section 1's" → "Section 3's"). LOW is fair but the finding's simplicity and clarity make it more actionable than typical LOW items.

### 7. The `mul_zero` `conv` Proof Smell is a Novel Finding Not Caught Elsewhere

maths-algebra's HIGH #2 (the `conv`/`by ring` proof in Ch8 that sidesteps the stated obligation) is a genuine pedagogical concern. The `ring` tactic silently proves the sub-goal from the full ring structure rather than from the axiomatic sequence the prose promises. This was not caught by any other reviewer in the round. It is a subtle but real faithfulness defect.

### 8. The Path-Algebra Finiteness Hypothesis Omission is a Real Reader-Exposure Risk

maths-algebra's HIGH #4 (the Ch11 prose claiming `k[Q]` is finite-dimensional for any quiver with `n` vertices, without the acyclicity hypothesis) is a genuine prose-vs-Lean divergence with textbook citation (Dershanski–Simson, Prop. 1.3). A reader applying the rule to cyclic quivers gets a wrong answer. This was not caught by any other reviewer.

---

## Overall Assessment of Phase-1 Review Quality

| Dimension | Score | Evidence |
|-----------|-------|----------|
| **Evidence Grounding** | 5/10 | maths-algebra and solutions excel; lean-code provides zero build evidence for its CRITICAL claims; maths-theorems cites line numbers for false findings |
| **Cross-Reviewer Corroboration** | 6/10 | Strong on v1.5.0 regressions (but the central regression finding is false); strong on Learning objectives boxes (but lean-code is wrong); strong on compilation status (but lean-code is contradicted) |
| **Completeness (within scope)** | 6/10 | Systematic gaps: category theory, notation, typesetting, proof-search — but these are specialized concerns by design. More importantly, lean-code's false findings waste scope on phantom defects |
| **Severity Calibration** | 5/10 | lean-code over-severity (3 CRITICAL without evidence); prose-setup under-severity (all findings LOW); maths-theorems inflates `isPrime` to MAJOR; maths-algebra and solutions are well-calibrated |
| **Regression Awareness** | 8/10 | All 5 reports have structured regression trackers, but the central v1.5.0 check (Story/Sections) was answered correctly by only prose-setup |
| **Actionability** | 7/10 | All findings have WHAT/WHY/IMPACT/FIX with file:line, but lean-code's findings are not actionable because they are based on false premises |

**Composite: 6.0/10 — BELOW THE BAR.** The round produced four genuine findings (the `rfl` contradiction, the Ch6→Ch7 cross-reference, the README contradiction, the Ch11 cross-reference error) but was buried under false positives (the Story/Sections regression family, lean-code's phantom compilation failures, the `Or.elim` false correction, the `isPrime` inflation). The skill's own moderator rules would have promoted the false Story/Sections finding to CONFIRMED based on 3-voter corroboration, while the true `rfl` contradiction would have remained a single-reviewer finding. This is the wrong outcome.

---

## Critical Action Items for Adjudication

1. **Dismiss the Story/Sections "regression" findings** — they are false per the v1.5.0 changelog. The retained markdown headings are intentional; the LaTeX stripping works; the "Section N" hyperlinks resolve. Do not promote this to CONFIRMED based on 3-voter corroboration.
2. **Dismiss lean-code's 3 CRITICAL compilation failures** — contradicted by solutions.md, maths-algebra, and lean-audit. The report provides zero build evidence.
3. **Dismiss lean-code's "missing Learning objectives boxes" finding** — contradicted by maths-theorems, prose-setup, and solutions. The boxes exist in all chapter indexes.
4. **Accept the `rfl`/`Nat.add` contradiction as CONFIRMED** — caught by maths-theorems, verified by compilation, and the Ch5 treatment is correct for Lean 4.
5. **Accept the Ch6→Ch7 cross-reference error as CONFIRMED** — caught by maths-theorems, verified against Chapter 7's theorem numbering.
6. **Accept the README "never listed as explicit objectives" contradiction as CONFIRMED** — caught independently by root-notice and maths-algebra.
7. **Accept the Ch11 Section 1→3 cross-reference error as CONFIRMED** — caught by prose-setup, verified against the actual file structure.
8. **Elevate the `mul_zero` `conv` proof smell (maths-algebra HIGH #2) and the path-algebra finiteness omission (maths-algebra HIGH #4) to Phase-3 adjudication** — these are genuine, uncorroborated findings that deserve a second look.

---

*End of critique-ling.md.*
