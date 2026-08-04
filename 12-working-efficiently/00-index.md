# Chapter 12: Working efficiently in Lean

[← Ch. 11: Path Algebras](../11-path-algebras/00-index.md) | [Table of contents](../README.md) | [Ch. 13: Next Steps →](../13-next-steps/00-index.md)

---

## Learning objectives

- Use `exact?`/`apply?` to search for a known lemma or proof.
- Recognize when a goal falls inside `decide`/`omega`/`norm_num`'s decidable fragment versus needing a genuine hand proof.
- Know what `simp` trades away for speed.
- Choose between term mode and tactic mode for a given proof.
- Recognize when a sub-goal deserves its own named lemma.

## The story of this chapter

Chapters 7 and 9 were about *finding* a proof by hand, deliberately slowly,
so the underlying reasoning is never hidden. This chapter addresses the
other half: once the reason a proof works is understood, how is it written
(and found) faster in day-to-day use? Efficient Lean does not mean "type
less." It means knowing which automation to trust, knowing when it is
still worth being explicit, and knowing how to structure lemmas so that
the same fact is not derived twice. Each section below asks one question
about that trade-off:

1. What if Lean already knows the lemma or the proof you need — can it just
   find it for you?
2. When is a goal so mechanical that full automation (`decide`, `omega`,
   `norm_num`) is the right call, and when does the search still need
   human hands?
3. `simp` rewrites thousands of steps at once — but what exactly does it
   trade away for that speed, and when should you decline the trade?
4. Should every proof be written as a tactic script, or are some of them
   clearer as a single term?
5. After a fact is proved once, how do you package it so the next proof
   that needs it is a lookup, not a re-derivation?

## Sections

1. [Search tactics: letting Lean find the lemma or the proof](01-search-tactics.md)
2. [Decision procedures: `decide`, `omega`, `norm_num`](02-decision-procedures.md)
3. [`simp`, in light of what it replaces](03-simp.md)
4. [Term mode vs tactic mode](04-term-vs-tactic-mode.md)
5. [Structuring lemmas for reuse](05-structuring-lemmas.md)

---

[← Ch. 11: Path Algebras](../11-path-algebras/00-index.md) | [Table of contents](../README.md) | [Ch. 13: Next Steps →](../13-next-steps/00-index.md)
