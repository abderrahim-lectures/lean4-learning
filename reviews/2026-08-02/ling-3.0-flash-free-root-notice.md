# Reviewer: ling-3.0-flash-free (adversarial-book-reviewer skill)
# Slice: root-notice (README.md, NOTICE.md, CONTRIBUTING.md, REPRODUCING.md)
# Date: 2026-08-02

<<<REPORT_START>>>
## 1. Summary

The four root files are clean on toolchain version numbers (all live references read `v4.32.2`, consistent with `lean_project/lean-toolchain`), but they actively mislead on two fronts: the book's central audience promise and the scope of its "verified" guarantee. README.md asserts that **every** Lean snippet and **every** code block is ported one-module-per-chapter and compiled with `lake build`, yet Chapter 12 ("Working efficiently in Lean") contains real Lean code (`example (a b : Nat) (h : a = b) : b = a := by exact?` with a comment `verified on this book's toolchain to be …` at line 33) with **no** `Ch12*` module in `lean_project/`. Worse, REPRODUCING.md's step 2 promises a reader "who already have programming experience" and instructs cutting "beginner-programmer explanations," while README.md and lean_book/README.md promise "no prior exposure to Lean, formal logic, or programming" — a direct, un-reconciled contradiction of the book's opening sales pitch. REPRODUCING.md also instructs using "the latest stable toolchain" instead of the pinned `v4.32.2`, so the reproduction trail doesn't reproduce the shipped book.

## 2. Recommendation

**Major revisions.** The documentation mis-describes its own deliverable (missing Ch12 module), contradicts itself on the core audience premise, and its reproduction instructions drift from the pinned toolchain. None of these are typos; all are reader-facing promises that outrun evidence.

## 3. Major concerns

### Persona 1 — Fact-Checker

**(LOW) — Toolchain version hygiene is actually fine within scope.**
- **What:** No stale `v4.31.0` reference appears in README.md, NOTICE.md, CONTRIBUTING.md, or REPRODUCING.md. The only live version claims — README.md:108 (`v4.32.2`) and NOTICE.md:10/NOTICE.md:43 (`leanprover/lean4:v4.32.2` / "pinned to the `v4.32.2` tag") — match `lean_project/lean-toolchain:1`. The v1.4.25 changelog (lean_book/changelog/v1.4.25.md:7-23) records bumping these exact files.
- **Why:** (None — this is a confirming clean result.)
- **Fix:** No change needed here; file is correct. (Stale `v4.31.0` remains only in historical changelog entries and the generated `lean_book_latex/` artifact, both expected.)

### Persona 2 — Hostile Reader

**(CRITICAL) Audience contradiction on programming background.**
- **What:** README.md:34-37 — "...for readers with a background in abstract algebra and basic category theory ... and **no prior exposure to Lean, formal logic, or programming**." vs REPRODUCING.md:31-34 (step 2) — "The audience is mathematicians with a category-theory background who **already have programming experience** — cut beginner-programmer explanations (what a function is, what a compiler does)." REPRODUCING.md:126-129 (step 10) later re-flips to "zero prior exposure to programming."
- **Why:** The README's hook sells the book to non-programmers, but the build instructions that produced the book explicitly told the author to *cut* explanations for readers who don't know what a function is. The later "accessibility pass" (Programmer's corner, logic recap) is presented as remediation, but step 2's directive is never retracted — so it is impossible to tell whether the "no programming background" reader was ever actually served.
- **Impact:** Wrong self-selection (non-programmers buy in then stall on omitted basics); contributors get three contradictory audience specs across README, CONTRIBUTING, and REPRODUCING; the accessibility add-ons read as damage control, not design.
- **Fix:** Pick one audience and stamp it everywhere. Either (a) adopt "reader has programming experience" everywhere and delete "no prior exposure to programming" from README.md:37 and lean_book/README.md:7, or (b) keep "no programming background" and rewrite REPRODUCING.md step 2 to match, making the beginner-friendly remediations complete and explicit.

**(HIGH) "Every code block … one module per chapter" is false for Chapter 12.**
- **What:** README.md:107-110 — "a companion Lean 4 project (toolchain `v4.32.2`) containing **every code block from the book, ported into one module per chapter** and verified to compile with `lake build`."
- **Why:** Chapter 12 ("Working efficiently in Lean") is a chapter and contains real, runnable Lean (`lean_book/12-working-efficiently/01-search-tactics.md:30-36`: `example (a b : Nat) (h : a = b) : b = a := by exact?` with a comment `verified on this book's toolchain to be …` at line 33). The `lean_project/LeanProject/` directory contains `Ch01`–`Ch11` plus `Ch13CapstoneMathlib.lean` — and **no** `Ch12*` module. The file-level promise is directly falsified.
- **Impact:** Contributors following the README will look for a Ch12 module and find nothing; the `exact?`/`omega`/`norm_num` examples (the chapter whose whole point is trusted tool output) are not compiler-verified despite asserting they are.
- **Fix:** Add `lean_project/LeanProject/Ch12WorkingEfficiently.lean` and verify it with `lake build`; or downgrade the claim to "Chapters 1–11" to match lean_book/README.md:41.

**(HIGH) Verification-scope inconsistency between the two READMEs.**
- **What:** README.md:99 — "every Lean snippet in the book (**main text and solutions**) is verified against the pinned toolchain." vs lean_book/README.md:41 — "Every code block in **Chapters 1–11** has been ported into `../lean_project/LeanProject/` … and verified with `lake build`."
- **Why:** The root README guarantees compilation of *all* snippets (including Ch 12, Ch 13, and the solutions appendix); the in-tree README honestly scopes verification to Ch 1–11. There is no `Ch12` module, and no from-scratch `Ch13` module, so the broader claim is unsupported.
- **Impact:** The "verified, not merely written" guarantee — the book's strongest credibility claim — is overstated and internally denied by its own companion README.
- **Fix:** Align both READMEs to the actual compiled scope (Ch 1–11, plus the Mathlib track ch. 6–11 and Ch 13 capstone) and explicitly enumerate which chapters' snippets are *not* compiled into `lean_project/`.

**(MEDIUM) Reproduction steps use "latest stable toolchain," not the pinned version.**
- **What:** REPRODUCING.md:15-17 — "a Lean 4 project using **the latest stable toolchain** … `lean-toolchain` pinned to **the latest release**." vs shipped `lean_project/lean-toolchain:1` (`leanprover/lean4:v4.32.2`) and NOTICE.md:10.
- **Why:** "Latest release" is a moving target and will not yield the v4.32.2/Mathlib-v4.32.2 build the book was verified against; following the steps produces a different toolchain. REPRODUCING.md:7 promises this sequence "should reproduce a book with the same … constraints" — it will not.
- **Impact:** Reproducers hit version drift / possible compile failures; the "follow in order to reproduce" promise is not met.
- **Fix:** Replace "latest stable toolchain"/"latest release" with an explicit pin to `leanprover/lean4:v4.32.2` and Mathlib `rev = v4.32.2`.

### Persona 3 — Editor

**(MEDIUM) The reproduction doc's own structure denies its linear narrative.**
- **What:** REPRODUCING.md:6-7 — "following it in order … should reproduce a book" (numbered 1–13). Yet REPRODUCING.md:22-23 (step 2) says "sequence these as separate follow-up instructions, not one prompt," and steps 10, 11, 12, 13 are each prelabeled "a later session"/"a further session."
- **Why:** The format implies sequential, single-pass reproducibility while the prose admits multi-session, non-linear execution.
- **Impact:** A reader trying to automate reproduction gets a misleading shape.
- **Fix:** Drop "following it in order," label each step with its session boundary, or render the steps as a dependency DAG.

**(LOW) README audience line is internally redundant / weakly scoped.**
- **What:** README.md:34-37 restates the audience as "abstract algebra and basic category theory (objects, morphisms, composition, functors)" — identical wording already in lean_book/README.md:5-9 and REPRODUCING.md:126-129.
- **Why:** Three near-identical audience stanzas drift out of sync (one says "no programming," one says "has programming experience").
- **Fix:** Single-source the audience paragraph in one place and link the others to it.

### Persona 4 — Narrative Architect

**(MEDIUM) Two READMEs tell the book's spine in different voices.**
- **What:** Root README.md:44-52 — "By the end, you can read and write … search Lean's tactic and lemma library efficiently, choose between term-mode and tactic-mode proofs, and translate a from-scratch … equivalent." (flat competency list) vs lean_book/README.md:51-62 — "the running goal is to build the *skill* of using Lean: reading a goal state, deciding what to try next, recovering when a tactic fails … Chapter 12 is dedicated entirely to working efficiently." (staged search-process arc)
- **Why:** The landing page sells the book as a checklist; the in-book README sells it as a staged journey. A reader landing on root README gets a shallower, differently-ordered story than the book actually delivers.
- **Impact:** Inconsistent branding of the pedagogy; the "By the end" list omits the checkpoint projects and narrative intros that README.md:59-63 claims are the book's actual structure.
- **Fix:** Replace the root README competency list with the lean_book/README.md search-process narrative, or cross-reference it, so the landing page tells the same story.

**(LOW) Landing-page opening leads with legal/meta links.**
- **What:** README.md:10 — "Notice | Reproducing this book" are the first inline links, appearing before the Summary (line 32+) and the table of contents.
- **Why:** The first navigation the eye meets is administrative rather than the reading journey.
- **Fix:** Move these to a footer or the project-history section.

## 4. Minor concerns (LOW)

- **README.md:57 "all 14 chapters"** vs the TOC numbering the appendix as "14. Solutions" (lean_book/README.md:130-132). A reader counting chapters 0–13 plus appendix 14 may infer 15 chapters. Clarify "14 chapters (0–13), plus an appendix."
- **CONTRIBUTING.md:54-56** cites "the pinned toolchain in `lean_project/lean-toolchain`" without naming the version; harmless, but a one-line version mention would help contributors confirm they're current.
- **README.md:34 title "Lean for Working Algebraists"** is slightly more advanced than the summary line "an introduction" (README.md:35). Minor framing tension, not a contradiction.
- **REPRODUCING.md:100-103** promises "add a notice to the top-level README disclosing that the book was AI-generated" — this was done (NOTICE.md exists), but REPRODUCING never confirms completion of its own step 8. Trivial; included for completeness.

## 5. Verification log

- README.md — read in full (135 lines).
- NOTICE.md — read in full (53 lines).
- CONTRIBUTING.md — read in full (57 lines).
- REPRODUCING.md — read in full (194 lines).
- lean_book/README.md — read in full (200 lines).
- lean_project/README.md — read in full (49 lines).
- lean_project/lean-toolchain — read (1 line: `leanprover/lean4:v4.32.2`).
- lean_book/changelog/README.md — read; v1.4.25.md read in full.
- lean_book/14-appendix-solutions/00-index.md — read in full; confirmed solutions exist for Chapters 1,3,4,5,6,7,8,9,10,11 only (no Ch2 — and lean_book/02-functions-and-structures/00-index.md:51-55 confirms Ch2 has no exercises section, so the README promise holds vacuously there).
- lean_book/12-working-efficiently/01-search-tactics.md:20-44 — confirmed real, uncompiled Lean (`exact?`).
- `lean_project/LeanProject/` directory listing — confirmed modules Ch01–Ch11 + Ch13CapstoneMathlib.lean; **no Ch12 module**.
- Grep across repo: `v4.31.0` live hits = none within the 4 review files; `v4.32.2` live hits = README.md:108, NOTICE.md:10,43, lean_project/lean-toolchain, lean_project/lakefile.toml:7, lean_book/00-setup/02-installing-toolchain.md:29, lean_book/learning-paths.md:60, lean_book/00-setup/04-mathlib-note.md:45 (all consistent). Stale `v4.31.0` only in historical changelog/v1.x.x.md and generated `lean_book_latex/*.tex` (expected, not in review scope).

<<<REPORT_END>>>
