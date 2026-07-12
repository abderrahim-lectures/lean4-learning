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

`constructor` splits the goal `Q ∧ P` into two subgoals, `Q` and `P`, one for
each field of `And`. `h.right : Q` closes the first, and `h.left : P`
closes the second.

**2. `theorem nat_mul_zero (n : Nat) : n * 0 = 0`**

```lean
theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by
  rfl
```

`rfl` *does* work here. `Nat.mul` is defined by recursion on its second
argument, and `n * 0 = 0` is the base clause. So this holds by definition,
with no induction needed. Compare this with `0 * n = 0`, which is not a
base clause and does need induction on `n`.

**3. `modus_ponens` in tactic mode**

```lean
theorem modus_ponens_tac {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

`apply hpq` matches the goal `Q` against the conclusion of `hpq : P → Q`.
This leaves a new goal `P`, which `exact hp` closes.

---

[← Chapter 3](01-chapter-3.md) | [Index](00-index.md) | [Next: Chapter 5 →](03-chapter-5.md)
