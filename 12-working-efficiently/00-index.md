# Chapter 12: Working efficiently in Lean

[← Ch. 11: Path Algebras](../11-path-algebras/00-index.md) | [Table of contents](../README.md) | [Ch. 13: Next Steps →](../13-next-steps/00-index.md)

---

Chapters 7 and 9 were about *finding* a proof by hand, deliberately slowly,
so the underlying reasoning is never hidden. This chapter addresses the
other half: once the reason a proof works is understood, how is it written
(and found) faster in day-to-day use? Efficient Lean does not mean "type
less." It means knowing which automation to trust, knowing when it is
still worth being explicit, and knowing how to structure lemmas so that the
same fact is not derived twice. (For links to the official docs for
every tactic and Mathlib name in this book, see the
[tactic and library reference](../tactic-and-library-reference.md).)

**Learning objectives.** By the end of this chapter, use `exact?`/`apply?`
to search for a known lemma or proof, recognize when a goal falls inside
`decide`/`omega`/`norm_num`'s decidable fragment versus needing a genuine
hand proof, know what `simp` trades away for speed, choose between term
mode and tactic mode for a given proof, and recognize when a sub-goal
deserves its own named lemma.

## Sections

1. [Search tactics: letting Lean find the lemma or the proof](01-search-tactics.md)
2. [Decision procedures: `decide`, `omega`, `norm_num`](02-decision-procedures.md)
3. [`simp`, in light of what it replaces](03-simp.md)
4. [Term mode vs tactic mode](04-term-vs-tactic-mode.md)
5. [Structuring lemmas for reuse](05-structuring-lemmas.md)

---

[← Ch. 11: Path Algebras](../11-path-algebras/00-index.md) | [Table of contents](../README.md) | [Ch. 13: Next Steps →](../13-next-steps/00-index.md)
