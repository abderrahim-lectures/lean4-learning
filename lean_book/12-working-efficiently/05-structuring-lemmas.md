## Structuring lemmas for reuse

[← Term mode vs tactic mode](04-term-vs-tactic-mode.md) | [Index](00-index.md)

---

Here is the single biggest efficiency gain, bigger than any tactic choice:
**prove the general fact once, as its own named lemma, as soon as you
notice you would otherwise repeat an argument.** Chapter 7's
`left_inverse_unique` is the running example. Theorem 3 (`inv_op`) and
this chapter's `neg_one_mul` and `neg_mul` all reduce to it, instead of
re-deriving "uniqueness of inverses" inline. Signs that you should factor
out a lemma:

- You are about to repeat a [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) chain you already wrote for a different
  but structurally identical goal. Stop, and instead state the shared
  shape as its own `theorem`/`have`, then `apply`/`exact` it in both
  places.
- A sub-goal deep in a proof would itself be a reasonable, independently
  statable mathematical fact (for example, "an element that equals its
  own double is zero," buried inside Chapter 9's `mul_zero`). Naming it
  is both more efficient *and* more readable, since the outer proof then
  reads as a short chain of named facts instead of one long
  undifferentiated block.

This is the same judgment call you would make writing ordinary code:
extract a helper when — and only when — you notice real duplication or a
genuinely separate sub-claim, not ahead of time "just in case."

## Next

Continue to [Chapter 13: Where to go next](../13-next-steps/00-index.md).

---

[← Term mode vs tactic mode](04-term-vs-tactic-mode.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 13: Next Steps →](../13-next-steps/00-index.md)
