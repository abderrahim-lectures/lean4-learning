## Exercises

[← Worked example](05-worked-example.md) | [Index](00-index.md)

---

**Key points.** A goal is hypotheses above a line, a statement to prove
below it; a tactic replaces it with zero or more simpler goals. The core
loop is to try the cheapest tactic, read why it failed, find structure to
split or induct on, and locate the specific lemma that matches. `induction`
generates one case (and hypothesis `ih`) per constructor, exactly
mirroring a recursive function over the same type.

1. Prove `theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P := by ...`
   using [`constructor`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), `h.left`, `h.right`.
2. Prove `theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by rfl`. Check
   whether [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) alone works, and if not, use [`induction`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/).
3. Rewrite the `modus_ponens` proof from Chapter 4 in tactic mode.
4. `rw [Nat.add_succ]` and the rest closed the `succ` case of
   `my_add_comm`, but `rw` on its own cannot touch `a + b = b + a` before
   any induction is performed. Explain precisely what changes between the
   two situations, in terms of what is available to rewrite *with*.
5. `nat_mul_zero (n : Nat) : n * 0 = 0` closes by `rfl` alone. Determine
   whether `theorem nat_zero_mul (n : Nat) : 0 * n = 0` also closes by
   `rfl`, and prove it by whichever means is required, justifying the
   choice from the recursive definition of `Nat.mul`.
6. A tactic that produces no error but also does not close the goal is
   neither a success nor a failure. Explain what it does mean, and why
   the goal state, not the presence or absence of a red error message, is
   the thing to check after every tactic.

Solutions, [Appendix, Chapter 5](../15-appendix-solutions/05-chapter-5.md).

With definitions, propositions, and tactics in hand, we pause for a brief
rigor check before diving into groups.

---

[← Worked example](05-worked-example.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 6: Rigor Check →](../06-rigor-check/00-index.md)
