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

**Mathematical reading.** The two quantifiers are the "indexed" versions of
the product and sum you already saw for $\wedge$ and $\vee$ in the
previous section — instead of combining two fixed propositions $P$ and
$Q$, they combine a whole *family* of propositions $P(x)$, one for each
$x \in \alpha$. Universal quantification is the ($\Pi$-)type
$$
\forall x{:}\alpha,\ P(x) \;=\; \prod_{x : \alpha} P(x),
$$
literally an $\alpha$-indexed product: a proof is a function assigning to
each $x$ a proof of $P(x)$, so `all_nats_ge_zero` is the map $n \mapsto (0
\le n)$ — exactly generalizing how a proof of $P \wedge Q$ was a pair
$(p, q)$, one component per conjunct, except now there is one component
per element of $\alpha$ rather than just two. Existential quantification
is the ($\Sigma$-)type
$$
\exists x{:}\alpha,\ P(x) \;=\; \sum_{x : \alpha} P(x),
$$
an $\alpha$-indexed sum: a proof is a dependent pair $\langle a, h\rangle$
with $a \in \alpha$ the witness and $h : P(a)$ — here $\langle 0,
\mathrm{refl}\rangle$ witnesses $0 \bmod 2 = 0$. This is the
*constructive* reading of $\exists$: to assert existence you must exhibit
an explicit witness $a$ together with a proof $h$ that it works, exactly
generalizing how a proof of $P \vee Q$ was a tagged choice — except now
the "tag" is which element of $\alpha$ was chosen.

---

[← And, Or, Not](04-and-or-not.md) | [Index](00-index.md) | [Next: Equality reasoning →](06-equality.md)
