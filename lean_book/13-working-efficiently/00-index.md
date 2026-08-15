# Chapter 13: Working efficiently in Lean

[← Ch. 12: Path Algebras](../12-path-algebras/00-index.md) | [Table of contents](../README.md) | [Ch. 14: Next Steps →](../14-next-steps/00-index.md)

---

## Learning objectives

- Use `exact?`/`apply?` to search for a known lemma or proof.
- Recognize when a goal falls inside the decidable fragment of `decide`/`omega`/`norm_num` versus needing a genuine hand proof.
- Know what `simp` trades away for speed.
- Choose between term mode and tactic mode for a given proof.
- Recognize when a sub-goal deserves its own named lemma.

## What efficiency means once the reasoning is understood

Chapters 8 and 10 found proofs by hand, deliberately slowly, so the
underlying reasoning was never hidden. Once the reason a proof works is
understood, the same fact should not have to be re-derived, by hand, every
time it recurs; the question left is how to write and find proofs faster
without losing that understanding. "Faster" does not mean "type less." A
lemma that already exists in the environment should be looked up, not
re-proved, hence the search tactics `exact?`/`apply?`
([Section 1](01-search-tactics.md)). A goal that reduces to a terminating
computation, decidable equality or inequality on `Nat`/`Int`, a concrete
numeral, should be settled by running that computation, `decide`, `omega`,
`norm_num`, rather than by a hand-built `rw` chain, exactly because a
decision procedure exists precisely where hand-derivation adds nothing a
human proof of the general case still needs
([Section 2](02-decision-procedures.md)). Once a family of rewrites is
understood well enough to be trusted as a set, applying that whole set at
once with `simp` is the efficient move, at the cost of not seeing which
member of the set actually fired ([Section 3](03-simp.md)). A short proof
reads better as a single term; a proof with several sequential steps or
case splits reads (and is written) better as a tactic script, so the
choice between term mode and tactic mode is about readability, not power
([Section 4](04-term-vs-tactic-mode.md)). And a sub-goal that already
recurs, or that states an independent mathematical fact in its own right,
should be pulled out and named once, so that every later proof of it is a
lookup rather than a re-derivation ([Section 5](05-structuring-lemmas.md)).

## Sections

1. [Search tactics: letting Lean find the lemma or the proof](01-search-tactics.md)
2. [Decision procedures: `decide`, `omega`, `norm_num`](02-decision-procedures.md)
3. [`simp`, in light of what it replaces](03-simp.md)
4. [Term mode vs tactic mode](04-term-vs-tactic-mode.md)
5. [Structuring lemmas for reuse](05-structuring-lemmas.md)

---

[← Ch. 12: Path Algebras](../12-path-algebras/00-index.md) | [Table of contents](../README.md) | [Ch. 14: Next Steps →](../14-next-steps/00-index.md)
