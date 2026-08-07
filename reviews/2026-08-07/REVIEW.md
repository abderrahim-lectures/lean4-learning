# Adversarial review, 2026-08-07

Single-reviewer pass following `skills/adversarial-book-reviewer/SKILL.md`.
Scope. A self-audit of the v1.5.2 edits (highest risk for self-introduced
error), a book-wide automated sweep for broken links and leftover
`sorry`/`admit`, and a First-Time Reader spot-check on a chapter untouched
since v1.4.

## Summary

The book is in solid shape. The book-wide link sweep found zero real
broken cross-references. No `sorry`, `admit`, `axiom`, or `unsafe` remains
in any of the 194 Lean code blocks across 63 files. The v1.5.2 self-audit
found two real defects, both introduced by my own earlier edits, both
fixed during this review. One structural finding survives across the
whole book and is not new to v1.5.2.

## Recommendation

Minor revisions. The two defects found were fixed in this pass. The
structural finding below is worth a decision but is not blocking.

## Major concerns

None at CRITICAL or HIGH severity.

## Findings (fixed during this review)

### F1. Forgetful-functor diagram disagreed with its own table (MEDIUM, fixed)

File. `lean_book/01-basics/04-terminology.md`, around line 359.

What. The v1.5.2 fix to the "Forgetful functor" table split the
`Ring → Group` row into two honest steps, `Ring → CommGroup` then
`CommGroup → Group`, because `Ring.addGrp` actually returns a
`CommGroup`, not a `Group` directly. But the mermaid diagram sitting
right above that table was never updated. It still drew a single arrow
straight from `Ring` to `Group`, with no `CommGroup` node at all.

Why this matters. A First-Time Reader looks at the diagram first, since
it is the picture right before the table. The diagram said "one arrow,"
the table said "two arrows." Fact-Checker persona. two parts of the same
page contradicted each other about how many forgetful steps exist between
`Ring` and `Group`.

Fix applied. Added the missing `CommGroup` node to the diagram so it now
matches the table, three arrows in a row, `Ring → CommGroup → Group →
Set`.

### F2. Notation-reference row label collided with its own neighbor (LOW, fixed)

File. `lean_book/notation-reference.md`, line 53 (before the fix).

What. The `·` disambiguation split added in v1.5.2 produced two adjacent
rows, "Group multiplication" and "Scalar/group action." Putting the word
"group" in both labels, for two different Lean operations, undercuts the
entire point of the split, which was to stop a reader from conflating
them.

Fix applied. Renamed the second row to "Module scalar action (a ring
element acting on a module element)," dropping "group" from it entirely,
and updated the math notation shown from the generic `a · b` to the
chapter's actual `r · m` (matching how it is used in Chapter 10). Also
tightened the explanatory note above the table to match.

## Minor concerns

### M1. Heavy em-dash and colon use in prose sits next to Lean syntax that uses the same characters (LOW, not fixed, flagged for a decision)

File. Book-wide. One representative instance,
`lean_book/02-functions-and-structures/00-index.md`, line 50: "generating
a forgetful `.toX` projection for free — the exact mechanism a
`CommGroup` will use..."

What. The book's prose uses colons and em-dashes constantly as ordinary
punctuation, appositives, asides, and list introductions. Lean itself
uses `:` for type ascription and `--` for line comments, both shown
throughout the same pages in code blocks. A reader moving between prose
and code has no visual signal telling them which meaning applies at a
glance, since both live in the same paragraphs.

Why this matters. NOTICE.md already documents a prior "Plain-English
pass" that reduced "stacked em-dash asides," so this is a known,
partially-addressed concern, not a new one. It resurfaced independently
in this session when the same ambiguity was raised about my own
explanatory text in conversation, which pointed at the same underlying
problem the book's prose has.

Not fixed here. This is a book-wide style question, not a factual defect,
and a full pass would touch nearly every chapter. Flagging it for a
scoping decision rather than executing a large rewrite unprompted.

## Surviving strengths

- Cross-reference integrity. every `[text](path.md)` link in the entire
  `lean_book/` tree resolves to a real file. Zero broken links found by an
  exhaustive automated sweep, not a sample.
- Proof hygiene. zero `sorry`, `admit`, `axiom`, or `unsafe` across all
  194 Lean code blocks in the book.
- Chapter 11's free-category material (the highest-risk math content
  after the v1.5.2 associativity fix) held up under a fresh adversarial
  pass. the induction argument, the universal-property statement, and the
  `rfl`-scope qualification are all internally consistent and
  independently checked against the actual recursion structure of
  `Path.append` in this pass.
- Chapter 2's index (spot-checked as an untouched control) is a clean
  example of the book's "story of this chapter" pedagogical device
  working as intended: each section is motivated by a question forced by
  the previous one, with forward references to where the mechanism gets
  reused later.
