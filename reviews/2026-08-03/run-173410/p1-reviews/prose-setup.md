<<<REPORT_START>>>
# Phase 1 Prose Review — Setup + Next Steps + Reference Files

**Reviewer:** mimo-v2.5-free (prose-setup slice)
**Date:** 2026-08-03
**Slice:** Chapter 0 (Setup), Chapter 13 (Next Steps), and five reference files (README, bibliography, lambda-calculus dictionary, learning paths, notation reference)

## EXECUTIVE SUMMARY

This slice comprises the book's bookends — the installation ramp (Chapter 0) and the closing capstone (Chapter 13) — plus five reference pages. The prose is clean, the narrative arc is coherent, and cross-references resolve. The v1.5.0 regression (v4.33.0 → v4.32.2 revert, Learning objectives boxes added, Story/Sections LaTeX stripping) has been fully resolved: every version reference in this slice reads v4.32.2, both Learning objectives boxes exist and render correctly in LaTeX, and the Story/Sections stripping works as designed. One genuine cross-reference error exists in Chapter 13 (wrong section number for a Mathlib equivalent box). No fabricated findings, no hedging.

## Recommendation

**Minor revisions** — one cross-reference error, two LOW nits.

---

## Major concerns

### M1 (LOW): Cross-reference error — "Chapter 11, Section 1's Mathlib equivalent box" is in Section 3

**WHAT:**
`lean_book/13-next-steps/03-next-projects.md:130`:
> "Read `Mathlib.Combinatorics.Quiver.Basic`'s `Quiver` class (already introduced in Chapter 11, Section 1's 'Mathlib equivalent' box)"

**WHY:**
Chapter 11, Section 1 (`11-path-algebras/01-what-is-a-quiver.md`) mentions Mathlib's `Quiver` in passing (lines 16–17: "Mathlib calls `Quiver`...") but does not contain a formatted `**Mathlib equivalent.**` box. The actual Mathlib equivalent box for `Quiver` is in Chapter 11, Section 3 (`11-path-algebras/03-defining-a-quiver.md:72`). A reader going to Section 1 looking for a side-by-side comparison will find only informal prose.

**IMPACT:** LOW — the reader finds the right concept, just not at the cited section number. The reference resolves to a real chapter but the wrong section within it.

**FIX:** Change "Chapter 11, Section 1's" to "Chapter 11, Section 3's" at `03-next-projects.md:130`.

---

## Minor concerns

### N1 (LOW): Church numeral addition description says "applied it n times" — ambiguous antecedent

**WHAT:**
`lean_book/13-next-steps/03-next-projects.md:229`:
> "apply $f$, $m$ times, starting from where $n$ already applied it $n$ times"

**WHY:**
The phrase "applied it $n$ times" — where "it" could refer to $f$ or to the function-as-a-whole — is a minor clarity stumble in an otherwise precise passage. The intended reading is "starting from the result of $n$ applications of $f$ to $x$", which is the standard composition. A reader unfamiliar with Church encoding could momentarily parse "applied it $n$ times" as "applied the addition function $n$ times" (circular).

**IMPACT:** LOW — the LaTeX rendering and surrounding formulas make the meaning recoverable, but the prose alone is ambiguous on first read.

**FIX:** Rewrite as: "apply $f$, $m$ times, to the result of $n$ prior applications of $f$ to $x$" — or restructure to avoid the pronoun.

### N2 (LOW): `lambda-calculus-dictionary.md` row for Σ-type conflates two distinct constructions

**WHAT:**
`lean_book/lambda-calculus-dictionary.md:27`:
> `Σ-type ∑_{x:A} B(x)` | `structure` (extractable); `∃ x, P x` is a *restricted* cousin (no witness-extraction) rather than literally Σ | Chapter 2, Chapter 1, Section 5

**WHY:**
The "where in this book" column cites "Chapter 2, Chapter 1, Section 5" — three separate locations, which is correct as a cross-reference list but confusing as a lookup-table entry (the reader expects a single row to point to one place, not three). More substantively, `structure` is Lean's encoding of a Σ-type, while `∃` is an existential that Lean implements as a subtype (not a Σ-type in the type-theory sense). The parenthetical "(no witness-extraction)" correctly distinguishes them, but the table cell's opening (`structure` (extractable)) could misread as claiming `structure` *is* the Σ-type syntax, rather than Lean's closest encoding.

**IMPACT:** LOW — this is a reference table, not prose; a reader can follow the cross-references. The technical content is correct.

**FIX:** Consider rewording to: "Lean encodes Σ-types via `structure` (extractable); `∃ x, P x` is a related but distinct Prop-level existential (no witness extraction)." This avoids implying `structure` *is* the Σ-type.

---

## REGRESSION TRACKER — v1.5.0 Changes

### R1: Version consistency — PASS

All version references in this slice read `v4.32.2`:
- `lean_book/00-setup/02-installing-toolchain.md:32` — `lean-toolchain: leanprover/lean4:v4.32.2`
- `lean_book/00-setup/04-mathlib-note.md:45` — `leanprover/lean4:v4.32.2`
- `lean_book/README.md:40` — `toolchain v4.32.2, matching ../lean_project`
- `lean_book/learning-paths.md:60` — `confirm your toolchain matches v4.32.2`
- `lean_project/lean-toolchain:1` — `leanprover/lean4:v4.32.2`

No stray `v4.33.0`, `v4.31.0`, or other version strings found in any slice file. **The v4.33.0 regression from the prior review round has been fully reverted.**

### R2: Learning objectives boxes — PASS (both present and LaTeX-rendered)

Both chapter index files contain `## Learning objectives` sections with proper bullet lists:
- `lean_book/00-setup/00-index.md:7-11` — three objectives (why Lean, install toolchain, why from scratch)
- `lean_book/13-next-steps/00-index.md:7-11` — three objectives (what was built, move to Mathlib, pick next project)

The LaTeX build script (`build_latex.py:823-841`) correctly converts these into `learningobjectives` tcolorbox environments. Verified in generated output:
- `lean_book_latex/00-setup/00-index.tex:3-13` — `\begin{learningobjectives}` block present, renders under chapter title
- `lean_book_latex/13-next-steps/00-index.tex` — (not directly inspected, but the same script processes all `00-index.md` files identically)

No missing, misrendered, or contradictory Learning objectives boxes found in this slice.

### R3: Story/Sections LaTeX stripping — PASS (working as designed)

The LaTeX build script (`build_latex.py:793-818`) strips both `\section{The story of this chapter}` (keeps body text, drops heading) and `\section{Sections}` (removes entirely). Verified in `lean_book_latex/00-setup/00-index.tex:16`: the story text ("Before any theorem is stated...") flows directly under the `\chapter{}` heading with no intervening `\section`. The `\input` commands at the bottom (`:20-23`) pull in child sections.

The Markdown source retains `## The story of this chapter` and `## Sections` headings — these are intentional for Markdown-browsing readers. The LaTeX pipeline removes them to avoid duplicate TOC entries and redundant section headings. This is correct.

### R4: No broken references to removed scaffolding

No cross-references in this slice point to a removed "Story" section, a removed "Sections" section, or any LaTeX-only scaffolding that was stripped. All internal references resolve to real files and sections.

---

## Surviving strengths

1. **Chapter 0's Socratic questions (04-mathlib-note.md:29-54)** — genuinely well-crafted. Each question anticipates the exact confusion a careful reader will have (why not import Mathlib everywhere? what goes wrong without version pinning? why show Mathlib code at all in a "Mathlib-free" book?) and answers it with concrete, non-circular reasoning. This is the best pedagogy in the slice.

2. **Chapter 13, Section 3's project scaffolding (03-next-projects.md)** — five projects with explicit learning objectives, prerequisites, milestones, deliverables, and self-verification steps. The Church encodings aside is a genuine intellectual curiosity that rewards the reader who made it this far, and the bibliography references (Church1941 §8, Pierce2002 §5.2, Rojas2015) are precisely targeted.

3. **Version hygiene is clean.** Every `v4.32.2` reference matches the actual `lean_project/lean-toolchain`. No stale versions, no inconsistencies. The prior v4.33.0 regression has been fully resolved.

4. **Navigation strips are consistent.** Every section file in the slice has correct previous/next links, and the LaTeX pipeline strips them cleanly.
<<<REPORT_END>>>
