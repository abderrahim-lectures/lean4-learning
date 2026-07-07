## Theorem 2: left inverses equal right inverses

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Theorem 3 →](04-theorem-3.md)

---

**Claim.** If `Grp.op b a = Grp.id` for some `a b : G`, then
`b = Grp.inv a`.

**Finding the proof.** Same shape as Theorem 1 — an equality between two
elements known only through separate facts (`h` about `b`, the `Group`
axioms about `Grp.inv a`) — so the same strategy applies: relate both sides
to something in common. But here there's no single lemma that hands you
`Grp.op b Grp.id` the way `Grp.id_right` did in Theorem 1's simpler
setting; you have to *build* the chain by successively rewriting `b` itself.

The trick worth internalizing: **pad `b` with the identity, then swap the
identity for something you can cancel.** Concretely:

$$
b \;=\; b \cdot e \;=\; b \cdot (a \cdot a^{-1}) \;=\; (b \cdot a) \cdot a^{-1} \;=\; e \cdot a^{-1} \;=\; a^{-1}
$$

Each `=` above is licensed by exactly one `Group` field or the hypothesis
`h`, in this order: `id_right` (backwards), `inv_right` (backwards),
`assoc` (backwards), `h`, `id_left`. Writing the *paper* proof first, as a
chain of equalities, then reading off which axiom licenses each step, is
often faster than guessing tactics directly against the goal — do this on
scratch paper before opening the editor.

```lean
theorem left_inverse_unique (a b : G) (h : Grp.op b a = Grp.id) :
    b = Grp.inv a := by
  have e1 : b = Grp.op b Grp.id := (Grp.id_right b).symm
  rw [e1]
  -- Goal: op b id = inv a
  rw [← Grp.inv_right a]
  -- Goal: op b (op a (inv a)) = inv a
  rw [← Grp.assoc b a (Grp.inv a)]
  -- Goal: op (op b a) (inv a) = inv a
  rw [h]
  -- Goal: op id (inv a) = inv a
  exact Grp.id_left (Grp.inv a)
```

At each `rw`, the goal-state comment records what you'd see in the editor —
train yourself to predict that comment *before* running the tactic, then
check. When your prediction is wrong, that's the moment worth stopping and
understanding why (usually: the `rw` fired on a different occurrence of the
pattern than you expected, or in the wrong direction).

**Mathematical reading.** This is *uniqueness of inverses*: if $b\cdot a =
e$ then $b = a^{-1}$. The displayed chain
$$
b = b\cdot e = b\cdot(a\cdot a^{-1}) = (b\cdot a)\cdot a^{-1} = e\cdot a^{-1}
= a^{-1}
$$
is the textbook proof — insert $e = a\cdot a^{-1}$, reassociate, apply the
hypothesis $b\cdot a = e$, cancel the identity. Each `rw` performs exactly
one equality in this chain, using the axioms $\lambda_r$ (id_right), $\iota_r$
(inv_right), $\alpha$ (assoc), the hypothesis $h$, and $\lambda_\ell$
(id_left). Together with Theorem 1 this establishes that inverses in a group
are two-sided and unique, so the notation $a^{-1}$ is unambiguous.

---

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Theorem 3 →](04-theorem-3.md)
