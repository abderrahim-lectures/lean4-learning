<<<REPORT_START>>>

# Adversarial Book Review: Lean for Working Algebraists (Chapters 0 & 13 + Reference Files)

## Summary

This review covers 15 files comprising Chapter 0 (Setup), Chapter 13 (Next Steps), and five reference files (README, bibliography, lambda-calculus dictionary, learning paths, notation reference). The book promises to teach Lean 4 to mathematicians with "no programming background" using abstract algebra as the vehicle, building everything from scratch without Mathlib through Chapter 11. A v1.4.25/v1.5.0 regression introduced two major changes: (1) toolchain bump v4.31.0→v4.32.2 with docs incorrectly stating v4.33.0, and (2) explicit Bloom-verb learning objectives removed and replaced with narrative "story of this chapter" sections. All five personas find genuine faults — not preferences — that mislead readers, break explicit promises, or contain factual errors.

## Recommendation

**Major revisions** — The version mismatch (v4.33.0 in docs vs v4.32.2 actual) is a CRITICAL factual error that breaks reproducibility. The narrative sections in Ch 0 and Ch 13 do not adequately replace removed learning objectives (cognitive progression gaps). Multiple audience-promise violations exist for "no programming background" readers. The "Aside: Church encodings" in Ch 13 is structurally incoherent.

---

## Major Concerns

### CRITICAL: Version mismatch — docs claim v4.33.0, actual toolchain is v4.32.2
**WHAT:** Multiple files state toolchain `v4.33.0` matching `../lean_project`:
- README.md:40: "Code blocks are valid Lean 4 (toolchain `v4.33.0`, matching `../lean_project`)"
- 00-setup/02-installing-toolchain.md:29: `lean-toolchain: leanprover/lean4:v4.33.0`
- 00-setup/04-mathlib-note.md:45: `leanprover/lean4:v4.33.0`
- learning-paths.md:60: "confirm your toolchain matches `v4.33.0`"

**WHY:** The actual `lean_project/lean-toolchain` reads `leanprover/lean4:v4.32.2`. Mathlib v4.33.0 is not released (per AGENT_HANDOFF.md). A reader following the docs will pin v4.33.0, fail to compile, and lose trust.

**IMPACT:** Every reader who tries to reproduce the build gets a broken environment. The book's central claim — "every code block verified with `lake build`" — becomes unreproducible.

**FIX:** Change all four occurrences to `v4.32.2`. Add a disclaimer if docs intentionally target v4.33.0: "Documentation targets v4.33.0; companion project uses v4.32.2 (current stable)."

---

### CRITICAL: "No programming background" promise broken by jargon in Setup chapter
**WHAT:** README.md:7 promises "We assume no programming background." But:
- 00-setup/02-installing-toolchain.md:10-11: "(Readers familiar with `uv`'s Python-version management (`uv python install`) will recognize elan as playing the same role for Lean.)" — assumes Python/`uv` knowledge.
- 00-setup/02-installing-toolchain.md:13-17: "search 'leanprover elan install' or use a package manager" — no direct URL, assumes search literacy.
- 00-setup/03-editor.md:7-14: Assumes VS Code, extensions, "inline goal state," "jump-to-definition," "red squiggles," "autocomplete" — all programmer jargon.
- README.md:27-38: References Mermaid, MathJax/KaTeX, Pandoc, VS Code extensions — inaccessible to non-programmers.

**WHY:** The Setup chapter is the reader's first experience. Using unexplained programmer terminology violates the explicit audience promise and strands the promised reader immediately.

**IMPACT:** The "no programming background" reader cannot complete Setup. They either quit or conclude the book is not for them.

**FIX:** Rewrite Setup chapter with zero jargon. Define every term (VS Code, extension, version manager, package manager) inline. Provide direct URLs (https://lean-lang.org/lean4/doc/quickstart.html). Add a "Glossary for non-programmers" box.

---

### HIGH: Ch 0 and Ch 13 narrative sections fail to replace removed Bloom learning objectives
**WHAT:** v1.4.25 removed explicit "Learning objectives" (Bloom verbs: remember, understand, apply, analyze, evaluate, create) from all chapter indexes, replaced with "The story of this chapter" narrative. v1.5.0 LaTeX removed "Story" and "Sections" sections entirely.

**Ch 0 story (00-setup/00-index.md:7-13):** "Before any theorem is stated, three questions must be answered: *why* Lean, *can* you run it, and *why* this book builds everything by hand... Each section below addresses one of them in turn."  
→ Cognitive levels: remember (why Lean), understand (can you run it), understand (why from scratch). **Missing: apply, analyze, evaluate, create.** No measurable outcomes.

**Ch 13 story (13-next-steps/00-index.md:7-19):** "Thirteen chapters have built every group, ring, and path algebra from scratch... This closing chapter asks three questions in turn. First, what has actually been constructed... Second, how does that... translate into Mathlib's real `class`-based idiom... Third, what next project... extends the material?"  
→ Cognitive levels: remember (what we built), analyze/evaluate (translate to Mathlib), apply/create (next projects). **Better but incomplete:** "Solutions" section (4) is not in the three-question frame. No explicit "you will be able to" outcomes.

**WHY:** Narrative framing is not a substitute for measurable learning objectives. The cognitive progression (remember→understand→apply→analyze→evaluate→create) has gaps in Ch 0 and is implicit/not assured in Ch 13.

**IMPACT:** Readers cannot self-assess readiness. Instructors cannot map chapters to outcomes. The pedagogical scaffolding the book explicitly designed for (Bloom verbs) is gone with no adequate replacement.

**FIX:** Restore explicit learning objectives in each chapter index, or enhance "Story" sections with implicit-but-complete cognitive progression markers (e.g., "By the end of this chapter you will have installed Lean, run your first `#eval`, and explained why version pinning matters").

---

### HIGH: "Mathlib-free by design" claim is false — project depends on Mathlib
**WHAT:** README.md:63-65: "This book is, and remains, Mathlib-free by design: every group, ring, and path algebra is built from scratch." 00-setup/04-mathlib-note.md:7-11: "This book builds groups, rings, and path algebras **from scratch**, deliberately, without importing Mathlib."

**WHY:** The `lean_project` depends on Mathlib (v4.32.2) for the "Mathlib equivalent" boxes from Chapter 6 onward (00-setup/04-mathlib-note.md:31-33). The book is not Mathlib-free — it uses Mathlib as a parallel track.

**IMPACT:** A reader who wants a genuinely Mathlib-free experience (e.g., to understand foundations without any library contamination) is misled. The claim is technically false.

**FIX:** Change to "Mathlib-free *in the main pedagogical track* by design" or "Mathlib-free through Chapter 5; Mathlib appears only in labeled 'Mathlib equivalent' boxes from Chapter 6 onward."

---

### HIGH: Ch 13 "Aside: Church encodings" is structurally incoherent
**WHAT:** 13-next-steps/03-next-projects.md:181-260 — 80 lines on Church booleans/numerals, λ-calculus, β-reduction, with references to bibliography. This appears in "Suggested next projects" but is not a project — it's a theoretical aside with no deliverable, no milestones, no self-verification.

**WHY:** It violates the section's own structure (Projects 1–5 all have: Learning objectives, Prerequisites, Milestones, Deliverable, Self-verification). The Aside has none of these. It assumes λ-calculus knowledge the book never teaches (only referenced in optional "Mathematical reading" boxes). It breaks the chapter's narrative arc.

**IMPACT:** Reader expects a 6th project, gets a random theory dump. Undermines the chapter's credibility as a "next steps" guide.

**FIX:** Move to an appendix or separate "Optional: Theoretical foundations" chapter. Or remove — it serves no pedagogical purpose in a "next projects" section.

---

### MEDIUM: Socratic questions in 04-mathlib-note.md repeat main text (redundancy)
**WHAT:** 00-setup/04-mathlib-note.md:29-55 contains three Socratic Q&A pairs that re-explain points already made in lines 7-27 (why not import Mathlib from page one, why pin toolchain, why show Mathlib at all).

**WHY:** Same point made twice, worse the second time (Q&A format adds no new information). Violates Editor persona: "redundancy (same point made three times, worse each time)."

**IMPACT:** Wastes reader time; signals lack of editorial discipline.

**FIX:** Delete the Socratic questions or integrate their content into the main text as inline clarifications.

---

### MEDIUM: Navigation strips inconsistent across Setup files
**WHAT:** Top vs bottom navigation strips differ:
- 00-setup/04-mathlib-note.md top (line 3): `[← Editor](03-editor.md) | [Index](00-index.md)` (2 links)
- 00-setup/04-mathlib-note.md bottom (lines 60-62): `[← Editor](03-editor.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 1: Basics →](../01-basics/00-index.md)` (4 links)
- Other files have similar inconsistencies.

**WHY:** Copy-paste drift. Reader gets different navigation options depending on scroll position.

**IMPACT:** Minor confusion, but signals poor quality control.

**FIX:** Standardize all navigation strips (top and bottom) to identical 4-link format.

---

### MEDIUM: learning-paths.md misrepresents path equivalence
**WHAT:** learning-paths.md:40-43: "Dashed arrows are the two named paths below that actually skip material outright... the other two named paths change *how* a chapter is read, not which chapters are read, so they have no edge of their own." But five paths are listed (lines 55-93), not two. Three paths ("already know algebra," "formal foundations first," "see real math fast") are presented as equal alternatives but have no graph representation.

**WHY:** The dependency graph only models chapter-skipping paths, not reading-strategy paths. The text presents all five as "named paths" with equal weight.

**IMPACT:** Reader cannot visually compare paths. The graph is misleading about the actual structural options.

**FIX:** Either add all five paths to the graph with distinct edge styles, or clarify in text that only two paths skip chapters.

---

## Minor Concerns (LOW)

1. **00-setup/01-why-lean.md:13-15** — "These topics are rich enough to be interesting, but simple enough to build from scratch." Unsubstantiated claim about path algebras' simplicity. No evidence provided. Hostile reader: "path algebras of quivers are not simple."

2. **00-setup/02-installing-toolchain.md:13-17** — "search 'leanprover elan install'" — no direct URL. First-time reader needs clickable link: https://lean-lang.org/lean4/doc/quickstart.html

3. **00-setup/04-mathlib-note.md:45** — References `leanprover/lean4:v4.33.0` in Socratic Q3 explanation (version mismatch, see CRITICAL above).

4. **13-next-steps/01-what-we-built.md:22-25** — Claims `simp` used only in Ch 6 and Ch 11 with named lemmas. No way to verify without full book. But the absolutist framing ("Every other proof avoids `simp` entirely") is fragile.

5. **13-next-steps/02-moving-to-mathlib.md:12-13** — Loogle links (Group, Ring, Module) — should be verified as live. Not tested in this review.

6. **13-next-steps/03-next-projects.md:21-22** — "Chapter 5 appendix's `MyGroup` (exercise 2)" — no "Chapter 5 appendix" exists in TOC. Forward reference to non-existent structure.

7. **bibliography.md:69** — Thompson1991 link documented as broken (TLS handshake failure). Should be fixed or replaced with working mirror.

8. **bibliography.md:71-72** — TPIL4 entry documents that book's original links 404. The fix should be in chapter files, not just noted in bibliography.

9. **README.md:75-102** — "Editorial passes" meta-history belongs in CONTRIBUTING.md or changelog, not reader-facing README.

10. **lambda-calculus-dictionary.md:36-40** — Notes about tactics and elaboration are duplicated from Chapter 1 references. Redundant.

11. **notation-reference.md:13-19** — Disclaimer about "two related pages" covering excluded notation — this meta-commentary clutters a reference page.

---

## Verification Log

| Check | Status | Evidence |
|-------|--------|----------|
| Toolchain version consistency | **FAIL** | 4 files claim v4.33.0; `lean_project/lean-toolchain` = v4.32.2 |
| Audience promise ("no programming background") | **FAIL** | Setup chapter uses `uv`, VS Code, extensions, package manager, Mermaid, Pandoc jargon |
| Ch 0 narrative replaces Bloom objectives | **FAIL** | Story covers remember/understand only; missing apply/analyze/evaluate/create |
| Ch 13 narrative replaces Bloom objectives | **PARTIAL** | Story covers remember/analyze/apply/create but misses evaluate; Solutions section unaccounted |
| "Mathlib-free by design" claim | **FAIL** | Project depends on Mathlib v4.32.2 for "Mathlib equivalent" boxes |
| Ch 13 Aside structural coherence | **FAIL** | Aside lacks project structure (objectives, milestones, deliverable, verification) |
| Bibliography link health | **FAIL** | Thompson1991 TLS failure documented; TPIL4 404s documented |
| Navigation strip consistency | **FAIL** | Top/bottom strips differ in link count across Setup files |
| Learning paths graph completeness | **FAIL** | Graph shows 2 dashed paths; text describes 5 paths |
| Socratic questions redundancy | **CONFIRMED** | 04-mathlib-note.md Q&A repeats main text points 1-3 |
| Loogle links in 02-moving-to-mathlib.md | **UNTESTED** | Not verified in this review (external) |
| Chapter 5 appendix reference | **FAIL** | No appendix in Chapter 5 TOC; "exercise 2" unverifiable |

---

## Surviving Strengths

1. **13-next-steps/02-moving-to-mathlib.md:43-99** — The "Two theorems for free" section is exceptional. It demonstrates concrete payoff (ZMod 3 as Field, Lagrange's theorem on S₃) using only objects the book already built. This genuinely withstood all four personas: specific, verifiable, motivating, and pedagogically sound.

2. **13-next-steps/03-next-projects.md:13-179** (Projects 1–5) — Each project follows a rigorous template (objectives, prerequisites, milestones, deliverable, self-verification). They are genuinely open, well-scoped, and build directly on book material. The Hostile Reader finds no fluff; the First-Time Reader (at Ch 13) has all prerequisites met.

3. **00-setup/00-index.md and 13-next-steps/00-index.md** — The "Story of this chapter" + "Sections" structure is clear and navigable in Markdown. The narrative framing, while incomplete for cognitive progression, is honest about the chapter's purpose.

4. **lambda-calculus-dictionary.md and notation-reference.md** — Clean, accurate lookup tables. The dictionary correctly distinguishes native Lean (`Bool`, `Nat`) from Church encodings. The notation reference correctly maps math symbols to Lean syntax with chapter citations.

5. **bibliography.md** — Consolidated, consistent citation style with anchor links. The notes on *why* each source is cited at specific spots (though not visible in this file alone) is a strength noted in README.md:93-96.

---

## Surviving Strengths

1. **13-next-steps/02-moving-to-mathlib.md:43-99** — The "Two theorems for free" section is exceptional. It demonstrates concrete payoff (ZMod 3 as Field, Lagrange's theorem on S₃) using only objects the book already built. This genuinely withstood all four personas: specific, verifiable, motivating, and pedagogically sound.

2. **13-next-steps/03-next-projects.md:13-179** (Projects 1–5) — Each project follows a rigorous template (objectives, prerequisites, milestones, deliverable, self-verification). They are genuinely open, well-scoped, and build directly on book material. The Hostile Reader finds no fluff; the First-Time Reader (at Ch 13) has all prerequisites met.

3. **00-setup/00-index.md and 13-next-steps/00-index.md** — The "Story of this chapter" + "Sections" structure is clear and navigable in Markdown. The narrative framing, while incomplete for cognitive progression, is honest about the chapter's purpose.

4. **lambda-calculus-dictionary.md and notation-reference.md** — Clean, accurate lookup tables. The dictionary correctly distinguishes native Lean (`Bool`, `Nat`) from Church encodings. The notation reference correctly maps math symbols to Lean syntax with chapter citations.

5. **bibliography.md** — Consolidated, consistent citation style with anchor links. The notes on *why* each source is cited at specific spots (though not visible in this file alone) is a strength noted in README.md:93-96.

---

<<<REPORT_END>>>