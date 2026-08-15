## Chapter 5: Tactics

[← Chapter 4](04-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](06-chapter-6.md)

---

**1. `theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P`**

```lean
theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P := by
  constructor
  · exact h.right
  · exact h.left
```

[`constructor`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) splits the goal `Q ∧ P` into two subgoals, `Q` and `P`, one for
each field of `And`. `h.right : Q` closes the first, and `h.left : P`
closes the second.

**2. `theorem nat_mul_zero (n : Nat) : n * 0 = 0`**

```lean
theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by
  rfl
```

[`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) does succeed here. `Nat.mul` is defined by recursion on its second
argument, and `n * 0 = 0` is the base clause. Hence this holds by definition,
with no induction required. Compare this with `0 * n = 0`, which is not a
base clause and does require induction on `n`.

**3. `modus_ponens` in tactic mode**

```lean
theorem modus_ponens_tac {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

`apply hpq` matches the goal `Q` against the conclusion of `hpq : P → Q`.
This leaves a new goal `P`, which `exact hp` closes.

**4. What changes between `rw` before and after induction**

Nothing about `rw` itself changes between the two attempts. What changes
is what is available to rewrite *with*. Before `induction b` is invoked,
there is no fact anywhere in context relating `a + b` and `b + a`, so
`rw` has nothing to substitute toward that goal. After `induction b`,
the `succ` case comes packaged with `ih : a + k = k + a`, an equation
Lean generated automatically from the recursive structure of `Nat`, and
`rw [ih]` uses exactly that fact. The tactic is the same in both cases;
the hypothesis context is not.

**5. `theorem nat_zero_mul (n : Nat) : 0 * n = 0`**

```lean
theorem nat_zero_mul (n : Nat) : 0 * n = 0 := by
  induction n with
  | zero => rfl
  | succ k ih =>
    rw [Nat.mul_succ, ih]
```

`Nat.mul` recurses on its *second* argument, exactly like `Nat.add`, so
`n * 0 = 0` (`nat_mul_zero`) is the base clause and closes by `rfl`
immediately, with no induction needed. `0 * n = 0` has the unknown `n`
sitting in the position the recursion inspects, so it is stuck for a
general `n` and needs an actual induction, mirroring the `0 + n = n`
case from Chapter 4. The base case `0 * 0 = 0` is `rfl`. The inductive
step rewrites `0 * (k+1)` to `0 * k + 0` via `Nat.mul_succ`, then uses
`ih : 0 * k = 0` to finish.

**6. A tactic that leaves the goal open without erroring**

Such a tactic is neither a success nor a failure; it is *progress to
inspect*. An error message says a tactic could not be applied at all.
No error, but no "No goals" message either, means the tactic did
something, rewrote, split, or simplified the goal, but did not finish
it. The only way to know what remains is to look at the resulting goal
state directly, in the editor or via a trailing `sorry`. This is exactly
why the goal state is checked after *every* tactic in this book, not
only at the very end: the absence of a red error is not evidence that
nothing is left to prove.

---

[← Chapter 4](04-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](06-chapter-6.md)
