## Exercises

[← Equality reasoning](07-equality.md) | [Index](00-index.md)

---

**Key points.** `Prop` is the type of statements, and a proof is just an
ordinary term of that type (Curry–Howard). `∧`/`∨`/`→`/`∀`/`∃` each have
their own introduction and elimination rule, mirrored directly by Lean
syntax: the anonymous constructor, `Or.inl`/`Or.inr`/`match`, `fun`/
application, and `fun`/anonymous-constructor again. `rfl` proves equality
by checking both sides reduce to the same normal form.

**Socratic questions.**

1. *`P ∧ Q` and `P ∨ Q` are both built from two propositions. Why does
   `∧` need only one constructor (the anonymous pair) while `∨` needs
   two (`Or.inl`, `Or.inr`)?* A proof of `P ∧ Q` must supply *both* a
   proof of `P` and a proof of `Q` at once — one shape suffices. A proof
   of `P ∨ Q` supplies *only one* of the two, so the proof itself must
   record which side was chosen — hence two distinct constructors rather
   than one.
2. *`rfl` closes `2 + 2 = 4` immediately. Why can it not, by the same
   reasoning, close `∀ n, n + 0 = n`?* `rfl` checks that both sides
   already reduce to the same closed term — `2 + 2` and `4` both compute
   to the literal `4`. But `n` is a free variable, not a number to
   compute with; `n + 0 = n` is true for every `n`, yet no single
   reduction sequence turns `n + 0` into `n` without first knowing which
   `n` it is. That gap between "true" and "reduces to the same term" is
   exactly why proofs, not mere computation, exist.
3. *`∃ n, n > 0` was proved with a witness and a decided fact about it.
   What would go wrong trying to prove `∀ n, n > 0` the same way, by
   picking one `n` and checking it?* A single witness proves only that
   *some* `n` works — universal quantification demands the property hold
   for *every* `n` at once, which no finite number of individual checks
   can establish; it needs a genuine argument (an inductive proof,
   starting in Chapter 4) that works uniformly.

1. Prove `theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P`.
2. Prove `theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P` (hint: use
   `Or.elim` or pattern matching with `match`).
3. Prove `theorem exists_gt_zero : ∃ n : Nat, n > 0`.

Solutions: [Appendix, Chapter 3](../14-appendix-solutions/02-chapter-3.md).

## Next

Continue to [Chapter 4: Tactics](../04-tactics/00-index.md).

---

[← Equality reasoning](07-equality.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 4: Tactics →](../04-tactics/00-index.md)
