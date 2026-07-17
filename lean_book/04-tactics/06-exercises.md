## Exercises

[← Worked example](05-worked-example.md) | [Index](00-index.md)

---

**Key points.** A goal is hypotheses above a line, a statement to prove
below it; a tactic replaces it with zero or more simpler goals. The core
loop is: try the cheapest tactic, read why it failed, find structure to
split or induct on, locate the specific lemma that matches. `induction`
generates one case (and hypothesis `ih`) per constructor, exactly
mirroring a recursive function over the same type.

**Socratic questions.**

1. *`rw` rewrote `Nat.add_succ` and closed the `succ` case of
   `my_add_comm`, but the same tactic failed on `a + b = b + a` before any
   induction. What changed between the two attempts?* Nothing about `rw`
   itself — what changed is what is available to rewrite *with*. Before
   induction there is no fact relating `a + b` and `b + a` at all; after
   `induction b`, the `succ` case comes with `ih : a + k = k + a` already
   in hand, giving `rw` something to substitute.
2. *A tactic that produces no error but also does not close the goal —
   is that a success or a failure?* Neither, and treating it as either is
   the mistake. It is progress to inspect: the goal state after the
   tactic is the actual source of truth, not the absence of a red
   error message. This is precisely why the goal state is checked after
   *every* tactic, not just at the end.
3. *`nat_mul_zero (n : Nat) : n * 0 = 0` closes by `rfl` alone. Would
   `0 * n = 0` also close by `rfl`?* No — `Nat.mul` recurses on its
   *second* argument, exactly like `Nat.add`, so `n * 0 = 0` is the base
   clause (immediate), while `0 * n = 0` needs an actual induction on
   `n`, for the same left/right-asymmetry reason `0 + n = n` did earlier
   in this chapter.

1. Prove `theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P := by ...`
   using [`constructor`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), `h.left`, `h.right`.
2. Prove `theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by rfl` — check
   whether [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) alone works, and if not, use [`induction`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/).
3. Rewrite the `modus_ponens` proof from Chapter 3 in tactic mode.

Solutions: [Appendix, Chapter 4](../14-appendix-solutions/03-chapter-4.md).

With definitions, propositions, and tactics in hand, we pause for a brief
rigor check before diving into groups. Continue to
[Chapter 5: Rigor check](../05-rigor-check/00-index.md).

---

[← Worked example](05-worked-example.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 5: Rigor Check →](../05-rigor-check/00-index.md)
