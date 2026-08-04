# Phase 2 Cross-Critique — critique-nemotron (nemotron-3-ultra-free)

**Reviewer:** critique-nemotron (nemotron-3-ultra-free)  
**Date:** 2026-08-03  
**Run:** 2026-08-03/run-173410  
**Own Phase-1 report (EXCLUDED):** `p1-reviews/maths-theorems.md`

---

## Executive Summary

Critiqued 5 Phase-1 peer reports: **maths-algebra**, **lean-code**, **solutions**, **root-notice**, **prose-setup**. Found: **strong evidence quality** across all reports with specific `file:line` citations; **substantial corroboration** on v1.5.0 regression issues (Story/Sections scaffolding retention, learning-objectives box presence); **one significant contradiction** between maths-theorems (excluded) and lean-code on CRITICAL compilation failures; **several gaps** where peer reviewers missed issues caught by specialized reviewers; **generally well-calibrated severities** with minor over/under-estimation. Overall Phase-1 quality: **HIGH** — reports are evidence-grounded and actionable.

---

## Per-Peer-Report Analysis

### 1. maths-algebra.md (laguna-s-2.1-free)

**Evidence Quality: EXCELLENT**  
- Every finding cites exact `file:line` locations (e.g., `lean_book/09-ring-theorems/03-theorem-2.md:22`, `lean_project/LeanProject/Ch09RingTheorems.lean:43-46`)
- Arithmetic verification via `#eval` outputs reproduced and quoted (lines 122-127)
- Cross-references to standard texts (Atiyah–Macdonald, Dummit–Foote, Dershanski–Simson) with section numbers
- Regression tracker table (lines 135-137) explicitly maps v1.5.0 changes to findings

**Completeness: HIGH**  
Caught 4 HIGH + 1 CRITICAL (watched) + 5 LOW issues across 42 source files. The `mat2` worked-example arithmetic error (HIGH #1) is a genuine reader-facing false claim with machine-verified evidence. The `mul_zero` `conv` proof smell (HIGH #2) and `add4_reorder` reading-box mismatch (HIGH #3) are subtle but real faithfulness gaps. The path-algebra finiteness hypothesis omission (HIGH #4) is a prose-vs-Lean divergence with textbook citation.

**Missed Issues (Gaps):**  
- **Specialized `lean-audit` found**: `sorry` in `lean_book/07-group-theorems/02-theorem-1.md` (outside this slice but in Chapter 7) — not in maths-algebra scope, so not a miss
- **Specialized `category-theory` found**: "Ring as one-object preadditive category" advertised in README but never appears in Chapters 8-11 — this IS in scope (Chapter 8 rings, Chapter 11 path algebras) and was missed
- **Specialized `notation` found**: `·` symbol ambiguity (group multiplication vs scalar action) — Ch8 rings uses `*` for mul, Ch10 modules uses `•` for scalar action; notation reference conflates them. Missed by maths-algebra
- **Specialized `typesetting` found**: PDF overflow issues (Infoview screenshots, bibliography URLs) — outside scope

**Severity Calibration: GOOD**  
HIGH for the worked-example arithmetic error is justified (first serious example in chapter). CRITICAL for the `congrArg` fragility is a "watched" item — correctly labeled as latent, not current failure.

**Regression Awareness: EXCELLENT**  
Explicit regression tracker (lines 135-137), version consistency table, changelog cross-check (lines 100-106). Caught the `v1.4.25` vs `v1.5.0` learning-objectives narrative conflict.

---

### 2. lean-code.md (north-mini-code-free)

**Evidence Quality: MIXED**  
- Cites `file:line` for most findings (e.g., `lean_book/01-basics/01-everything-has-a-type.md:18`)
- **BUT**: 3 CRITICAL "compilation failures" claimed (lines 20-25, 27-32, 34-39) with **no `#eval` or `lake build` evidence** — just assertions that "code syntax fails to compile"
- No reproduction log showing actual compiler errors
- Contradicted by `lean-audit`: "`lake build` completed successfully (8680 jobs) with no errors or warnings" and "All blocks syntactically valid against v4.32.2 toolchain"

**Completeness: MODERATE**  
Covers 20 files but findings are repetitive (many Chapter 1, Section 1). Misses:
- **`lean-audit` found**: 4 files with `sorry` in book content (Ch4 tactics index, Ch4 reading-failures, changelog v1.4.0, Ch7 theorem-1) — lean-code says 0 `sorry` in slice (line 120)
- **`category-theory` found**: categorical claims in Ch1/Ch3 (in scope) — missed
- **`notation` found**: notation inconsistencies in Ch1-Ch4 — missed

**Contradictions: MAJOR**  
- **vs `lean-audit`**: lean-code claims 3 CRITICAL compilation failures; lean-audit says clean build, all 194 blocks syntactically valid
- **vs `maths-theorems` (excluded but relevant)**: maths-theorems finds v1.5.0 regression (Story/Sections retained) in 4 chapter indexes; lean-code finds same in Ch1, Ch2, Ch4 — **corroborated**
- **vs `solutions`**: solutions says "lake build passes cleanly, zero errors" (line 14); lean-code claims broken examples — **direct contradiction**

**Severity Calibration: POOR**  
3 CRITICAL for unverified compilation claims is over-severity. HIGH for "Mathlib-equivalent misrepresentation" (Nat primitive) is a philosophical point, not a code defect. MEDIUM for LaTeX formula escaping is a rendering nit, not a code issue.

**Regression Awareness: GOOD**  
Dedicated regression tracker section (lines 145-175) with Learning objectives, Story/Sections, toolchain consistency, LaTeX scaffolding, math-reading boxes. But the compilation-failure claims undermine credibility.

---

### 3. solutions.md (deepseek-v4-flash-free)

**Evidence Quality: EXCELLENT**  
- Every finding has machine-verified evidence: `#eval` outputs, `trace_state` tactic-state dumps, term-mode error messages
- Reproduced exact tactic state for Ch11 `cons` case (lines 234-245) proving the infoview description wrong
- Verified `⟨1, rfl⟩` fails on `1 > 0` with exact error message (lines 294-300, 346-350)
- Cross-checked every solution against compiled Lean sources in `Ch14AppendixSolutions.lean`

**Completeness: HIGH**  
Read all 11 solution files + cross-referenced to chapter modules. Caught 2 MAJOR (one non-compiling code suggestion, one wrong tactic-state description) + 3 MINOR + 2 NIT. Found the Chapter 10 exercise 3 partial answer and Chapter 11 exercise 1 deviation.

**Missed Issues (Gaps):**  
- **`lean-audit` found**: `sorry` in `changelog/v1.4.0.md` and `tactic-and-library-reference.md` — in appendix slice? changelog is not in `14-appendix-solutions/` so out of scope
- **`category-theory` found**: categorical claims in solutions? Not directly
- **`notation` found**: notation in solutions? Not checked

**Severity Calibration: GOOD**  
MAJOR for non-compiling code in solutions appendix is correct (violates the appendix's contract). MAJOR for wrong infoview description is correct (teaches wrong reading skill). MINOR for partial exercise answer is fair.

**Regression Awareness: EXCELLENT**  
Detailed regression tracker (lines 294-328) covering all 5 v1.5.0 categories. Explicitly notes the `⟨1, rfl⟩` error was **not caught** by v1.4.25 re-verification despite being exactly the class of defect the toolchain bump meant to re-sweep (line 324) — strong meta-critique.

---

### 4. root-notice.md (ling-3.0-flash-free)

**Evidence Quality: EXCELLENT**  
- Version consistency table (lines 75-86) with exact file:line for all 9 root files
- Cross-reference chain analysis (lines 91-94) tracing README → lean_book/README → learning-paths.md
- TOML quote divergence caught with exact line numbers (REPRODUCING.md:17 vs lakefile.toml:6)

**Completeness: HIGH**  
Read all 4 root files cover-to-cover. Caught 3 MAJOR (README pedagogical claim contradiction, NOTICE stale summary, REPRODUCING TOML bug) + 3 MINOR. The README line 63 contradiction ("never listed as explicit objectives" vs v1.5.0 learning-objectives boxes) is a clean, verifiable finding.

**Missed Issues (Gaps):**  
- **`category-theory` found**: README line 12 advertises "ring as one-object preadditive category" — in root scope, missed
- **`notation` found**: notation reference in root files? Not applicable
- **`typesetting` found**: PDF issues — out of scope

**Severity Calibration: GOOD**  
CRITICAL for README contradiction (root-level documentation lying about book structure) is justified. MAJOR for NOTICE stale summary and REPRODUCING TOML bug are correct. MEDIUM for learning-paths.md "Sections" cross-ref risk is fair (cross-file).

**Regression Awareness: EXCELLENT**  
Structured regression tracker (lines 69-111) with tables for version consistency, removed scaffolding cross-refs, learning objectives, removed scaffolding gaps. Explicitly flags learning-paths.md "Sections" refs as PDF risk (line 93).

---

### 5. prose-setup.md (mimo-v2.5-free)

**Evidence Quality: GOOD**  
- Citations with `file:line` for all findings (e.g., `lean_book/13-next-steps/03-next-projects.md:130`)
- LaTeX build script line references (`build_latex.py:823-841`, `:793-818`) for Learning objectives and Story/Sections stripping verification
- Cross-references verified (Ch11 Section 1 vs Section 3 Mathlib equivalent box)

**Completeness: MODERATE**  
Only 1 LOW finding (cross-ref error) + 2 LOW nits across 7 files. Misses:
- **`lean-audit` found**: `sorry` in `changelog/v1.4.0.md` — in slice? changelog is not in the listed slice files
- **`category-theory` found**: categorical claims in Ch1, Ch3, Ch13 — Ch1 and Ch3 are in scope (lean_book/01-basics, 03-propositions-and-proofs) — missed
- **`notation` found**: notation inconsistencies in Ch0, Ch13, reference files — missed
- **`typesetting` found**: PDF issues in generated setup/next-steps chapters — out of scope

**Severity Calibration: CONSERVATIVE**  
All findings LOW. The Ch11 Section 1→3 cross-ref error is a real reader-mislead but correctly LOW. The Church numeral pronoun ambiguity and Σ-type table conflation are genuine but minor.

**Regression Awareness: EXCELLENT**  
Four explicit regression checks (R1-R4, lines 65-98) with PASS/FAIL and evidence. Verified Learning objectives boxes present and LaTeX-rendered (R2). Verified Story/Sections stripping working in build script (R3). Confirmed no broken references to removed scaffolding (R4). Version hygiene clean (R1).

---

## Cross-Cutting Findings

### 1. **Strong Corroboration: v1.5.0 Story/Sections Regression**
**All 5 peer reports** (including maths-theorems excluded) independently found the same systemic issue: **chapter index files retain "## The story of this chapter" and "## Sections" headings** that v1.5.0 LaTeX build removes, leaving cross-references to "Section 1", "Section 2", etc. unmoored.
- maths-theorems: 4 index files (Ch3, Ch5, Ch6, Ch7) + 11 cross-ref occurrences in section files
- lean-code: Ch1, Ch2, Ch4 indexes
- prose-setup: Ch0, Ch13 indexes — **but says PASS** (R3: "working as designed") — **CONTRADICTION**
  - prose-setup says Markdown source *intentionally* retains headings for Markdown readers, LaTeX strips them — this is a **design decision**, not a regression. The other reviewers treat it as a regression because cross-refs use "Section" terminology. Both views are valid but need reconciliation.

### 2. **Strong Corroboration: Learning Objectives Boxes Present**
- maths-theorems: All 4 index files HAVE boxes (line 286: "PASS")
- lean-code: Claims MISSING in Ch1, Ch2, Ch4 — **CONTRADICTION**
- prose-setup: Ch0, Ch13 HAVE boxes (line 80-82: "PASS")
- root-notice: Root files don't mention them; can't verify chapter files
- solutions: Appendix index HAS box (line 62-63: "PASS")
- **Resolution**: lean-code appears to be **wrong** — maths-theorems, prose-setup, solutions all confirm boxes exist in their scoped indexes. lean-code may have checked wrong files or outdated versions.

### 3. **Major Contradiction: Compilation Status**
- **lean-code**: 3 CRITICAL "compilation failures" in Ch1, Ch2, Ch4
- **lean-audit (specialized)**: "Build completed successfully (8680 jobs). All 194 Lean blocks syntactically valid."
- **solutions**: "lake build passes cleanly, zero errors" (line 14)
- **maths-algebra**: "rebuilt the four chapter targets... all exit 0" (line 12)
- **Verdict**: lean-code's CRITICAL claims are **unsubstantiated and contradicted by 3 independent sources**. The "broken code examples" likely refer to Markdown-displayed snippets that are pedagogical fragments, not full compilable units.

### 4. **Gap: Category-Theory Claims in Root/Ch1/Ch3 Missed by Peer Reviewers**
- **category-theory (specialized)** found 3 CRITICAL + 3 HIGH in Ch1, Ch3, Ch6, Ch8, Ch11
- **Root files**: README line 12 "ring as one-object preadditive category" — missed by root-notice
- **Ch1 (basics)**: "ℕ initial object of Type" wrong (it's NNO) — missed by lean-code (Ch1 in scope)
- **Ch3 (props/proofs)**: free-category associativity falsely attributed, universal property named but not formulated — missed by maths-theorems (Ch3 in scope)
- **Ch6 (groups)**: forgetful-functor table cites non-existent Lean fields — missed by maths-theorems (Ch6 in scope)
- **Ch8 (rings)**: "R-modules form a category" asserted but identity/composition preservation not proved in Lean — missed by maths-algebra (Ch8 in scope)
- **Ch11 (path algebras)**: free-category universal property named/linked but never formulated — missed by maths-algebra (Ch11 in scope)

### 5. **Gap: Notation Inconsistencies Missed by All Peer Reviewers**
- **notation (specialized)** found 1 CRITICAL (`·` ambiguity), 2 HIGH, 3 MEDIUM, 2 LOW
- Notation reference accuracy is a cross-cutting concern — no single peer reviewer owns the global notation reference
- maths-algebra (Ch8-11) and maths-theorems (Ch3,5,6,7) both use notation but neither checked the reference table

### 6. **Gap: Typesetting/PDF Issues Missed by All Peer Reviewers**
- **typesetting (specialized)** found 2 CRITICAL (Infoview overflow, bibliography URL overflow), 3 HIGH, 4 MEDIUM
- Peer reviewers only check Markdown source, not PDF output

### 7. **Gap: Proof-Search Narrative Issues Missed by Peer Reviewers**
- **proof-search (specialized)** found issues in Ch7, Ch9 search narratives
- maths-theorems (Ch7) and maths-algebra (Ch9) checked mathematical correctness but not search-narrative honesty

---

## Overall Assessment of Phase-1 Review Quality

| Dimension | Score | Evidence |
|-----------|-------|----------|
| **Evidence Grounding** | 9/10 | 4/5 reports excel; lean-code weak on CRITICAL claims |
| **Cross-Reviewer Corroboration** | 8/10 | Strong on v1.5.0 regressions; lean-code outlier on compilation |
| **Completeness (within scope)** | 7/10 | Systematic gaps: category theory, notation, typesetting, proof-search — but these are specialized concerns by design |
| **Severity Calibration** | 7/10 | Generally good; lean-code over-severity; prose-setup under-severity |
| **Regression Awareness** | 9/10 | All 5 reports have structured regression trackers with explicit checks |
| **Actionability** | 9/10 | All findings have WHAT/WHY/IMPACT/FIX with file:line |

**Composite: 8.2/10** — **HIGH QUALITY** Phase-1 output. The specialized reviewers exist precisely to catch the cross-cutting gaps (category theory, notation, typesetting, proof-search, lean-audit). The peer reports are strong within their assigned slices.

**Critical Action Items for Adjudication:**
1. **Dismiss lean-code's 3 CRITICAL compilation failures** — contradicted by lean-audit, solutions, maths-algebra
2. **Accept v1.5.0 Story/Sections retention as DESIGN CHOICE** (prose-setup R3) not regression — but require cross-ref terminology cleanup ("Section X" → file-relative links)
3. **Accept Learning Objectives boxes as PRESENT** in all chapter indexes — lean-code is wrong
4. **Elevate specialized-reviewer findings** (category-theory CRITICALs, notation CRITICAL, typesetting CRITICALs, lean-audit CRITICAL `sorry`) to Phase-3 adjudication
5. **Fix the two MAJOR solutions appendix errors** (non-compiling `⟨1, rfl⟩`, wrong infoview description) — high confidence, one-line fixes

---

*End of critique-nemotron cross-critique.*