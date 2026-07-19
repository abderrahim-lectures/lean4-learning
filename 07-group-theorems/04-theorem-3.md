## Theorem 3: inverse of a product

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md) | [Next: Exercises →](05-exercises.md)

---

**Claim.** `Grp.inv (Grp.op a b) = Grp.op (Grp.inv b) (Grp.inv a)`.

**Finding the proof.** This *appears* to again call for a chain of
equalities, but a shortcut emerges once the goal's shape is recognized to
match a theorem already in hand. The claim states that some element
(`Grp.inv (Grp.op a b)`) equals some other expression built from `a`, `b`.
Theorem 2 already establishes: *to show `x = Grp.inv y`, it suffices to
show `x` is a left inverse of `y`*. In other words, an inverse-computation
goal reduces to a single equation `Grp.op x y = Grp.id`, which is usually
easier to attack directly with `assoc`/`inv_left`/`inv_right` than
`inv (...)` taken at face value. This is a general and reusable move:
**once a uniqueness/characterization lemma is proved, it can turn "compute
this thing" goals into "verify this thing satisfies the characterizing
property" goals** — almost always a simpler target.

Applying that here (with the goal read backwards, `apply Eq.symm` first, so
`left_inverse_unique` unifies against the "b" slot), the remaining goal is
`Grp.op (Grp.op (Grp.inv b) (Grp.inv a)) (Grp.op a b) = Grp.id`. This is
pure cancellation: regroup with `assoc` until `Grp.inv a` sits next to `a`,
cancel via `inv_left`, then regroup until `Grp.inv b` sits next to `b`, and
cancel again.

<p><a href="https://live.lean-lang.org/#code=theorem%20inv_op%20%28a%20b%20%3A%20G%29%20%3A%0A%20%20%20%20Grp.inv%20%28Grp.op%20a%20b%29%20%3D%20Grp.op%20%28Grp.inv%20b%29%20%28Grp.inv%20a%29%20%3A%3D%20by%0A%20%20apply%20Eq.symm%0A%20%20apply%20left_inverse_unique%0A%20%20--%20Goal%3A%20op%20%28op%20%28inv%20b%29%20%28inv%20a%29%29%20%28op%20a%20b%29%20%3D%20id%0A%20%20rw%20%5BGrp.assoc%5D%0A%20%20--%20Goal%3A%20op%20%28inv%20b%29%20%28op%20%28inv%20a%29%20%28op%20a%20b%29%29%20%3D%20id%0A%20%20rw%20%5B%E2%86%90%20Grp.assoc%20%28Grp.inv%20a%29%20a%20b%5D%0A%20%20--%20Goal%3A%20op%20%28inv%20b%29%20%28op%20%28op%20%28inv%20a%29%20a%29%20b%29%20%3D%20id%0A%20%20rw%20%5BGrp.inv_left%5D%0A%20%20--%20Goal%3A%20op%20%28inv%20b%29%20%28op%20id%20b%29%20%3D%20id%0A%20%20rw%20%5BGrp.id_left%5D%0A%20%20--%20Goal%3A%20op%20%28inv%20b%29%20b%20%3D%20id%0A%20%20exact%20Grp.inv_left%20b" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20inv_op%20%28a%20b%20%3A%20G%29%20%3A%0A%20%20%20%20Grp.inv%20%28Grp.op%20a%20b%29%20%3D%20Grp.op%20%28Grp.inv%20b%29%20%28Grp.inv%20a%29%20%3A%3D%20by%0A%20%20apply%20Eq.symm%0A%20%20apply%20left_inverse_unique%0A%20%20--%20Goal%3A%20op%20%28op%20%28inv%20b%29%20%28inv%20a%29%29%20%28op%20a%20b%29%20%3D%20id%0A%20%20rw%20%5BGrp.assoc%5D%0A%20%20--%20Goal%3A%20op%20%28inv%20b%29%20%28op%20%28inv%20a%29%20%28op%20a%20b%29%29%20%3D%20id%0A%20%20rw%20%5B%E2%86%90%20Grp.assoc%20%28Grp.inv%20a%29%20a%20b%5D%0A%20%20--%20Goal%3A%20op%20%28inv%20b%29%20%28op%20%28op%20%28inv%20a%29%20a%29%20b%29%20%3D%20id%0A%20%20rw%20%5BGrp.inv_left%5D%0A%20%20--%20Goal%3A%20op%20%28inv%20b%29%20%28op%20id%20b%29%20%3D%20id%0A%20%20rw%20%5BGrp.id_left%5D%0A%20%20--%20Goal%3A%20op%20%28inv%20b%29%20b%20%3D%20id%0A%20%20exact%20Grp.inv_left%20b" title="Lean playground" loading="lazy" style="width:100%;height:326px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Notice how much of this `rw` chain is **regrouping via `assoc` to bring a
cancelable pair next to each other**, then cancelling. That two-step
pattern, *regroup, then cancel*, comes up constantly in algebra and is
worth recognizing on sight rather than re-deriving from scratch each time.

**Mathematical reading.** This is the *shoes-and-socks* law $(a\cdot
b)^{-1} = b^{-1}\cdot a^{-1}$: the inverse operation reverses the order of
composition. By the uniqueness of inverses
(Theorem 2) it suffices to check that $b^{-1}a^{-1}$ is a genuine inverse of
$ab$, i.e.
$$
(b^{-1}a^{-1})(ab) = b^{-1}(a^{-1}a)b = b^{-1}eb = b^{-1}b = e,
$$
which is precisely the "regroup, then cancel" computation the `rw` chain
performs. Reusing Theorem 2 as a characterization ("to identify an inverse,
verify the defining equation") is the categorical habit of proving equalities
via a [universal property](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
rather than by direct computation.

### The payoff, made concrete: applying `inv_op` to a real group

Chapter 6 promised that a theorem proved once, generically, is available
"for free" on every group built afterward. Here is that promise delivered:
`inv_op`, proved above for an *arbitrary* `Grp : Group G`, applies
immediately to `perm3Group` (Chapter 6's non-abelian permutation group),
with no new proof required:

<p><a href="https://live.lean-lang.org/#code=example%20%3A%20perm3Group.inv%20%28perm3Group.op%20swap01%20cycle012%29%20%3D%0A%20%20%20%20perm3Group.op%20%28perm3Group.inv%20cycle012%29%20%28perm3Group.inv%20swap01%29%20%3A%3D%0A%20%20inv_op%20perm3Group%20swap01%20cycle012" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%3A%20perm3Group.inv%20%28perm3Group.op%20swap01%20cycle012%29%20%3D%0A%20%20%20%20perm3Group.op%20%28perm3Group.inv%20cycle012%29%20%28perm3Group.inv%20swap01%29%20%3A%3D%0A%20%20inv_op%20perm3Group%20swap01%20cycle012" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This is the entire proof: a single application of the already-proved
`inv_op`, instantiated at `Grp := perm3Group`, `a := swap01`,
`b := cycle012`. It can also be checked computationally, pointwise, on
every element of `Fin 3`:

<p><a href="https://live.lean-lang.org/#code=%23eval%20%28perm3Group.inv%20%28perm3Group.op%20swap01%20cycle012%29%29.toFun%200%20%20--%200%0A%23eval%20%28perm3Group.op%20%28perm3Group.inv%20cycle012%29%20%28perm3Group.inv%20swap01%29%29.toFun%200%20%20--%200%0A%23eval%20%28perm3Group.inv%20%28perm3Group.op%20swap01%20cycle012%29%29.toFun%201%20%20--%202%0A%23eval%20%28perm3Group.op%20%28perm3Group.inv%20cycle012%29%20%28perm3Group.inv%20swap01%29%29.toFun%201%20%20--%202%0A%23eval%20%28perm3Group.inv%20%28perm3Group.op%20swap01%20cycle012%29%29.toFun%202%20%20--%201%0A%23eval%20%28perm3Group.op%20%28perm3Group.inv%20cycle012%29%20%28perm3Group.inv%20swap01%29%29.toFun%202%20%20--%201" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=%23eval%20%28perm3Group.inv%20%28perm3Group.op%20swap01%20cycle012%29%29.toFun%200%20%20--%200%0A%23eval%20%28perm3Group.op%20%28perm3Group.inv%20cycle012%29%20%28perm3Group.inv%20swap01%29%29.toFun%200%20%20--%200%0A%23eval%20%28perm3Group.inv%20%28perm3Group.op%20swap01%20cycle012%29%29.toFun%201%20%20--%202%0A%23eval%20%28perm3Group.op%20%28perm3Group.inv%20cycle012%29%20%28perm3Group.inv%20swap01%29%29.toFun%201%20%20--%202%0A%23eval%20%28perm3Group.inv%20%28perm3Group.op%20swap01%20cycle012%29%29.toFun%202%20%20--%201%0A%23eval%20%28perm3Group.op%20%28perm3Group.inv%20cycle012%29%20%28perm3Group.inv%20swap01%29%29.toFun%202%20%20--%201" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Both sides agree on every input, exactly what `inv_op`'s proof
guarantees, now witnessed by direct computation rather than taken on
faith. This is the concrete content of "prove it once, obtain it for free
everywhere": nothing about `swap01`, `cycle012`, or the fact that
`perm3Group` is non-abelian required revisiting `inv_op`'s proof at all.

**Mathlib equivalent.** The "shoes-and-socks" law is not a theorem left to
(re)prove here — Mathlib already has it, under its own name, [`mul_inv_rev`](https://loogle.lean-lang.org/?q=mul_inv_rev):

<p><a href="https://live.lean-lang.org/#code=example%20%7BG%20%3A%20Type%2A%7D%20%5BGroup%20G%5D%20%28a%20b%20%3A%20G%29%20%3A%20%28a%20%2A%20b%29%E2%81%BB%C2%B9%20%3D%20b%E2%81%BB%C2%B9%20%2A%20a%E2%81%BB%C2%B9%20%3A%3D%20mul_inv_rev%20a%20b" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%7BG%20%3A%20Type%2A%7D%20%5BGroup%20G%5D%20%28a%20b%20%3A%20G%29%20%3A%20%28a%20%2A%20b%29%E2%81%BB%C2%B9%20%3D%20b%E2%81%BB%C2%B9%20%2A%20a%E2%81%BB%C2%B9%20%3A%3D%20mul_inv_rev%20a%20b" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

And the same payoff Chapter 7 draws out concretely for `perm3Group` applies
here too, against Mathlib's own $S_3$ from Chapter 6 §4. There is no new
proof, only an application of `mul_inv_rev` at `Equiv.Perm (Fin 3)`:

<p><a href="https://live.lean-lang.org/#code=example%20%3A%20%28swap01%27%20%2A%20cycle012%27%29%E2%81%BB%C2%B9%20%3D%20cycle012%27%E2%81%BB%C2%B9%20%2A%20swap01%27%E2%81%BB%C2%B9%20%3A%3D%0A%20%20mul_inv_rev%20swap01%27%20cycle012%27%0A%0A%23eval%20%28swap01%27%20%2A%20cycle012%27%29%E2%81%BB%C2%B9%200%20%20%20%20--%200%0A%23eval%20%28cycle012%27%E2%81%BB%C2%B9%20%2A%20swap01%27%E2%81%BB%C2%B9%29%200%20%20%20--%200%0A%23eval%20%28swap01%27%20%2A%20cycle012%27%29%E2%81%BB%C2%B9%201%20%20%20%20--%202%0A%23eval%20%28cycle012%27%E2%81%BB%C2%B9%20%2A%20swap01%27%E2%81%BB%C2%B9%29%201%20%20%20--%202%0A%23eval%20%28swap01%27%20%2A%20cycle012%27%29%E2%81%BB%C2%B9%202%20%20%20%20--%201%0A%23eval%20%28cycle012%27%E2%81%BB%C2%B9%20%2A%20swap01%27%E2%81%BB%C2%B9%29%202%20%20%20--%201" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%3A%20%28swap01%27%20%2A%20cycle012%27%29%E2%81%BB%C2%B9%20%3D%20cycle012%27%E2%81%BB%C2%B9%20%2A%20swap01%27%E2%81%BB%C2%B9%20%3A%3D%0A%20%20mul_inv_rev%20swap01%27%20cycle012%27%0A%0A%23eval%20%28swap01%27%20%2A%20cycle012%27%29%E2%81%BB%C2%B9%200%20%20%20%20--%200%0A%23eval%20%28cycle012%27%E2%81%BB%C2%B9%20%2A%20swap01%27%E2%81%BB%C2%B9%29%200%20%20%20--%200%0A%23eval%20%28swap01%27%20%2A%20cycle012%27%29%E2%81%BB%C2%B9%201%20%20%20%20--%202%0A%23eval%20%28cycle012%27%E2%81%BB%C2%B9%20%2A%20swap01%27%E2%81%BB%C2%B9%29%201%20%20%20--%202%0A%23eval%20%28swap01%27%20%2A%20cycle012%27%29%E2%81%BB%C2%B9%202%20%20%20%20--%201%0A%23eval%20%28cycle012%27%E2%81%BB%C2%B9%20%2A%20swap01%27%E2%81%BB%C2%B9%29%202%20%20%20--%201" title="Lean playground" loading="lazy" style="width:100%;height:231px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Both sides agree on every input: the same six values, in the same order,
as the book's own `perm3Group` check above. Where the book's `inv_op`
required a five-line `rw` chain (regroup via `assoc`, cancel via
`inv_left`, regroup again, cancel again), Mathlib's version requires no
proof to write at all. `mul_inv_rev` is already proved, once, generically
over every `Group`.

---

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md) | [Next: Exercises →](05-exercises.md)
