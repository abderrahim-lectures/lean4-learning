## `theorem` and `lemma`

[← A recap of standard logic](02-logic-recap.md) | [Index](00-index.md) | [Next: Implication →](04-implication.md)

---

```lean
theorem two_plus_two : 2 + 2 = 4 := rfl

theorem add_comm_example : 2 + 3 = 3 + 2 := rfl
```

Chapter 3's `def` named an ordinary computation. Nothing about `def` lets
that name assert `2 + 2 = 4` is *true* rather than merely *defined*, so
the two blocks above use a different keyword, `theorem`, for exactly that
purpose. `lemma` writes the identical keyword under a different name:
`theorem` and `lemma` are the same thing syntactically, and `lemma` is
just a naming convention for "small helper facts."

**Mathematical reading.** A `theorem name : P := proof` is exactly the act
of naming a proof. It asserts that $P$ is provable, and records a specific
witness $\mathrm{proof} \in P$ under the label $\mathrm{name}$, so that
later arguments can cite it. This is the informal mathematical move "By
Lemma $\mathrm{name}$, $P$ holds," made formal. The distinction between
`theorem` and `lemma` is purely rhetorical (a lemma is a stepping stone).
It has no logical content, just as in ordinary mathematical writing.

---

[← A recap of standard logic](02-logic-recap.md) | [Index](00-index.md) | [Next: Implication →](04-implication.md)
