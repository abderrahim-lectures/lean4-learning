## Implication is a function type

[← `theorem`/`lemma`](03-theorem-lemma.md) | [Index](00-index.md) | [Next: And, Or, Not →](05-and-or-not.md)

---

$P \to Q$ (read "$P$ implies $Q$") is literally a function type: a proof of
$P \to Q$ is a function that turns any proof of $P$ into a proof of $Q$.

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

**Mathematical reading.** Under Curry–Howard, the implication $P \Rightarrow
Q$ *is* the function space $P \to Q$ (the set of proofs of $Q$ parameterized
by proofs of $P$). So modus ponens
$$
\frac{P \Rightarrow Q \qquad P}{Q}
$$
is nothing but function application: given $f \in \mathrm{Hom}(P, Q)$ and
$p \in P$, evaluate to get $f(p) \in Q$. The term `hpq hp` is precisely this
evaluation $f(p)$.

[← `theorem`/`lemma`](03-theorem-lemma.md) | [Index](00-index.md) | [Next: And, Or, Not →](05-and-or-not.md)
