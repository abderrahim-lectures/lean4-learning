## `theorem` and `lemma`

[← A recap of standard logic](02-logic-recap.md) | [Index](00-index.md) | [Next: Implication →](04-implication.md)

---

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`theorem` and `lemma` are the same thing syntactically. `lemma` is just a
naming convention for "small helper facts."

**Mathematical reading.** A `theorem name : P := proof` is exactly the act
of naming a proof. It asserts that $P$ is provable, and records a specific
witness $\mathrm{proof} \in P$ under the label $\mathrm{name}$, so that
later arguments can cite it. This is the informal mathematical move "By
Lemma $\mathrm{name}$, $P$ holds," made formal. The distinction between
`theorem` and `lemma` is purely rhetorical (a lemma is a stepping stone).
It has no logical content, just as in ordinary mathematical writing.

---

[← A recap of standard logic](02-logic-recap.md) | [Index](00-index.md) | [Next: Implication →](04-implication.md)
