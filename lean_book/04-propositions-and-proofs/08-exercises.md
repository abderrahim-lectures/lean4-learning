## Exercises

[← Equality reasoning](07-equality.md) | [Index](00-index.md)

---

**Key points.** `Prop` is the type of statements, and a proof is just an
ordinary term of that type (Curry–Howard). `∧`/`∨`/`→`/`∀`/`∃` each have
their own introduction and elimination rule, mirrored directly by Lean
syntax, the anonymous constructor, `Or.inl`/`Or.inr`/`match`, `fun`/
application, and `fun`/anonymous-constructor again. `rfl` proves equality
by checking both sides reduce to the same normal form.

1. Prove `theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P`.
2. Prove `theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P` (hint, use
   `Or.elim` or pattern matching with `match`).
3. Prove `theorem exists_gt_zero : ∃ n : Nat, n > 0`.
4. `P ∧ Q` has a single constructor, the anonymous pair; `P ∨ Q` has two,
   `Or.inl` and `Or.inr`. State precisely what data a proof of each
   connective must carry, and show that this difference in data forces
   the difference in constructor count.
5. Show that `rfl` proves `theorem nat_add_zero (n : Nat) : n + 0 = n`
   but cannot prove `∀ n, 0 + n = n` by the same route. Identify the
   clause of `Nat.add`'s recursion responsible for the asymmetry.
6. `exists_prime_gt_three` (Section 6) was proved with one witness and a
   decided fact about it. Explain why no finite number of such
   witness-and-proof pairs could ever establish `∀ n, n > 0`, and name
   the kind of argument that Chapter 5 introduces to close this gap.

Solutions, [Appendix, Chapter 4](../15-appendix-solutions/04-chapter-4.md).

## Next

Continue to [Chapter 5: Tactics](../05-tactics/00-index.md).

---

[← Equality reasoning](07-equality.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 5: Tactics →](../05-tactics/00-index.md)
