# Root-Notice Adversarial Review — Phase 1

**Slice:** README.md, NOTICE.md, CONTRIBUTING.md, REPRODUCING.md
**Reviewer:** ling-3.0-flash-free (adversarial-book-reviewer skill)
**Date:** 2026-08-03

---

## Summary

Read all four root notice files cover-to-cover. Version references are internally consistent — every mention of the Lean toolchain pins to `v4.32.2`, with no stray `v4.33.0` or other version strings. Cross-references to adjacent files (NOTICE.md, REPRODUCING.md, CONTRIBUTING.md, lean_project/, lean_book/) all resolve on disk. However, the README makes a factual claim about the book's pedagogical structure that is now contradicted by the v1.5.0 addition of Learning objectives boxes, and the NOTICE.md carries a stale summary of a prior review round that no longer reflects the current state. The REPRODUCING.md also presents a TOML snippet with formatting that diverges from the actual `lakefile.toml`. No references to the removed LaTeX "Story" or "Sections" scaffolding appear in these root files, but the README's description of "chapter narratives" as a "story" echoes the removed LaTeX section and could mislead PDF readers.

## Recommendation

Minor revisions — the version consistency is clean and the cross-reference network is intact, but the README's pedagogical-description section contains a claim that is now factually wrong (objectives are "never listed as explicit objectives" despite the v1.5.0 Learning objectives boxes), and the NOTICE.md carries a stale review-round summary.

---

## Major concerns

### 1. README.md: "never listed as explicit objectives" contradicts v1.5.0 Learning objectives boxes

- **WHAT:** README.md line 63 states that the book's chapter narratives "never listed as explicit objectives, always embedded in the narrative flow."
- **WHY:** The v1.5.0 release added a "Learning objectives" box after every chapter title. The README's claim that objectives are "never listed as explicit objectives" is now factually wrong. A reader relying on this description would expect no Learning objectives boxes and would be surprised to find them, undermining trust in the README as an accurate guide to the book's current structure.
- **IMPACT:** Any reader who uses the README to understand the book's pedagogical features gets a wrong answer about a structural feature that is now present in every chapter. This is a broken promise between the root-level documentation and the actual book content.
- **FIX:** Rewrite line 63 to acknowledge the Learning objectives boxes, e.g.: "Each chapter opens with a story framing the cognitive journey ahead (remember → understand → apply → analyze → evaluate → create), and now renders a Learning objectives box after the chapter title; it closes with a key-points recap before its exercises."

### 2. README.md: "Chapter narratives" description echoes the removed LaTeX "Story" section

- **WHAT:** README.md lines 59–63 describe "Chapter narratives" as each chapter opening with "a story framing the cognitive journey ahead." The v1.5.0 changelog (`lean_book/changelog/v1.5.0.md`) confirms that the LaTeX build removed the `\section{The story of this chapter}` heading from every chapter driver, and the "Sections" section entirely.
- **WHY:** The README's use of "story" to describe the chapter narrative echoes the removed LaTeX "Story" section heading. PDF readers who no longer see a distinct "Story" section in the rendered output may be confused by the README's framing. The Markdown source still contains the narrative content, but it no longer appears under a labeled "Story" section in the PDF — it flows directly under the `\chapter{}` title.
- **IMPACT:** A PDF reader following the README's description of "chapter narratives" as a "story" would look for a distinct Story section in the chapter and not find one, wasting time and potentially missing the narrative content that now flows without a section heading.
- **FIX:** Either (a) update the README to clarify that the narrative content now flows directly under the chapter title without a distinct "Story" section heading in the PDF, or (b) change the word "story" to "narrative framing" to avoid evoking the removed LaTeX section label.

### 3. NOTICE.md: Stale summary of prior adversarial review round

- **WHAT:** NOTICE.md line 53 states: "surviving findings (three critical, one high, four low/medium — version pinning, audience promise, uncompiled appendix code, and minor consistency items) were all fixed and are recorded in `reviews/2026-08-02/`."
- **WHY:** The "version pinning" finding from that round is now resolved — all version references in these root files consistently read `v4.32.2`. However, the NOTICE.md does not update the summary to reflect that the version-pinning concern has been addressed. A reader checking whether version pinning is still an open issue would see it listed as a surviving finding from the prior round, even though it has been fixed.
- **IMPACT:** A reader (or a future reviewer) could mistakenly believe that version pinning is still an unresolved issue, leading to unnecessary re-investigation or redundant fix attempts.
- **FIX:** Update the summary on line 53 to remove "version pinning" from the list of surviving findings, or replace the entire summary with a current-status statement that reflects which findings from the prior round remain open.

---

## Minor concerns

### 4. REPRODUCING.md: TOML snippet shows `rev = v4.32.2` without quotes, diverging from actual lakefile.toml

- **WHAT:** REPRODUCING.md lines 16–18 present `rev = v4.32.2` (without quotes) inside an inline-code block as the intended lakefile.toml content. The actual `lean_project/lakefile.toml` (line 6) contains `rev = "v4.32.2"` (with quotes).
- **WHY:** In TOML, string values must be quoted. `rev = v4.32.2` without quotes is not valid TOML — the dots in `v4.32.2` are not permitted in bare string values. A reader reproducing the setup from the REPRODUCING.md prompt would write invalid TOML, causing `lake` to fail to parse the file.
- **IMPACT:** A reader following the reproduction prompt step-by-step would encounter a TOML parse error on first build, stalling the entire reproduction process. This is a subtle but real reproduction blocker.
- **FIX:** Change the inline code on line 17 from `rev = v4.32.2` to `rev = "v4.32.2"` to match the actual file contents.

### 5. README.md: No mention of Learning objectives boxes anywhere in the root files

- **WHAT:** None of the four root files (README.md, NOTICE.md, CONTRIBUTING.md, REPRODUCING.md) mention the v1.5.0 Learning objectives boxes that now appear after every chapter title.
- **WHY:** The Learning objectives boxes are a new structural feature of the book. The root-level documentation — which is the first thing a new reader encounters — provides no notice of this feature. A reader who wants to understand the book's pedagogical apparatus has no way to discover Learning objectives boxes from the root files alone.
- **IMPACT:** New readers may not realize that the book now includes Learning objectives boxes, missing a potentially useful navigation and study aid. This is a documentation gap rather than a broken reference.
- **FIX:** Add a note about Learning objectives boxes to the README.md pedagogical-approach section (around line 54–101) and/or to the NOTICE.md.

### 6. CONTRIBUTING.md: No version reference for the book itself (v1.5.0)

- **WHAT:** CONTRIBUTING.md does not mention the current book version (`v1.5.0`) anywhere. The only version reference in CONTRIBUTING.md is the toolchain version (implicit via `lean_project/lean-toolchain`).
- **WHY:** The changelog (`lean_book/changelog/README.md`) lists `v1.5.0` as the current release, but CONTRIBUTING.md — which is the entry point for contributors — provides no version context. A contributor unfamiliar with the release history would not know which version they are contributing to.
- **IMPACT:** Low. Contributors can infer the version from the changelog, but the absence is a minor documentation gap.
- **FIX:** Optionally add a one-line note in CONTRIBUTING.md referencing the current book version, e.g.: "This repository corresponds to book version v1.5.0."

---

## REGRESSION TRACKER — v1.5.0 changes

The following regression checks were performed specifically for issues introduced by the v1.5.0 changes (toolchain pinned to v4.32.2 everywhere; LaTeX removed "Story" and "Sections" sections; Learning objectives boxes added after every chapter title).

### Version consistency (v4.32.2 everywhere)

| File | Status | Notes |
|------|--------|-------|
| `lean_project/lean-toolchain` | ✅ | `leanprover/lean4:v4.32.2` |
| `lean_project/lakefile.toml` | ✅ | `rev = "v4.32.2"` for mathlib |
| `lean_project/README.md` | ✅ | `v4.32.2` on lines 3, 26 |
| `README.md` | ✅ | `v4.32.2` on line 108 |
| `NOTICE.md` | ✅ | `v4.32.2` on lines 10, 43 |
| `REPRODUCING.md` | ✅ | `v4.32.2` on lines 15, 17–18 |
| `lean_book/README.md` | ✅ | `v4.32.2` on line 40 |
| `lean_book/00-setup/02-installing-toolchain.md` | ✅ | `v4.32.2` on line 32 |
| `lean_book/00-setup/04-mathlib-note.md` | ✅ | `v4.32.2` on line 45 |
| `lean_book/learning-paths.md` | ✅ | `v4.32.2` on line 60 |

No version references to `v4.33.0`, `v4.31.x`, or any other version string were found in any root file. **No version-regression findings.**

### Broken cross-references to removed LaTeX "Story" / "Sections" sections

- **Root files (README.md, NOTICE.md, CONTRIBUTING.md, REPRODUCING.md):** No direct references to the removed "Story" or "Sections" LaTeX sections. ✅
- **Cross-reference chain (README.md → lean_book/README.md → lean_book/learning-paths.md):** `lean_book/learning-paths.md` contains four references to "Sections" (lines 16, 17, 60–61, 76–77) that describe chapter subdivisions. Since the v1.5.0 LaTeX build removed the `\section{Sections}` section entirely, PDF readers following these navigation instructions would encounter a structure that no longer exists as a labeled section in the rendered output. The Markdown source still has these section headers, so the HTML/browser version is unaffected. **This is a cross-reference risk for PDF readers that originates in a file outside the root slice but is reachable from README.md.**
- **No "Story" section references** in any root file or in `lean_book/README.md`. The README.md's use of "story" to describe chapter narratives (line 59–63) echoes the removed LaTeX section but does not reference it by name.

### Learning objectives boxes (new in v1.5.0)

- **Root files:** None of the four root files mention Learning objectives boxes. The README.md line 63 explicitly states objectives are "never listed as explicit objectives," which contradicts their new presence. See Major concern #1 above.
- **Chapter files:** Not in the root slice; cannot verify from these files whether Learning objectives boxes are present, correctly rendered, or consistent with chapter body content. This requires a separate pass over the `lean_book/*/00-index.md` files.

### Gaps where removed scaffolding leaves exercises or theorems unmoored

- Not verifiable from root files alone. The removal of the "Story" and "Sections" LaTeX sections could leave exercises or theorems that were previously anchored to those sections now floating without structural context. This requires checking the chapter-level Markdown and the generated LaTeX drivers.

### Summary of regression findings

| Category | Finding | Severity |
|----------|---------|----------|
| Version consistency | All clean — no stray versions | — |
| Removed "Story"/"Sections" cross-refs | learning-paths.md "Sections" refs broken for PDF; no direct root-file references | MEDIUM (cross-file) |
| Learning objectives boxes | README.md contradicts their existence (line 63); no root file mentions them | CRITICAL (README.md) |
| Removed scaffolding gaps | Not verifiable from root files | Requires chapter-level pass |
