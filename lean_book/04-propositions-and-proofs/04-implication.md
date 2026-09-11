## Implication is a function type

[← `theorem`/`lemma`](03-theorem-lemma.md) | [Index](00-index.md) | [Next: And, Or, Not →](05-and-or-not.md)

---

$P \to Q$ (read "$P$ implies $Q$") is literally a function type, a proof of
$P \to Q$ is a function that turns any proof of $P$ into a proof of $Q$.
This is the same `→` flagged back in
[Chapter 1, Section 2](../01-basics/02-def-let-implicit.md), the one that
built `double : Nat → Nat`. Nothing about the symbol changes here, only
what stands on either side of it. `Nat → Nat` is functions between two
data types; `P → Q`, for `P Q : Prop`, is functions between two
*proofs*, which is exactly what "implication" turns out to mean.

```lean
theorem modus_ponens {P Q : Prop} (hpq : P → Q) (hp : P) : Q :=
  hpq hp
```

**Mathematical reading.** Under Curry–Howard ([TPIL4], §3.2; [Howard1980], cited in full in
[Section 1](01-prop.md#sources-quoted)), the implication $P \Rightarrow
Q$ *is* the function space $P \to Q$ (the set of proofs of $Q$ parameterized
by proofs of $P$). So modus ponens

$$
\frac{P \Rightarrow Q \qquad P}{Q}
$$

is nothing but function application, given $f \in \mathrm{Hom}(P, Q)$ and
$p \in P$, evaluate to get $f(p) \in Q$. The term `hpq hp` is precisely this
evaluation $f(p)$.

---

### Sources, quoted

- **Curry–Howard for implication.** "Under Curry–Howard, implication $P \Rightarrow Q$ is the function type $P \to Q$" ([TPIL4], §3.2; [Howard1980], pp. 479-490).
- Howard ([Howard1980]) is the original source of the propositions-as-types correspondence for implicational logic.

[TPIL4]: ../bibliography.md#tpil4
[Howard1980]: ../bibliography.md#howard1980

---

[← `theorem`/`lemma`](03-theorem-lemma.md) | [Index](00-index.md) | [Next: And, Or, Not →](05-and-or-not.md)
