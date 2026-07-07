## Universal and existential quantifiers

[← And, Or, Not](04-and-or-not.md) | [Index](00-index.md) | [Next: Equality reasoning →](06-equality.md)

---

```lean
theorem all_nats_ge_zero : ∀ n : Nat, n ≥ 0 :=
  fun n => Nat.zero_le n

theorem exists_even : ∃ n : Nat, n % 2 = 0 :=
  ⟨0, rfl⟩
```

- `∀ x : α, P x` is again just a (dependent) function type: given any `x`,
  produce a proof of `P x`.
- `∃ x : α, P x` is a structure: a **witness** value plus a proof that the
  witness satisfies `P`.

**Mathematical reading.** The two quantifiers are the dependent product and
dependent sum over the family $P : \alpha \to \mathrm{Prop}$. Universal
quantification is the $\Pi$-type
$$
\forall x{:}\alpha,\ P(x) \;=\; \prod_{x : \alpha} P(x),
$$
a section of the family — a proof is a function $x \mapsto (\text{proof of }
P(x))$, so `all_nats_ge_zero` is the map $n \mapsto (0 \le n)$. Existential
quantification is the $\Sigma$-type
$$
\exists x{:}\alpha,\ P(x) \;=\; \sum_{x : \alpha} P(x),
$$
whose elements are dependent pairs $\langle a, h\rangle$ with $a \in \alpha$
the witness and $h : P(a)$ — here $\langle 0, \mathrm{refl}\rangle$
witnessing $0 \bmod 2 = 0$. This is the constructive $\exists$: to assert
existence you must exhibit an explicit witness, mirroring $\Sigma$ as the
total space $\coprod_{x} P(x)$ of the family.

---

[← And, Or, Not](04-and-or-not.md) | [Index](00-index.md) | [Next: Equality reasoning →](06-equality.md)
