## Exercises

[← Worked example](05-worked-example.md) | [Index](00-index.md)

---

1. Prove `theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P := by ...`
   using `constructor`, `h.left`, `h.right`.
2. Prove `theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by rfl` — check
   whether `rfl` alone works, and if not, use `induction`.
3. Rewrite the `modus_ponens` proof from Chapter 3 in tactic mode.

Solutions: [Appendix, Chapter 4](../14-appendix-solutions/02-chapter-4.md).

With definitions, propositions, and tactics in hand, we pause for a brief
rigor check before diving into groups: continue to
[Chapter 5: Rigor check](../05-rigor-check/00-index.md).

---

[← Worked example](05-worked-example.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 5: Rigor Check →](../05-rigor-check/00-index.md)
