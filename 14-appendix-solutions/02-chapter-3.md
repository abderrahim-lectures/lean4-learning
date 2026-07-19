## Chapter 3: Propositions and proofs

[← Index](00-index.md) | [Next: Chapter 4 →](03-chapter-4.md)

---

**1. `theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P`**

<p><a href="https://live.lean-lang.org/#code=theorem%20and_comm_ex%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20and_comm_ex%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`h : P ∧ Q` has fields `h.left : P` and `h.right : Q`. A proof of `Q ∧ P` is
just the pair with those two components in the opposite order.

**2. `theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P`**

<p><a href="https://live.lean-lang.org/#code=theorem%20or_comm_ex%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A8%20Q%29%20%3A%20Q%20%E2%88%A8%20P%20%3A%3D%0A%20%20match%20h%20with%0A%20%20%7C%20Or.inl%20hp%20%3D%3E%20Or.inr%20hp%0A%20%20%7C%20Or.inr%20hq%20%3D%3E%20Or.inl%20hq" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20or_comm_ex%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A8%20Q%29%20%3A%20Q%20%E2%88%A8%20P%20%3A%3D%0A%20%20match%20h%20with%0A%20%20%7C%20Or.inl%20hp%20%3D%3E%20Or.inr%20hp%0A%20%20%7C%20Or.inr%20hq%20%3D%3E%20Or.inl%20hq" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`Or` has two constructors, so any proof `h : P ∨ Q` was built with one of
them. `match` finds out which one, and the witness it carried. In the
`Or.inl hp` case we have `hp : P`, and `Or.inr hp : Q ∨ P` uses it as the
right disjunct. The `Or.inr hq` case works the same way, just mirrored.

**3. `theorem exists_gt_zero : ∃ n : Nat, n > 0`**

<p><a href="https://live.lean-lang.org/#code=theorem%20exists_gt_zero%20%3A%20%E2%88%83%20n%20%3A%20Nat%2C%20n%20%3E%200%20%3A%3D%0A%20%20%E2%9F%A81%2C%20by%20decide%E2%9F%A9" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20exists_gt_zero%20%3A%20%E2%88%83%20n%20%3A%20Nat%2C%20n%20%3E%200%20%3A%3D%0A%20%20%E2%9F%A81%2C%20by%20decide%E2%9F%A9" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

An `∃`-proof is a witness (`1`) paired with a proof that it satisfies the
predicate (`1 > 0`). Here [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) handles that proof, since `1 > 0` on
`Nat` is a decidable, closed proposition. We could also write
`⟨1, Nat.one_pos⟩` or `⟨1, rfl⟩` (since `1 > 0` unfolds to `0 < 1`, i.e.
`Nat.succ 0 ≤ 1`, which is true by definition).

---

[← Index](00-index.md) | [Next: Chapter 4 →](03-chapter-4.md)
