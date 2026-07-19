## Theorem 2: left inverses equal right inverses

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Theorem 3 →](04-theorem-3.md)

---

**Claim.** If `Grp.op b a = Grp.id` for some `a b : G`, then
`b = Grp.inv a`.

**Finding the proof.** This has the same shape as Theorem 1: an equality
between two elements known only through separate facts (`h` about `b`, the
`Group` axioms about `Grp.inv a`). Hence the same strategy applies: relate
both sides to something in common. Here, however, no single lemma hands us
`Grp.op b Grp.id` the way `Grp.id_right` did in Theorem 1's simpler setting.
We must *build* the chain by rewriting `b` itself, step by step.

The trick worth internalizing: **pad `b` with the identity, then swap the
identity for something you can cancel.** Concretely:

$$
b \;=\; b \cdot e \;=\; b \cdot (a \cdot a^{-1}) \;=\; (b \cdot a) \cdot a^{-1} \;=\; e \cdot a^{-1} \;=\; a^{-1}
$$

Each `=` above is licensed by exactly one `Group` field or the hypothesis
`h`, in this order: `id_right` (backwards), `inv_right` (backwards),
`assoc` (backwards), `h`, `id_left`. Writing the *paper* proof first, as a
chain of equalities, and then reading off which axiom licenses each step,
is often faster than guessing tactics directly against the goal. This
chain is best worked out on scratch paper before the editor is opened.

<p><a href="https://live.lean-lang.org/#code=theorem%20left_inverse_unique%20%28a%20b%20%3A%20G%29%20%28h%20%3A%20Grp.op%20b%20a%20%3D%20Grp.id%29%20%3A%0A%20%20%20%20b%20%3D%20Grp.inv%20a%20%3A%3D%20by%0A%20%20have%20e1%20%3A%20b%20%3D%20Grp.op%20b%20Grp.id%20%3A%3D%20%28Grp.id_right%20b%29.symm%0A%20%20rw%20%5Be1%5D%0A%20%20--%20Goal%3A%20op%20b%20id%20%3D%20inv%20a%0A%20%20rw%20%5B%E2%86%90%20Grp.inv_right%20a%5D%0A%20%20--%20Goal%3A%20op%20b%20%28op%20a%20%28inv%20a%29%29%20%3D%20inv%20a%0A%20%20rw%20%5B%E2%86%90%20Grp.assoc%20b%20a%20%28Grp.inv%20a%29%5D%0A%20%20--%20Goal%3A%20op%20%28op%20b%20a%29%20%28inv%20a%29%20%3D%20inv%20a%0A%20%20rw%20%5Bh%5D%0A%20%20--%20Goal%3A%20op%20id%20%28inv%20a%29%20%3D%20inv%20a%0A%20%20exact%20Grp.id_left%20%28Grp.inv%20a%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20left_inverse_unique%20%28a%20b%20%3A%20G%29%20%28h%20%3A%20Grp.op%20b%20a%20%3D%20Grp.id%29%20%3A%0A%20%20%20%20b%20%3D%20Grp.inv%20a%20%3A%3D%20by%0A%20%20have%20e1%20%3A%20b%20%3D%20Grp.op%20b%20Grp.id%20%3A%3D%20%28Grp.id_right%20b%29.symm%0A%20%20rw%20%5Be1%5D%0A%20%20--%20Goal%3A%20op%20b%20id%20%3D%20inv%20a%0A%20%20rw%20%5B%E2%86%90%20Grp.inv_right%20a%5D%0A%20%20--%20Goal%3A%20op%20b%20%28op%20a%20%28inv%20a%29%29%20%3D%20inv%20a%0A%20%20rw%20%5B%E2%86%90%20Grp.assoc%20b%20a%20%28Grp.inv%20a%29%5D%0A%20%20--%20Goal%3A%20op%20%28op%20b%20a%29%20%28inv%20a%29%20%3D%20inv%20a%0A%20%20rw%20%5Bh%5D%0A%20%20--%20Goal%3A%20op%20id%20%28inv%20a%29%20%3D%20inv%20a%0A%20%20exact%20Grp.id_left%20%28Grp.inv%20a%29" title="Lean playground" loading="lazy" style="width:100%;height:288px;border:1px solid #ccc;border-radius:8px;">
</iframe>

At each `rw`, the goal-state comment records what would appear in the
editor. It is worth training oneself to predict that comment *before*
running the tactic, then checking it. When the prediction is wrong, that is
the moment worth stopping to understand why (usually: the `rw` fired on a
different occurrence of the pattern than expected, or in the wrong
direction).

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

<p><a href="https://live.lean-lang.org/#code=example%20%7BG%20%3A%20Type%2A%7D%20%5BGroup%20G%5D%20%28a%20b%20%3A%20G%29%20%28h%20%3A%20b%20%2A%20a%20%3D%201%29%20%3A%20b%20%3D%20a%E2%81%BB%C2%B9%20%3A%3D%20by%0A%20%20rw%20%5B%E2%86%90%20mul_one%20b%2C%20%E2%86%90%20mul_inv_cancel%20a%2C%20%E2%86%90%20mul_assoc%2C%20h%2C%20one_mul%5D" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%7BG%20%3A%20Type%2A%7D%20%5BGroup%20G%5D%20%28a%20b%20%3A%20G%29%20%28h%20%3A%20b%20%2A%20a%20%3D%201%29%20%3A%20b%20%3D%20a%E2%81%BB%C2%B9%20%3A%3D%20by%0A%20%20rw%20%5B%E2%86%90%20mul_one%20b%2C%20%E2%86%90%20mul_inv_cancel%20a%2C%20%E2%86%90%20mul_assoc%2C%20h%2C%20one_mul%5D" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Reading right to left through the `rw` list gives line-for-line the
displayed chain above: `←` [`mul_one`](https://loogle.lean-lang.org/?q=mul_one) `b` turns `b` into `b * 1`; `←` [`mul_inv_cancel`](https://loogle.lean-lang.org/?q=mul_inv_cancel) `a`
turns that `1` into `a * a⁻¹`; `←` [`mul_assoc`](https://loogle.lean-lang.org/?q=mul_assoc) reassociates; `h` substitutes
`b * a` for `1`; [`one_mul`](https://loogle.lean-lang.org/?q=one_mul) clears the resulting `1 * a⁻¹`. These are the same
five steps, in the same order — only the names `Grp.assoc`/`Grp.inv_right`
and so on are replaced by Mathlib's generic `mul_assoc`/`mul_inv_cancel`
and so on.

---

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Theorem 3 →](04-theorem-3.md)
