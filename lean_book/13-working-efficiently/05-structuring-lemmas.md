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

This is the same judgment call made writing ordinary code:
extract a helper when, and only when, real duplication or a
genuinely separate sub-claim is present, not ahead of time "just in case."

**Key points.** `exact?`/`apply?` search for a closing term but do not
always find the shortest one. `decide`/`omega`/`norm_num` replace a hand
proof exactly on their decidable fragment, never on a goal about a
generic, unspecified structure. `simp` trades traceability for speed, so
this book reaches for it only when a genuine technical obstacle makes the
explicit alternative not worth the detour. And a repeated `rw` chain or an
independently-statable sub-goal is a lemma waiting to be named.

**Socratic questions.**

1. *`exact?` sometimes returns a working but needlessly roundabout term
   instead of the shortest one (the worked example of Chapter 13, Section 1 itself).
   Does that make it a poor tool to reach for?* No. It still guarantees
   a *correct* closing term, found automatically. Simplifying what it
   returns by hand afterward is a small, separate step, cheaper than
   deriving the whole thing from nothing.
2. *`decide` and a hand-written proof can close the exact same goal on a
   finite carrier like `Fin 3`. `fin3Group`/`fin3Ring` from Chapter 9 already
   used `decide` this way. If it was already in use back then, what does
   this chapter actually add?* Chapter 9 used `decide` on one specific
   example, without stopping to say *why* it applied there. This chapter
   turns that one-off use into a general principle: recognizing which
   regime a goal is in, a finite, concretely enumerable carrier where
   `decide` applies, versus a general, unspecified structure (an arbitrary
   `Group G` or `Ring R`, as in Chapters 8 and 10) where no decision
   procedure applies and a hand-built proof is the only option. Knowing
   *when* to reach for `decide` is the skill; using it once, correctly, is
   not yet that skill.
3. *A repeated `rw` chain is a sign a lemma should be factored out. Is
   the reverse also true, should every proof be split into the smallest
   possible named lemmas, just in case one gets reused later?* No.
   Speculative extraction with no present duplication is the same
   mistake in the opposite direction: three similar lines are better
   than a premature abstraction. The signal to extract is an actual
   repeated shape or an actual independently-statable sub-claim, not the
   mere possibility of future reuse.

## Next

Continue to [Chapter 14: Where to go next](../14-next-steps/00-index.md).

---

[← Term mode vs tactic mode](04-term-vs-tactic-mode.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 14: Next Steps →](../14-next-steps/00-index.md)
