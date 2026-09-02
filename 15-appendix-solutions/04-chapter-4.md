## Chapter 4: Propositions and proofs

[← Chapter 3](03-chapter-3.md) | [Index](00-index.md) | [Next: Chapter 5 →](05-chapter-5.md)

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
definitional-vs-propositional-equality distinction taught in Chapter 6.

**4. Why `∧` needs one constructor and `∨` needs two**

A proof of `P ∧ Q` must supply *both* a proof of `P` and a proof of `Q`
at once, so a single shape, the pair `⟨hp, hq⟩`, suffices, there is only
one way to have both. A proof of `P ∨ Q` supplies *only one* of the two,
so the proof itself must record which side was chosen, else two
genuinely different proofs (of `P` and of `Q`) would be indistinguishable
from the outside. Hence two distinct constructors, `Or.inl` tagging a
proof of `P`, `Or.inr` tagging a proof of `Q`, are required, one per
possible choice.

**5. `n + 0 = n` by `rfl`, but not `0 + n = n`**

```lean
theorem nat_add_zero (n : Nat) : n + 0 = n := rfl
```

`Nat.add` recurses on its *second* argument. `n + 0 = n` is exactly the
base clause of that recursion, so both sides already reduce to the same
term regardless of what `n` is, and `rfl` closes it immediately. `0 + n =
n`, by contrast, has the unknown `n` in the position the recursion
inspects. With `n` unevaluated, `0 + n` is stuck, it cannot unfold
further without first knowing whether `n` is `0` or a successor, so no
amount of definitional unfolding alone identifies it with `n`. This gap
between "true" and "reduces to the same term" (definitional vs.
propositional equality, discussed fully in Chapter 6) is exactly why
`0 + n = n` needs an inductive proof, not `rfl`; Chapter 5 supplies the
`induction` tactic that closes it.

**6. Why no finite set of witnesses proves `∀ n, n > 0`**

A witness-and-proof pair `⟨a, h⟩` establishes only that *some* specific
`a` satisfies the property, `∃`-statements ask for exactly one instance.
`∀ n, n > 0` demands the property hold for *every* `n`, and `Nat` is
infinite, so no finite list of individually checked instances can rule
out a counterexample among the infinitely many left unchecked. What is
needed instead is an argument uniform in `n`, one that establishes the
claim for an arbitrary, unconstrained `n` without inspecting each value
separately. That is exactly what induction provides, and Chapter 5
introduces the `induction` tactic that carries out such arguments in
Lean.

---

[← Chapter 3](03-chapter-3.md) | [Index](00-index.md) | [Next: Chapter 5 →](05-chapter-5.md)
