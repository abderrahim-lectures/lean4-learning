## Structuring lemmas for reuse

[← Term mode vs tactic mode](04-term-vs-tactic-mode.md) | [Index](00-index.md)

---

The single biggest efficiency gain, greater than any tactic choice, is to
**prove the general fact once, as its own named lemma, as soon as an
argument would otherwise be repeated.** Chapter 7's
`left_inverse_unique` is the running example. Theorem 3 (`inv_op`) and
Chapter 9's `neg_one_mul` and `neg_mul` all reduce to it, instead of
re-deriving "uniqueness of inverses" inline. Signs that a lemma should be
factored out:

- A [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) chain already written for a different
  but structurally identical goal is about to be repeated. In that case, the shared
  shape should instead be stated as its own `theorem`/`have`, then applied via `apply`/`exact` in both
  places.
- A sub-goal deep in a proof would itself be a reasonable, independently
  statable mathematical fact (for example, "an element that equals its
  own double is zero," buried inside Chapter 9's `mul_zero`). Naming it
  is both more efficient *and* more readable, since the outer proof then
  reads as a short chain of named facts instead of one long
  undifferentiated block.

This is the same judgment call made writing ordinary code:
extract a helper when — and only when — real duplication or a
genuinely separate sub-claim is present, not ahead of time "just in case."

**Key points.** `exact?`/`apply?` search for a closing term but do not
always find the shortest one; `decide`/`omega`/`norm_num` replace a hand
proof exactly on their decidable fragment, never on a goal about a
generic, unspecified structure; `simp` trades traceability for speed, so
this book reaches for it only when a genuine technical obstacle makes the
explicit alternative not worth the detour; and a repeated `rw` chain or an
independently-statable sub-goal is a lemma waiting to be named.

## Next

Continue to [Chapter 13: Where to go next](../13-next-steps/00-index.md).

---

[← Term mode vs tactic mode](04-term-vs-tactic-mode.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 13: Next Steps →](../13-next-steps/00-index.md)
