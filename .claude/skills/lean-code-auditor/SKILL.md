---
name: lean-code-auditor
description: Auditor for Lean 4 code blocks in a proof-assistant textbook — checks compilation against the pinned toolchain, faithfulness of formalization to prose, absence of proof-faking shortcuts, and correct use of tactics/automation. Use when verifying that every Lean snippet compiles and genuinely encodes the mathematics it claims to, especially after a toolchain bump or content rewrite.
---
> **See also:** `second-brain/SKILL.md` routes across this repo's review skills. Pairs with `adversarial-maths-reviewer` (mathematical faithfulness) and `proof-search-analyst` (does a claimed tactic failure/success match this file's `dbg_trace` correctness check, item 4 below).


# Lean Code Auditor

This skill inspects every Lean 4 code block in a book or manuscript for
**compilation correctness**, **mathematical faithfulness**, and **proof
integrity**. It does not grade style — it checks that the code compiles
against the book's pinned toolchain and that no shortcut masquerades as a
proof.

## Operating stance

- **Compiler-first.** Every code block is judged by whether it compiles
  against the pinned toolchain (`lean_project/lean-toolchain`), not by
  whether it looks plausible. Run `lake build` in the companion project
  to confirm. If the code cannot be run, flag it as unverified.
- **Faithfulness.** The Lean statement must match the prose statement at
  full strength — no weakened hypothesis, no truncated conclusion, no
  content hidden in a typeclass field that the prose omits.
- **No faking.** No `sorry`, `admit`, `axiom`, `unsafe`, or
  comment-silenced goals. No `simp`/`omega`/`decide` swallowing a step
  that the section text claims to carry out explicitly. No `rfl` invoked
  where it does not hold.

## What to check

For every code block, snippet, or `dbg_trace` sibling:

1. **Compiles.** Does the snippet typecheck against the pinned toolchain
   (`v4.32.2`)? Does `lean_project/` build with `lake build`?
2. **Matches prose.** Does the formal statement agree with the prose
   claim — same hypotheses, same conclusion, same strength?
3. **No shortcuts.** Are `sorry`, `admit`, `axiom`, `unsafe` absent? Is
   every claimed `rfl` actually definitionally true? Is every `simp`
   rewriting something the reader already saw, not hiding a new step?
4. **`dbg_trace` correctness.** For genuinely recursive definitions, does
   the `dbg_trace`-annotated sibling produce output that matches what the
   text claims it shows (one unwinding step at a time)?
5. **Exercise solutions.** Do the appendix solutions actually compile
   and produce the stated result? No missing imports, no changed
   identifiers, no `sorry`-dropped lemmas.
6. **Axiom check.** For each top-level `theorem`/`def` a snippet
   introduces, run `#print axioms <name>` (a scratch file via `lake env
   lean`) and confirm the axiom list is limited to the three standard
   ones Lean's kernel uses (`propext`, `Classical.choice`, `Quot.sound`)
   or none at all. Anything else, a stray `sorryAx`, an ad hoc `axiom`
   declaration, is a CRITICAL finding even if `lake build` reported
   success: this catches a proof that compiles but is silently unsound
   or incomplete in a way build output alone does not always surface.

## Skill provenance

Item 6 was added from `.claude/skills/skill-scout-daily-cron`'s
2026-08-28 report (`reviews/skill-scouting/2026-08-28.md`), sourced from
`cameronfreer/lean4-skills`'s "per-file build, axiom check, commit"
workflow. That same report also proposed requiring a Mathlib search
(LeanSearch/Loogle) before accepting any hand-written proof of a
standard algebraic fact, flagging duplication as a style finding. That
proposal is **rejected**, not adopted: this book is deliberately
Mathlib-free through Chapter 12 (`00-setup/04-mathlib-note.md`), so
every hand-written proof of a standard fact is duplicating Mathlib *on
purpose*, that is the pedagogical point, not an oversight. Applying that
check here would manufacture a false finding on nearly every proof in
Chapters 7-13. Recorded here so a future scouting pass does not
resurface it without this context.

## Toolchain version discipline

- The book's toolchain is pinned in `lean_project/lean-toolchain`.
  After any toolchain bump (e.g. `v4.31.0` → `v4.32.2`), **re-run
  `lake build`** and confirm zero regressions.
- Check that `lakefile.toml`'s Mathlib `rev` matches the toolchain tag.
- Check that `lake-manifest.json` pins compatible dependency revisions.
- Flag any code block that relies on a feature introduced or removed
  between the old and new toolchain.

## Finding bar

Each finding must answer all four:

1. **WHAT** — the exact code block (verbatim) and `file:line`.
2. **WHY** — the concrete failure: compile error, weakened hypothesis,
   hidden `sorry`, faithfulness mismatch, `dbg_trace` output that does
   not match the claimed trace.
3. **IMPACT** — how badly the reader is misled (false theorem > unproven
   step > misleading trace > cosmetic gap).
4. **FIX** — the specific repair: add the missing import, restore the
   hypothesis, replace the fake proof with a real one, correct the trace.

## Output format

Write `REVIEW-LEAN.md` (or `REVIEW-LEAN-<target>.md`):

1. **Summary** — 2–5 sentences proving you compiled the code, not just
   read it.
2. **Recommendation** — `Accept` / `Minor revisions` / `Major revisions` /
   `Reject`.
3. **Compile failures** — every file:line that does not compile, with the
   exact error message from `lake build` or `lean`.
4. **Faithfulness gaps** — every place the Lean statement diverges from
   the prose.
5. **Proof shortcuts** — every `sorry`/`admit`/`rfl`-where-it-shouldn't-be,
   with a fix.
6. **Verification log** — what you actually ran (`lake build` passed/failed,
   which files have errors, which compiled cleanly).

## Citation requirement

Every finding MUST anchor to a verifiable source: the exact error message
from `lake build` or `lean`, a `#check`/`#eval` output, the Lean
documentation page, or the book's own Lean source code. "This code looks
wrong" without a compiler message is not a finding.


One round of fixes, one re-review. If `CRITICAL` findings (compile
failures, false theorems, hidden `sorry`s) survive the fix round, stop
and report plainly: a recurring compile failure or faithfulness gap
indicates a structural problem, not an iteration problem.

## Recommended free models

- `north-mini-code-free` — best for Lean code compilation checks
  (code-specialized model).
- `nemotron-3-ultra-free` — best for cross-checking Formalizer findings
  across multiple chapters.
- `laguna-s-2.1-free` — best for complex tactic-failure analysis in
  Chapters 5 and 10.
