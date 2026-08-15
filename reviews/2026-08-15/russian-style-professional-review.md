# Adversarial review: does the v2.0.0 "Russian-style" rewrite actually achieve derivation-first exposition?

Reviewer stance: adversarial, per `skills/adversarial-book-reviewer/SKILL.md`. The changelog's own claim of a
prior "full skill-based adversarial audit" that returned no findings was explicitly *not* trusted; every
finding below is independently re-derived from the current text.

## Summary

The v2.0.0 rewrite is a genuine, largely successful execution of the stated pedagogical goal, not a
relabeling exercise. Nineteen of twenty-two files sampled in full across Chapters 1, 3, 5, 7, 8, 9, 10, 11,
12, 13, 14 (plus spot-checks of 0, 2, 4, 6) pose a real forcing question or concrete problem and only name
the definition/theorem once the reasoning that discovers it is on the page — Chapter 9's ring axioms,
Chapter 10's `mul_zero`/`(-1)·a=-a` derivations, and Chapter 1's dependent-types section are as good as
technical exposition in this genre gets. Exercises are consistently unanswered, with solutions correctly
deferred to Chapter 15 and verified to match. No bare "Picture it like this" analogy box survives outside
the citation-quote boxes the convention explicitly exempts, and no chapter opens with narrative "story"
framing. But the rewrite is not uniform: two tactic-catalog sections (`03-functions-and-structures/00-index.md`
on currying, `05-tactics/04-more-tactics.md` on `simp`/`constructor`/`cases`/`unfold`) still name-then-explain
exactly the pattern the book claims to have eliminated, Chapter 12's core definitions (quiver, path) are
asserted in Bourbaki style with only a sentence of scene-setting rather than earned, and — the most serious
finding — the top-level `README.md` still describes the pre-rewrite v1.5.0 narrative/analogy-box style as
the book's current, book-wide convention, directly contradicting `lean_book/README.md`, `CONTRIBUTING.md`,
and the actual v2.0.0 text.

## Recommendation

**Minor revisions.**

## Major concerns

### CRITICAL — Root `README.md` describes an obsolete style as the book's current convention, contradicting `CONTRIBUTING.md` and the actual text

**WHAT.** `/home/adrabi/dev/lean/lean4-learning/README.md`, "Pedagogical approach" section (lines 63–110),
states, as applying "consistently across all 15 chapters (Chapters 0–14)":

> "Each chapter opens with a story framing the cognitive journey ahead (remember → understand → apply →
> analyze → evaluate → create)..." (line 66)

> "Every formally cited term closes its section with a verbatim quote, a precise citation, and a 'Picture
> it like this:' gloss explaining the idea through an everyday analogy, real-world, not just mathematical,
> rather than a second compressed technical restatement." (lines 91–95)

> "Socratic questions. Each chapter includes reflective 'why X, not Y?' questions with their answers,
> distinct from the recap and the exercises." (lines 96–98)

This is the exact v1.5.0-era style the v2.0.0 changelog says was reversed. Compare
`lean_book/CONTRIBUTING.md` lines 49–58: "Do not open a section or chapter with a narrative 'story' framing
or a 'Picture it like this' analogy box in place of doing the derivation... This is now the style of the
whole book," and `lean_book/README.md` (`How to read this book`) lines 125–139, which states the sixth pass
explicitly removed narrative openers and bare analogy boxes "book-wide."

**WHY.** Two governing documents in the same repository, both purporting to describe the current book, make
flatly opposite claims about what a reader will encounter, and neither the "story" opener nor the bare
"Picture it like this:" gloss nor an inline-answered "Socratic question" exists anywhere in the 25+ files
read for this review (Chapters 1, 3, 5, 7, 8, 9, 10, 11, 12, 13, 14, plus spot-checks of 0, 2, 4, 6).

**IMPACT.** A reader who lands on the repository's front door (the root README, the first thing GitHub shows)
forms a false expectation and is primed to distrust the actual book, or a contributor reading
`CONTRIBUTING.md`'s prose convention has no way to know the root README disagrees with it. This is precisely
the kind of claim the "second follow-up" audit in the changelog says it checked ("index-page register
consistency... found... no leftover narrative/analogy/answered-inline-exercise violations") and evidently did
not check the file that actually contains the violation.

**FIX.** Rewrite the root `README.md`'s "Pedagogical approach" section to match
`lean_book/README.md`/`CONTRIBUTING.md`'s current derivation-first description: no chapter-opening "story,"
no default "Picture it like this" gloss (retain the exemption only for direct-quote citation boxes and say so
explicitly), no "Socratic questions" device. If any of "Learning objectives," "Mathematical reading,"
"Programmer's corner," "Mathlib equivalent," "Step-by-step tracing," and "Checkpoint projects" remain accurate
as standing devices, keep only those bullets and remove or correct the three that no longer describe the book.

---

### HIGH — `03-functions-and-structures/00-index.md` states and explains "currying" before any forcing question, immediately above a properly-executed derivation in the same file

**WHAT.** `lean_book/03-functions-and-structures/00-index.md:14-22`:

> "Functions **curry**. `add : Nat → Nat → Nat` is really `Nat → (Nat → Nat)`, a function that returns
> another function... This is the type-theoretic form of the Hom-set isomorphism
> $\mathrm{Hom}(A\times B, C)\cong\mathrm{Hom}(A,\mathrm{Hom}(B,C))$..."

The term "curry" is bolded and asserted as a bare fact in the first sentence of the chapter's technical
content. No problem is posed that currying solves; the Hom-set-isomorphism justification is appended only
after the term is already named and explained. Nineteen lines later, the same file's "## What forces
`structure`" section (lines 24–34) does this correctly: it poses the actual problem ("that leaves open how
several pieces of data belonging *together*... get treated as a single value") before naming `structure`.

**WHY.** This is exactly the pattern `CONTRIBUTING.md:51` prohibits: "a definition or theorem is not stated
and then explained, it is *earned*."

**IMPACT.** A reader hits the chapter's very first piece of technical content, immediately after "Learning
objectives," and finds the promised method already abandoned — and the contrast with the correctly-executed
section nineteen lines below makes the lapse conspicuous rather than incidental.

**FIX.** Pose the forcing question first: "`add` takes two arguments — does Lean's function-type arrow
actually support two arguments at once, or is something else happening?" Then derive
`Nat → Nat → Nat = Nat → (Nat → Nat)` by unfolding the arrow, and only then name "currying" and state the
Hom-set isomorphism as the formal consequence.

---

### HIGH — `05-tactics/04-more-tactics.md` names four tactics cold (header → code → sometimes an explanation afterward), the exact template the book claims not to impose

**WHAT.** `lean_book/05-tactics/04-more-tactics.md`, four instances, verified directly:

- `simp`, lines 7–21: `### \`simp\`: simplify using known simplification lemmas` is immediately followed by
  a code block (lines 9–12); the two sentences that follow ("`simp` automatically searches for known
  'simplification' lemmas...") explain the tactic already named in the header, not derive it.
- `constructor`, lines 27–34, 38–51: header names the tactic, code follows immediately (lines 29–34), and
  "Mathematical reading" explanation is appended afterward (lines 38–51).
- `cases`, lines 56–63: `### \`cases\`: case-split on an inductive value or hypothesis`, then code — zero
  motivating text before or after.
- `unfold`, lines 84–100: header, code (lines 86–93), then "Mathematical reading" appended afterward.

**WHY.** Each names and defines the tactic in its own header before any forcing question, then supplies a
worked example — the reversed order `CONTRIBUTING.md:51-54` prohibits ("Pose the question... walk the chain
of reasoning that discovers it... and only then name and formalize the result"). The identical
header→code→(sometimes)reading shape repeated four times in one file is also functionally the "fixed...
skeleton... imposed on the reasoning" the same convention disclaims (line 55), merely relabeled from
Definition/Theorem/Proof/Remark to tactic-name/example/reading.

**MITIGATION.** `05-tactics/00-index.md:21-24` frames this section as a reference ("read it once, then
return to it as needed"), which provides some cover for a catalog-style listing — but that framing is not
present in the file itself, and `induction` in the same file benefits from genuine prior derivation via
Section 1's worked strategy session, while `simp`, `constructor`, `cases`, and `unfold` do not; they are
named cold here for the first time, with no such framing visible to a reader mid-file.

**IMPACT.** A reader meeting `cases` or `unfold` for the first time gets the tool's name and syntax before
any sense of why it exists or what problem forced it into being — the opposite of "impossible to understand
an unmotivated definition" (the book's own stated first principle, README.md line 20).

**FIX.** Either (a) explicitly relabel the section as a reference appendix outside the derivation-first
promise, matching what the chapter index already implies but the section itself does not state, or (b) for
`cases` and `unfold` at minimum, add one or two sentences posing the forcing question before the
header/code — e.g. for `cases`: "`or_comm` needs to handle both the `inl` and `inr` witnesses of a `∨`
separately — what tactic lets a proof branch on which constructor produced a hypothesis?"

---

### HIGH — Chapter 12's core definitions (quiver, path) are stated Bourbaki-style after one sentence of scene-setting, inconsistent with the same chapter's later sections

**WHAT.** `lean_book/12-path-algebras/01-what-is-a-quiver.md:7-24`: after one paragraph noting the chapter
"needs a graph before it needs paths," the text goes directly to:

> "A **quiver** is a *directed graph*, a set of vertices and a set of directed edges (called **arrows**)
> between them... Formally, a quiver $Q$ consists of the following. — A set of vertices $Q_0$. — A set of
> arrows $Q_1$. — Two functions $s, t : Q_1 \to Q_0$..."

Likewise `02-paths.md:7-21`: one transition sentence ("Not every such chain makes sense... This section
names that notion precisely, a **path**"), then immediately the full formal definition of a path as a
head-to-tail-composable sequence of arrows.

**WHY.** `CONTRIBUTING.md:51-54` requires posing "the question or concrete problem that forces it" and
walking "the chain of reasoning that discovers it" before naming the result. Neither section poses a
concrete problem or walks a chain of reasoning that discovers the specific data chosen (a vertex set, an
arrow set, and two functions $s,t$, rather than, say, a relation or an adjacency structure). Both assert the
bolded term and its formal components directly. This is inconsistent within the same chapter:
`04-paths-as-inductive-type.md:7-14` and `05-path-composition.md:7-15` both open with a genuine "what forces
this" framing before defining anything ("The key idea for formalizing 'paths compose head-to-tail' is to
make `Path` an inductive type *indexed* by its own source and target vertex" — stating the problem before
the construction).

**IMPACT.** Of all chapters sampled, Chapter 12's opening two sections are the weakest at delivering
derivation-first exposition; a reader gets "quiver = graph, here is the formal data" with no work shown for
why source-and-target functions (rather than an alternative encoding) are the right choice — the very
insight that later motivates the dependent-type encoding of `Path` in Section 4. The chapter has the raw
material to do this properly: `03-defining-a-quiver.md:72-95` already contrasts this book's
function-pair encoding against Mathlib's arrow-typed alternative, but only after the fact, to explain
Mathlib, not to motivate the book's own choice earlier.

**FIX.** Move the Mathlib-alternative contrast (or a version of it) earlier, and use it to actually derive
the choice: pose "what minimal data lets us say 'this arrow starts here and ends there'?", note a vertex set
is needed, note arrows need endpoints, and only then justify "the simplest way to record that is as two
functions $s,t : Q_1 \to Q_0$" against the alternative of baking endpoints into the arrow's own type.

## Minor concerns

### LOW — `04-propositions-and-proofs/03-theorem-lemma.md` states-then-explains a trivial fact

**WHAT.** `lean_book/04-propositions-and-proofs/03-theorem-lemma.md:7-13` opens with two `theorem` code
blocks, then states cold: "`theorem` and `lemma` are the same thing syntactically. `lemma` is just a naming
convention for 'small helper facts.'" with a one-sentence "Mathematical reading" justification following.

**WHY.** Matches the "stated, then explained" pattern `CONTRIBUTING.md:51` disclaims, though the fact itself
(a naming convention with "no logical content") is trivial enough that a full forcing-question derivation
would be disproportionate.

**IMPACT.** Negligible on its own — the content is a syntax note, not a substantive definition — but it is a
visible seam in an otherwise consistent chapter, noticeable to a reader who has been primed by 3+ prior
chapters to expect a forcing question first.

**FIX.** One sentence would close the gap: "Chapter 3's `def` named an ordinary computation; nothing yet
lets that name assert `2+2=4` is *true* rather than merely *defined* — what changes to make a name assert
provability?" then land on `theorem`.

### LOW — Exercise strategy hints in Chapters 8 and 10 pre-solve a meaningful fraction of the problem

**WHAT.** `08-group-theorems/05-exercises.md:27-31` (Exercise 4): "Strategy hint, `b` and `c` cannot be
rewritten directly in isolation. Instead, apply `Grp.op (Grp.inv a)` to *both sides* of `h` first (as a
`have`), then simplify each side using `assoc`/`inv_left`/`id_left`, the same 'regroup, then cancel' pattern
as Theorem 3." `10-ring-theorems/04-exercises.md:13-19` (Exercise 1) gives an equivalent full-strategy hint.

**WHY.** `CONTRIBUTING.md:62-63` asks for exercises that "should not give away their own answer inline";
these hints name the exact tactic sequence, lemma names, and pattern to apply, leaving mostly transcription
rather than independent discovery of the strategy.

**IMPACT.** Minor — the reader still has to execute and check the proof — but the intellectual content
(finding the approach) is largely pre-solved, in visible tension with Chapter 7's and Chapter 12's own
exercises, which give at most a one-clause pointer.

**FIX.** Move the specific lemma-by-lemma strategy into the appendix solution; leave in the exercise file
only a pointer such as "uses the same idea as Theorem 3."

### LOW — The recurring six-box theorem template in Chapters 8 and 10 is itself a fixed skeleton

**WHAT.** Every theorem section in Chapters 8 and 10 (`02-theorem-1.md`, `03-theorem-2.md` in both chapters,
plus `04-theorem-3.md` in Chapter 8) follows an identical sequence: Claim → Finding the proof → Lean code →
Mathematical reading → Programmer's corner (Python) → Mathlib equivalent, in that order, every time.

**WHY.** `CONTRIBUTING.md:55` states "There is no fixed Definition→Theorem→Proof→Remark skeleton to fill
in; structure follows the logic of the argument." The box names have changed, but applying an identical
six-part template to every theorem regardless of the argument's actual shape is functionally the same
pattern the convention disclaims.

**IMPACT.** Low — each individual box is well-executed and the repetition arguably serves the reader (a
predictable structure for a reference-style chapter) — but the claim "structure follows the logic of the
argument" overstates how free-form Chapters 8 and 10 actually are.

**FIX.** Either relax the claim in `CONTRIBUTING.md` to acknowledge these are intentional standing devices
(the root README's now-inaccurate "recurring devices" framing already gestures at this, for the parts of it
that are otherwise correct — see the CRITICAL finding above), or vary the box order/presence at least once
to substantiate "structure follows the logic of the argument."

## Surviving strengths

- **`07-groups/01-definition.md`** and **`09-rings/01-definition.md`**: the clearest executions of the
  method in the book. Each poses a precise forcing question ("What is the weakest extra requirement that
  makes every element undoable?"; "What is the minimal set of axioms capturing 'two operations, one of them
  a group, the second compatible via distributivity'?"), rules out a wrong answer explicitly (vacuous
  self-cancellation for the identity; the counterexample of non-commutative matrix multiplication forcing
  distributivity to be stated on both sides), and only then names and states the axioms.
- **`08-group-theorems/02-theorem-1.md`, `03-theorem-2.md`** and **`10-ring-theorems/02-theorem-1.md`,
  `03-theorem-2.md`**: genuinely deliver the README's "search process" promise, not just narrated hindsight.
  Chapter 10 in particular documents real, specific, previously-failed tactic attempts ("An earlier draft
  tried `conv_lhs => rw [...]`... but this failed with `unknown tactic`"; "attempting to rewrite with `h1`...
  using plain `rw` caused occurrence-targeting problems") — verifiable, revision-grade evidence of an actual
  search, not retrofitted explanation.
- **`01-basics/03-dependent-types.md`**: the single strongest section reviewed. Opens with a live,
  concrete Python bug (`dot([17,-3,42],[99,8])` silently returning a wrong answer because the vectors have
  mismatched lengths), builds `Fin` then `Vec` to fix it, and only names "dependent type" and "Π-type" once
  both worked examples are already on the table.
- **`12-path-algebras/04-paths-as-inductive-type.md`, `05-path-composition.md`**: pose the actual problem
  (preventing nonsensical arrow composition; joining two already-built paths) before showing the
  construction, in clear contrast to the weaker Sections 1–2 of the same chapter.
- Exercises across every chapter sampled (1, 3, 4, 5, 6, 7, 9, 11, 12, 13, 14) are consistently plain,
  unanswered, "Prove that.../Show that..." problems, with matching solutions verified present in
  `15-appendix-solutions/`. No inline-answered "Socratic question" survives anywhere in the sampled text,
  despite the root README (see CRITICAL finding) still describing that device as current.
- The "Picture it like this" exemption for direct-quote citation boxes is honored precisely everywhere it
  was checked (Chapters 2, 4, 6, 7, 9, 12): every surviving instance sits inside a "Sources, quoted" block
  glossing a verbatim citation, never substituting for derivation in the main argument.
