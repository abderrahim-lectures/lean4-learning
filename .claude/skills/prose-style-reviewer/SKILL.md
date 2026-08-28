---
name: prose-style-reviewer
description: Adversarial, sentence-level check of this book's plain-academic-prose rules (CONTRIBUTING.md's "Book prose conventions") — no possessives, no em-dashes, no colon-led explanations, no comma-pileup sentences, no filler/hedge words, no spatial-metaphor verbs standing in for a literal one, no terminology drift. Use as a dedicated style pass, separate from the adversarial-book-reviewer's pedagogy/structure check and the adversarial-maths-reviewer's correctness check.
---

# Prose Style Reviewer

Ported and adapted from `~/dev/research-ideas`'s `style-provenance-check`
skill (Rule 1 only; that skill's graphify/ledger/LaTeX-citation-locator
rules are specific to that repo's paper pipeline and do not apply to this
book's Markdown "Sources, quoted" convention). This skill operationalizes
`CONTRIBUTING.md`'s "Book prose conventions" as a hard-gate, line-by-line
sweep, distinct from `adversarial-book-reviewer` (pedagogy/structure) and
`adversarial-maths-reviewer` (mathematical correctness). Run it separately;
a file can pass both of those and still fail every rule here, because
neither of them reads for sentence-level style.

## Operating stance

These rules are hard gates, not suggestions. Do not report a file "clean"
because it reads fine in isolation, sentence-level violations survive a
casual read exactly because each one is individually unremarkable — the
pattern is only visible on a dedicated sweep.

## Rule 1 — no English possessive

Never use apostrophe-s (`'s`) or bare plural possessive (`s'`). Use an
"of" construction or an adjectival compound instead: "the type of `x`"
not "`x`'s type," "Lean's kernel" becomes "the kernel of Lean," "Gelfand's
seminar" becomes "the Gelfand seminar" or "the seminar Gelfand ran."
Exception: a proper noun that is the standard name of a cited theorem or
person's own work where rewording would misname it (e.g. "Kempe's 1879
proof" as the specific historical object being discussed, not a
possessive standing in for "of Kempe") — flag these for a human judgment
call rather than auto-rewriting, since renaming a named result is a
content decision.

## Rule 2 — no em-dashes or colon-led explanations

No em-dash (`—`) or double-hyphen used as a dash. No colon used to
introduce an explanation ("the idea is: X," "in short: X") — write it as
a plain sentence with a verb. Lean's own syntax uses `:` for typing
judgments and `--` for comments; a book about Lean doubling those
characters as prose punctuation is a specific, recurring source of
reader confusion this book's own conventions exist to avoid.

## Rule 3 — one claim per sentence, no comma pileups

A sentence with more than one or two commas should be split into
separate short sentences. A sentence needing two readings to parse fails
this rule even when every clause is individually correct — the reader
must be able to tell where a sentence starts and ends without
re-reading it. A sentence with more than one subordinate clause, or
where the main verb is hard to find, gets split. This matches
`CONTRIBUTING.md`'s own stated rule ("if a sentence needs two readings
to parse, it's a candidate for splitting").

## Rule 4 — no filler, hedge chains, or defensive meta-commentary

- No filler/cliché words ("self-contained," "sensitive," and similar
  reflexive hedges) — use a plainer, more specific word.
- No hedge chains ("not X, or Y, and not Z, but rather W") — lead with
  the positive claim: state what the result *is* first.
- No defensive meta-commentary that argues with an imagined skeptical
  reader ("this is not new," "the reader should not mistake this for...")
  repeated more than once in a section.
- No backward cross-signposting ("as noted above," "as discussed
  earlier") used in place of just restating the fact plainly, forcing
  the reader to flip back instead of reading forward.
- No trailing subordinate clause appended after a sentence's main claim
  has already resolved.

## Rule 5 — no spatial/physical metaphor verbs standing in for a literal one

Ban figurative-motion verbs used as informal stand-ins for a precise
technical relation: "drives," "picks up," "landing in," "reaches [a
case]," "ingredient," "machinery," "hinges on," "boils down to." Swap
for the literal word ("underlies," "meets," "produces," "covers,"
"fact," "component," "depends on," "reduces to"). These read fine in
isolation, in ordinary prose, which is exactly why they survive a casual
read; flagging one instance is a signal to sweep the whole file for the
same class, not just that one word. This is distinct from `CONTRIBUTING.md`'s
separate ban on metaphor used *as a pedagogical device* (the "Picture it
like this" analogy-in-place-of-derivation rule) — this rule is about
word choice in otherwise-literal exposition, not about substituting an
analogy for the derivation itself.

## Rule 6 — no terminology drift

The same concept must be named the same way throughout a section, and
ideally throughout the book. Two or more different phrasings for one
idea across a file is a finding, flag every variant after the first and
propose the one term to standardize on, matching whatever term this
book's own glossary (`01-basics/04-exercises.md`'s "Key points," or
the relevant "Sources, quoted" box) already committed to.

## Wordiness

Any sentence that can lose more than roughly 20% of its words with no
loss of meaning gets a tightened rewrite. Apply this hardest to opening
paragraphs and "Key points" summaries, since they are the text a skimming
reader reads most carefully.

## Adversarial procedure

Run as a hostile second pass, separate from whatever pass produced the
text. "No issues found" must be earned per rule, not assumed — if a file
comes back clean on every rule, reread it once bottom-up before trusting
that verdict, the same self-review-trap countermeasure
`adversarial-book-reviewer` uses.

1. Grep-assisted sweep for the mechanical violations first: `'s`/`s'`
   possessives (careful with contractions, "it's"/"let's"/"doesn't" are
   not possessives), em-dashes, colon-followed-by-lowercase-explanation
   patterns.
2. Line-by-line read for comma pileups, hedge chains, filler words,
   spatial metaphors, and terminology drift, since none of these are
   reliably greppable.
3. For every finding: quote the offending sentence verbatim with
   `file:line`, name which rule it violates, and give the rewritten
   sentence, not just "rewrite this."

## Triage gate

| Genuine fault, report it | Manufactured noise, drop it |
|---|---|
| A real possessive, em-dash, or colon-explanation | A proper noun that is a standard citation name ("Kempe's proof" naming the historical result) |
| A sentence that genuinely needs two readings | A long sentence that is still one clear claim (a parenthetical does not automatically fail this) |
| A spatial metaphor used as an informal stand-in | A technical term that happens to share a word with a metaphor family but is the book's own defined vocabulary |
| Terminology drift for one concept | Two different concepts that happen to sound similar |

## Output format

List every finding as `[STYLE fatal/minor]` with `file:line`, the
verbatim offending text, the rule violated, and the fix. Do not report a
file "clean" while any fatal finding is open.

## When to run

- Before any Markdown file in `lean_book/` is considered done, as a
  separate pass from `adversarial-book-reviewer` and
  `adversarial-maths-reviewer` — neither of those checks reads for
  sentence-level style, so a file can pass both while still being full
  of possessives and em-dashes.
- Whenever a new or rewritten section is added, per `CONTRIBUTING.md`'s
  "Book prose conventions."
