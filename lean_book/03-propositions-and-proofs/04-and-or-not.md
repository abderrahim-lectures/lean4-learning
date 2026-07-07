## And, Or, Not

[← Implication](03-implication.md) | [Index](00-index.md) | [Next: Quantifiers →](05-quantifiers.md)

---

```lean
-- And
theorem and_example {P Q : Prop} (hp : P) (hq : Q) : P ∧ Q :=
  ⟨hp, hq⟩

theorem and_left {P Q : Prop} (h : P ∧ Q) : P :=
  h.left

-- Or
theorem or_example {P Q : Prop} (hp : P) : P ∨ Q :=
  Or.inl hp

-- Not, i.e. P → False
theorem not_example : ¬(1 = 2) :=
  fun h => Nat.noConfusion h
```

- `∧` (And) is a structure with two fields `left` and `right`; `⟨hp, hq⟩` is
  anonymous-constructor sugar, same as for any structure.
- `∨` (Or) has two constructors, `Or.inl` and `Or.inr` — a proof of `P ∨ Q`
  is either "here's a proof of `P`" or "here's a proof of `Q`".
- `¬P` is notation for `P → False`. To prove a negation, assume `P` holds
  and derive `False`.

**Mathematical reading.** These are the constructive readings of the
connectives as operations on the proof-sets. Conjunction $P \wedge Q$ is
the **product** $P \times Q$: a proof is a pair $\langle p, q\rangle$, with
`h.left`/`h.right` the projections $\pi_1, \pi_2$ — so `and_example` builds
$(p,q)$ and `and_left` applies $\pi_1$. Disjunction $P \vee Q$ is the
**coproduct** $P \sqcup Q$: a proof is a tagged injection $\iota_1(p)$
(`Or.inl`) or $\iota_2(q)$ (`Or.inr`), and to *use* one you case-split by
the universal property of the coproduct. Negation is $\neg P := (P \to
\bot)$, a map into the initial object $\bot = \varnothing$; a proof of
$\neg(1=2)$ is a function turning the (impossible) hypothesis $1 = 2$ into
an element of $\varnothing$, vacuously, via `Nat.noConfusion` — the fact
that distinct constructors are disjoint. Note this is *intuitionistic*
logic: there is no built-in law of excluded middle.

---

[← Implication](03-implication.md) | [Index](00-index.md) | [Next: Quantifiers →](05-quantifiers.md)
