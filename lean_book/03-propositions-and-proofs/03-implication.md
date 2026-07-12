## Implication is a function type

[← `theorem`/`lemma`](02-theorem-lemma.md) | [Index](00-index.md) | [Next: And, Or, Not →](04-and-or-not.md)

---

$P \to Q$ (read "$P$ implies $Q$") is literally a function type: a proof of
$P \to Q$ is a function that turns any proof of $P$ into a proof of $Q$.

```lean
theorem modus_ponens {P Q : Prop} (hpq : P → Q) (hp : P) : Q :=
  hpq hp
```

**Mathematical reading.** Under Curry–Howard, the implication $P \Rightarrow
Q$ *is* the function space $P \to Q$ (the set of proofs of $Q$ parameterized
by proofs of $P$). So modus ponens
$$
\frac{P \Rightarrow Q \qquad P}{Q}
$$
is nothing but function application: given $f \in \mathrm{Hom}(P, Q)$ and
$p \in P$, evaluate to get $f(p) \in Q$. The term `hpq hp` is precisely this
evaluation $f(p)$.

[← `theorem`/`lemma`](02-theorem-lemma.md) | [Index](00-index.md) | [Next: And, Or, Not →](04-and-or-not.md)
