---
name: plain-prose-repair
description: Detect and repair two rhetorical habits that survive CONTRIBUTING.md's "Book prose conventions" and the prose-style-reviewer sweep — the antithesis drumbeat ("It is not X. It is Y." repeated for effect) and precise-but-uncommon vocabulary (forecloses, asymmetric, self-sealing, rationed, dissolve) that sends a reader to a dictionary. Both are FREQUENCY defects, invisible sentence by sentence, visible only in a count. Companion to prose-style-reviewer, driven by tools/scripts/check-plain-prose.sh. Use before finalizing any chapter, exercise, or reply, and whenever a reader says the text feels poetic or hard to parse.
---

# Plain prose: repairing two invisible habits

Ported from `~/dev/research-ideas`'s `plain-prose-repair` skill. That
repo's version targets `.tex` papers; this one targets this book's
Markdown chapters under `lean_book/`. `prose-style-reviewer` already
covers possessives, em-dashes, colon-led explanations, comma pileups,
filler words, and spatial metaphors — this skill adds the two habits
that survive all of those, because each one reads fine sentence by
sentence.

## Tools required

`tools/scripts/check-plain-prose.sh <file>` reports counts and a
per-1000-word density for both habits. `bash`, `grep`, `awk`. No network.

## Habit A: the antithesis drumbeat

The shape is a negation followed immediately by its positive restatement:

- "It is not a theorem. It is a definition."
- "The claim is not new, it is standard."
- "This is bookkeeping, not a repair."
- "…, not incidental." / "… — not the search mechanism."

One instance is a legitimate way to draw a distinction. Repeated across a
chapter, the reader feels pushed rather than taught, and cannot say why,
because no single sentence is wrong.

**Distinct from the neighbouring rule.** `prose-style-reviewer`'s Rule 4
already bans a hedge chain inside a single sentence ("not X, or Y, and
not Z, but rather W"). This habit spans two sentences or a comma splice,
and the defect is the repetition, not any one occurrence.

**Repair.** State the positive claim directly. Delete the negated half
unless a reader would otherwise plausibly believe it:

| Instead of | Write |
|---|---|
| "It is not a theorem. It is a definition." | "This is a definition." |
| "This is bookkeeping, not a repair." | "This changes the record without changing the code." |
| "…proves the general case, not just this example." | "…proves the general case, building on this example." |

Keep the negation only where a real misreading is live, where a reader
of this book genuinely might expect the opposite (common in a chapter
correcting a plausible but wrong intuition — keep those).

## Habit B: vocabulary that needs a dictionary

Words like *forecloses, asymmetric, self-sealing, rationed, dissolve,
elides, salient, obviates, predicated, supervenes*. These are exact, not
clichéd, so `prose-style-reviewer`'s filler-word and metaphor-verb rules
step over them. Exactness is what makes them tempting, and this book's
stated audience includes nonnative English speakers (CONTRIBUTING.md),
for whom each one costs a dictionary lookup a plainer word avoids.

The script carries a word list with a plain alternative for each. A
genuine technical term with no plain equivalent is not a violation,
*idempotent*, *quiver*, *derivation*, and *monad* all stay.

## Procedure

1. Run `tools/scripts/check-plain-prose.sh` on the file.
2. Read the density verdict. Below 1.0 per 1000 words, leave it alone.
   Between 1.0 and 3.0, sweep the listed instances. Above 3.0, the habit
   runs through the whole file and the fix is a rewrite pass, not spot
   edits.
3. For each Habit A hit, apply the live-misreading test above.
4. For each Habit B hit, substitute the plain word unless it names a
   genuine technical concept the book already defines.
5. Re-run. The count is the gate, not a single read-through.

## This applies to the assistant's own output

The habit shows up in commit messages, PR descriptions, and replies to
the user, not only in chapter text, the same voice writes all of them.
Before sending a long reply or a commit message, check whether "not X …
Y" is carrying the argument. More than once or twice means rewrite into
direct statements.

## Meta

v1.0.0 (2026-09-07). Ported from `~/dev/research-ideas`'s
`plain-prose-repair` (v1.0.0, 2026-09-04) and adapted for this book's
Markdown chapters instead of LaTeX papers. Non-duplication checked
against `prose-style-reviewer` (owns possessives, em-dashes,
colon-explanations, comma pileups, filler words, spatial metaphors,
terminology drift); this skill adds the two-sentence antithesis count
and the dictionary-vocabulary list, which neither `prose-style-reviewer`
nor CONTRIBUTING.md's prose conventions cover.
