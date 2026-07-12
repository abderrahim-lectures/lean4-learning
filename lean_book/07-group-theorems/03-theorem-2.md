## Theorem 2: left inverses equal right inverses

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Theorem 3 →](04-theorem-3.md)

---

**Claim.** If `Grp.op b a = Grp.id` for some `a b : G`, then
`b = Grp.inv a`.

**Finding the proof.** This has the same shape as Theorem 1: an equality
between two elements known only through separate facts (`h` about `b`, the
`Group` axioms about `Grp.inv a`). So the same strategy applies: relate
both sides to something in common. But here there's no single lemma that
hands you `Grp.op b Grp.id` the way `Grp.id_right` did in Theorem 1's
simpler setting. You have to *build* the chain by rewriting `b` itself,
step by step.

The trick worth internalizing: **pad `b` with the identity, then swap the
identity for something you can cancel.** Concretely:

$$
b \;=\; b \cdot e \;=\; b \cdot (a \cdot a^{-1}) \;=\; (b \cdot a) \cdot a^{-1} \;=\; e \cdot a^{-1} \;=\; a^{-1}
$$

Each `=` above is licensed by exactly one `Group` field or the hypothesis
`h`, in this order: `id_right` (backwards), `inv_right` (backwards),
`assoc` (backwards), `h`, `id_left`. Writing the *paper* proof first, as a
chain of equalities, and then reading off which axiom licenses each step,
is often faster than guessing tactics directly against the goal. Do this
on scratch paper before opening the editor.

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

At each `rw`, the goal-state comment records what you'd see in the editor.
Train yourself to predict that comment *before* running the tactic, then
check it. When your prediction is wrong, that's the moment worth stopping
to understand why (usually: the `rw` fired on a different occurrence of the
pattern than you expected, or in the wrong direction).

**Mathematical reading.** This is *uniqueness of inverses*: if $b\cdot a =
e$ then $b = a^{-1}$. The displayed chain
$$
b = b\cdot e = b\cdot(a\cdot a^{-1}) = (b\cdot a)\cdot a^{-1} = e\cdot a^{-1}
= a^{-1}
$$
is the textbook proof: insert $e = a\cdot a^{-1}$, reassociate, apply the
hypothesis $b\cdot a = e$, then cancel the identity. Each `rw` performs
exactly one equality in this chain, using the axioms $\lambda_r$ (id_right),
$\iota_r$ (inv_right), $\alpha$ (assoc), the hypothesis $h$, and $\lambda_\ell$
(id_left). Together with Theorem 1 this establishes that inverses in a group
are two-sided and unique, so the notation $a^{-1}$ is unambiguous.

**Mathlib equivalent.** The exact same "pad with the identity, swap it for
something cancelable" chain, written with `*`/`1`/`⁻¹` instead of
`Grp.op`/`Grp.id`/`Grp.inv`:

```lean
example {G : Type*} [Group G] (a b : G) (h : b * a = 1) : b = a⁻¹ := by
  rw [← mul_one b, ← mul_inv_cancel a, ← mul_assoc, h, one_mul]
```

Read right to left through the `rw` list, and this is line-for-line the
displayed chain above: `←` [`mul_one`](https://loogle.lean-lang.org/?q=mul_one) `b` turns `b` into `b * 1`; `←` [`mul_inv_cancel`](https://loogle.lean-lang.org/?q=mul_inv_cancel) `a`
turns that `1` into `a * a⁻¹`; `←` [`mul_assoc`](https://loogle.lean-lang.org/?q=mul_assoc) reassociates; `h` substitutes
`b * a` for `1`; [`one_mul`](https://loogle.lean-lang.org/?q=one_mul) clears the resulting `1 * a⁻¹`. It is the same
five steps, in the same order — only the names `Grp.assoc`/`Grp.inv_right`
and so on are replaced by Mathlib's generic `mul_assoc`/`mul_inv_cancel`
and so on.

---

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Theorem 3 →](04-theorem-3.md)
