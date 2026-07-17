## Exercises

[← Equality reasoning](07-equality.md) | [Index](00-index.md)

---

**Key points.** `Prop` is the type of statements, and a proof is just an
ordinary term of that type (Curry–Howard). `∧`/`∨`/`→`/`∀`/`∃` each have
their own introduction and elimination rule, mirrored directly by Lean
syntax: the anonymous constructor, `Or.inl`/`Or.inr`/`match`, `fun`/
application, and `fun`/anonymous-constructor again. `rfl` proves equality
by checking both sides reduce to the same normal form.

1. Prove `theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P`.
2. Prove `theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P` (hint: use
   `Or.elim` or pattern matching with `match`).
3. Prove `theorem exists_gt_zero : ∃ n : Nat, n > 0`.

Solutions: [Appendix, Chapter 3](../14-appendix-solutions/02-chapter-3.md).

## Next

Continue to [Chapter 4: Tactics](../04-tactics/00-index.md).

---

[← Equality reasoning](07-equality.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 4: Tactics →](../04-tactics/00-index.md)
