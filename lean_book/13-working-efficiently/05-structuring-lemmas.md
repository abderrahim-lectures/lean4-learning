## Structuring lemmas for reuse

[← Term mode vs tactic mode](04-term-vs-tactic-mode.md) | [Index](00-index.md)

---

The single biggest efficiency gain, greater than any tactic choice, is to
**prove the general fact once, as its own named lemma, as soon as an
argument would otherwise be repeated.** `left_inverse_unique` from Chapter 8
is the running example. Theorem 3 (`inv_op`) and
`neg_one_mul` and `neg_mul` from Chapter 10 all reduce to it, instead of
re-deriving "uniqueness of inverses" inline. Signs that a lemma should be
factored out are as follows.

- A [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) chain already written for a different
  but structurally identical goal is about to be repeated. In that case, the shared
  shape should instead be stated as its own `theorem`/`have`, then applied via `apply`/`exact` in both
  places.
- A sub-goal deep in a proof would itself be a reasonable, independently
  statable mathematical fact (for example, "an element that equals its
  own double is zero," buried inside `mul_zero` of Chapter 10). Naming it
  is both more efficient *and* more readable, since the outer proof then
  reads as a short chain of named facts instead of one long
  undifferentiated block.

This is the same judgment call made writing ordinary code,
extract a helper when, and only when, real duplication or a
genuinely separate sub-claim is present, not ahead of time "just in case."

**Key points.** `exact?`/`apply?` search for a closing term but do not
always find the shortest one, a correct but roundabout result is still
worth simplifying by hand afterward, and still cheaper to obtain that way
than by deriving the whole term from nothing.
`decide`/`omega`/`norm_num` replace a hand proof exactly on their
decidable fragment: a finite, concretely enumerable carrier such as the
`Fin 3` of `fin3Group`/`fin3Ring` (Chapter 9), never a goal about a
generic, unspecified structure such as an arbitrary `Group G` or `Ring R`
(Chapters 8 and 10), where no decision procedure applies and a hand-built
proof is the only option. `simp` trades traceability for speed, so this
book reaches for it only when a genuine technical obstacle makes the
explicit alternative not worth the detour. A repeated `rw` chain or an
independently-statable sub-goal is a lemma waiting to be named, but the
converse is not a rule, splitting every proof into the smallest possible
named lemmas on the mere *possibility* of future reuse is the same
mistake in the opposite direction; three similar lines are better than a
premature abstraction, and the signal to extract is an actual repeated
shape or an actual independently-statable sub-claim, not speculation.

## Next

Continue to [Chapter 14: Where to go next](../14-next-steps/00-index.md).

---

[← Term mode vs tactic mode](04-term-vs-tactic-mode.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 14: Next Steps →](../14-next-steps/00-index.md)
