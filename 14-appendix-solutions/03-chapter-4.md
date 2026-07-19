## Chapter 4: Tactics

[← Chapter 3](02-chapter-3.md) | [Index](00-index.md) | [Next: Chapter 5 →](04-chapter-5.md)

---

**1. `theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P`**

<p><a href="https://live.lean-lang.org/#code=theorem%20and_comm_tac%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%20by%0A%20%20constructor%0A%20%20%C2%B7%20exact%20h.right%0A%20%20%C2%B7%20exact%20h.left" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20and_comm_tac%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%20by%0A%20%20constructor%0A%20%20%C2%B7%20exact%20h.right%0A%20%20%C2%B7%20exact%20h.left" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

[`constructor`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) splits the goal `Q ∧ P` into two subgoals, `Q` and `P`, one for
each field of `And`. `h.right : Q` closes the first, and `h.left : P`
closes the second.

**2. `theorem nat_mul_zero (n : Nat) : n * 0 = 0`**

<p><a href="https://live.lean-lang.org/#code=theorem%20nat_mul_zero%20%28n%20%3A%20Nat%29%20%3A%20n%20%2A%200%20%3D%200%20%3A%3D%20by%0A%20%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20nat_mul_zero%20%28n%20%3A%20Nat%29%20%3A%20n%20%2A%200%20%3D%200%20%3A%3D%20by%0A%20%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

[`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) does succeed here. `Nat.mul` is defined by recursion on its second
argument, and `n * 0 = 0` is the base clause. Hence this holds by definition,
with no induction required. Compare this with `0 * n = 0`, which is not a
base clause and does require induction on `n`.

**3. `modus_ponens` in tactic mode**

<p><a href="https://live.lean-lang.org/#code=theorem%20modus_ponens_tac%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%20by%0A%20%20apply%20hpq%0A%20%20exact%20hp" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20modus_ponens_tac%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%20by%0A%20%20apply%20hpq%0A%20%20exact%20hp" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`apply hpq` matches the goal `Q` against the conclusion of `hpq : P → Q`.
This leaves a new goal `P`, which `exact hp` closes.

---

[← Chapter 3](02-chapter-3.md) | [Index](00-index.md) | [Next: Chapter 5 →](04-chapter-5.md)
