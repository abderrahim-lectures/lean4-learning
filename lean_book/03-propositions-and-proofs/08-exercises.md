## Exercises

[← Equality reasoning](07-equality.md) | [Index](00-index.md)

---

1. Prove `theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P`.
2. Prove `theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P` (hint: use
   `Or.elim` or pattern matching with `match`).
3. Prove `theorem exists_gt_zero : ∃ n : Nat, n > 0`.

Solutions: [Appendix, Chapter 3](../14-appendix-solutions/02-chapter-3.md).

## Next

Continue to [Chapter 4: Tactics](../04-tactics/00-index.md).

---

[← Equality reasoning](07-equality.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 4: Tactics →](../04-tactics/00-index.md)
