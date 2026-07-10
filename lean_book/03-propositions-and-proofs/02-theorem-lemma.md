## `theorem` and `lemma`

[← `Prop`](01-prop.md) | [Index](00-index.md) | [Next: Implication →](03-implication.md)

---

```lean
theorem two_plus_two : 2 + 2 = 4 := rfl

theorem add_comm_example : 2 + 3 = 3 + 2 := rfl
```

`theorem` and `lemma` are the same thing syntactically; `lemma` is just a
naming convention for "small helper facts."

**Mathematical reading.** A `theorem name : P := proof` is exactly the act
of naming a proof: it asserts that $P$ is provable, and records a specific
witness $\mathrm{proof} \in P$ under the label $\mathrm{name}$, so that
later arguments may cite it. This is the informal mathematical move "By
Lemma $\mathrm{name}$, $P$ holds," made formal — the distinction between
`theorem` and `lemma` is purely rhetorical (a lemma is a stepping stone),
with no logical content, just as in ordinary mathematical writing.

---

[← `Prop`](01-prop.md) | [Index](00-index.md) | [Next: Implication →](03-implication.md)
