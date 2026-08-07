## Chapter 5: Propositions and proofs

[← Chapter 3](02-chapter-2.md) | [Index](00-index.md) | [Next: Chapter 6 →](04-chapter-5.md)

---

**1. `theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P`**

```lean
theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P :=
  ⟨h.right, h.left⟩
```

`h : P ∧ Q` has fields `h.left : P` and `h.right : Q`. A proof of `Q ∧ P` is
just the pair with those two components in the opposite order.

**2. `theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P`**

```lean
theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P :=
  match h with
  | Or.inl hp => Or.inr hp
  | Or.inr hq => Or.inl hq
```

`Or` has two constructors, so any proof `h : P ∨ Q` was built with one of
them. `match` finds out which one, and the witness it carried. In the
`Or.inl hp` case we have `hp : P`, and `Or.inr hp : Q ∨ P` uses it as the
right disjunct. The `Or.inr hq` case works the same way, just mirrored.

**3. `theorem exists_gt_zero : ∃ n : Nat, n > 0`**

```lean
theorem exists_gt_zero : ∃ n : Nat, n > 0 :=
  ⟨1, by decide⟩
```

An `∃`-proof is a witness (`1`) paired with a proof that it satisfies the
predicate (`1 > 0`). Here [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) handles that proof, since `1 > 0` on
`Nat` is a decidable, closed proposition. We could also write
`⟨1, Nat.one_pos⟩`. Note that `⟨1, rfl⟩` does *not* work here: `1 > 0`
unfolds to `0 < 1`, i.e. the successor form of `Nat.le 1 1`, which is a
*propositional* fact proved by a constructor (`Nat.le.refl`), not something
`rfl` can close by definitional unfolding alone. This is the same
definitional-vs-propositional-equality distinction taught in Chapter 7.

---

[← Chapter 3](02-chapter-2.md) | [Index](00-index.md) | [Next: Chapter 6 →](04-chapter-5.md)
