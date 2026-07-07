## Chapter 4: Tactics

[← Chapter 3](01-chapter-3.md) | [Index](00-index.md) | [Next: Chapter 5 →](03-chapter-5.md)

---

**1. `theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P`**

```lean
theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P := by
  constructor
  · exact h.right
  · exact h.left
```

`constructor` reduces the goal `Q ∧ P` to two subgoals, `Q` and `P`, one for
each field of `And`. `h.right : Q` and `h.left : P` close them respectively.

**2. `theorem nat_mul_zero (n : Nat) : n * 0 = 0`**

```lean
theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by
  rfl
```

`rfl` *does* work here: `Nat.mul` is defined by recursion on its second
argument with `n * 0 = 0` as the base clause, so this holds definitionally,
with no induction needed (contrast with `0 * n = 0`, which is not a base
clause and does need induction on `n`).

**3. `modus_ponens` in tactic mode**

```lean
theorem modus_ponens_tac {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

`apply hpq` matches the goal `Q` against the conclusion of `hpq : P → Q`,
leaving a new goal `P`, closed by `exact hp`.

---

[← Chapter 3](01-chapter-3.md) | [Index](00-index.md) | [Next: Chapter 5 →](03-chapter-5.md)
