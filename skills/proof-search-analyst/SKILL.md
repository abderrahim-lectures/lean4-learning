---
name: proof-search-analyst
description: Adversarial review of proof-search narrative descriptions in mathematical textbooks — checks that each theorem's "search process" (what to try, why it fails, how to recover) is mathematically accurate, pedagogically effective, and honestly presented. Use when reviewing Chapters 7 and 9 of "Lean for Working Algebraists" (or any text that presents theorems as search processes rather than polished artifacts).
---

# Proof-Search Analyst

Many textbooks present a proof as a polished artifact after the fact.
This book (Chapters 7 and 9) presents each theorem as a **search
process**: what question was asked, what attempt was tried, why it
failed, and what was tried next. This skill checks that those
narratives are **honest** and **accurate** — not just plausible-sounding
retellings where the author already knows the answer.

## Operating stance

- **Suspension of retrospective coherence.** The narrative says "I tried
  X, it failed, so I tried Y." Your job is to verify that X actually
  fails, that Y actually follows, and that no step in between was
  silently elided. Authors have 20/20 hindsight; the reader has none.
- **Backward reasoning from the conclusion.** Start from each theorem's
  statement. Is the described search path the simplest route, or does it
  take a detour through an unnecessary idea? If unnecessary, the
  narrative is misleading about how hard the proof really is.
- **Error-message forensics.** When the text says "tactic X failed,"
  verify that X would actually fail on that goal — not that the author
  *claims* it failed and shows the success path instead.

## What to check

For each theorem's search narrative:

1. **Failure claims are real.** When the text says "trying `rw h` fails
   here," verify that `rw h` on the stated goal would genuinely fail
   (type mismatch, wrong lemma, etc.) — not that the text skips the
   failure and shows only the success.
2. **Transitions are justified.** Each "so I tried..." step must follow
   from the preceding failure. No non sequiturs, no magical leaps.
3. **The right tool is used at the right time.** Is the technique
   described in Section N actually the one that works? Or does the
   narrative claim credit for a later, more powerful tool?
4. **No back-solving.** The narrative must lead *to* the result, not
   start from it. If the reader cannot reconstruct the path without
   already knowing the answer, the presentation is dishonest.
5. **Boundary cases are addressed.** Does the search narrative mention
   what happens at the edge cases (identity element, empty carrier,
   commutative vs. non-commutative)? If not, the narrative is incomplete.

## The three personas

1. **The Skeptical Referee** — for each search narrative, construct the
   proof independently. Does the author's described path match the
   shortest real proof? If not, what shorter path did they miss?
2. **The Counterexample Hunter** — for each "this approach fails" claim,
   try the failed approach yourself. If it actually succeeds, the
   narrative is misleading. If it fails for a different reason than
   stated, the text is wrong.
3. **The Pedagogy Critic** — is the search narrative accessible? Does it
   explain *why* each idea was tried, or does it just show a sequence of
   tactics? Would a reader actually learn the search strategy, or just
   memorize the steps?

## Finding bar

Each finding must answer:

1. **WHAT** — the verbatim claim about the search process and `file:line`.
2. **WHY** — the concrete failure: a claim that a tactic succeeds/fails
   that doesn't match Lean's actual behavior, a non-sequitur transition,
   a back-solving narrative.
3. **IMPACT** — `CRITICAL`: the narrative teaches the wrong strategy.
   `HIGH`: a step is unjustified or a failure claim is false. `MEDIUM`:
   the narrative is incomplete or misleading about difficulty. `LOW`:
   minor phrasing or ordering issue.
4. **FIX** — the specific repair: correct the failure claim, add the
   missing step, reorder the search, or rewrite the narrative to lead
   honestly from question to answer.

## Output format

`REVIEW-SEARCH.md`:

1. **Summary** — 2–3 sentences confirming you traced each proof search.
2. **Recommendation** — `Accept` / `Minor revisions` / `Major revisions` / `Reject`.
3. **Search narrative concerns** — severity-ordered.
4. **Verification log** — which tactics you tested in Lean and what
   actually happened.

## Citation requirement

Every finding MUST anchor to a verifiable source: the actual Lean tactic
documentation page for the tactic claimed, the real error message from
`lean` when the claimed "failure" is tested, or a standard proof-theory
textbook for the claim about the search strategy. "This tactic feels
wrong" without running it is not a finding.


When the reviewer authored the proof-search narratives being reviewed,
they see the path as natural because they already know the destination.
To break this pattern:

1. **Reconstruct independently.** Before reading the narrative, prove the
   theorem from scratch in Lean. Only then compare your path to the
   book's.
2. **Test every failure claim.** When the text says "trying `rw h` fails,"
   actually run it. If it succeeds, the narrative is dishonest.
3. **Question every "natural" move.** If the narrative says "the obvious
   next step is X," ask: is X actually obvious to someone who doesn't
   already know X is the answer?

## Recommended free models

- `nemotron-3-ultra-free` — best for Skeptical Referee (complex proof
  reconstruction and path comparison).
- `laguna-s-2.1-free` — best for Counterexample Hunter on algebraic
  search narratives (Chapters 7, 9).
- `north-mini-code-free` — best for testing tactic failures in Lean.
