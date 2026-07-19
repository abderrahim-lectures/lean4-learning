## A non-abelian example: permutations of three elements

[← Integers example](03-integers-example.md) | [Index](00-index.md) | [Next: Accessing the fields →](05-accessing-fields.md)

---

`intGroup` is abelian ($a + b = b + a$), so it never tests the
distinction between `id_left`/`id_right` or `inv_left`/`inv_right`. In a
commutative group these coincide, which might suggest that
the left/right split in `Group`'s definition is merely overly
careful. It is not: the following is a small, fully concrete, genuinely
**non-abelian** group, built the same way `intGroup` was, field by field.

### The carrier: bijections of a 3-element set

The symmetric group $S_3$ consists of all bijections (permutations) of a
3-element set, under composition. We represent a permutation of
`Fin 3 := {0, 1, 2}` as a bijective function bundled with its own inverse
and the proofs that they cancel:

<p><a href="https://live.lean-lang.org/#code=structure%20Perm3%20where%0A%20%20toFun%20%3A%20Fin%203%20%E2%86%92%20Fin%203%0A%20%20invFun%20%3A%20Fin%203%20%E2%86%92%20Fin%203%0A%20%20left_inv%20%3A%20%E2%88%80%20x%2C%20invFun%20%28toFun%20x%29%20%3D%20x%0A%20%20right_inv%20%3A%20%E2%88%80%20x%2C%20toFun%20%28invFun%20x%29%20%3D%20x" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Perm3%20where%0A%20%20toFun%20%3A%20Fin%203%20%E2%86%92%20Fin%203%0A%20%20invFun%20%3A%20Fin%203%20%E2%86%92%20Fin%203%0A%20%20left_inv%20%3A%20%E2%88%80%20x%2C%20invFun%20%28toFun%20x%29%20%3D%20x%0A%20%20right_inv%20%3A%20%E2%88%80%20x%2C%20toFun%20%28invFun%20x%29%20%3D%20x" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This is the same "bundle data with the proofs that make it well-behaved"
pattern as `Group` itself. `Perm3` carries not only a function but also
the *proof* that the function is invertible, since an arbitrary
`Fin 3 → Fin 3` need not be a bijection at all.

### The group operation: composition

<p><a href="https://live.lean-lang.org/#code=def%20Perm3.comp%20%28f%20g%20%3A%20Perm3%29%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20f.toFun%20%E2%88%98%20g.toFun%0A%20%20invFun%20%3A%3D%20g.invFun%20%E2%88%98%20f.invFun%0A%20%20left_inv%20%3A%3D%20by%0A%20%20%20%20intro%20x%0A%20%20%20%20show%20g.invFun%20%28f.invFun%20%28f.toFun%20%28g.toFun%20x%29%29%29%20%3D%20x%0A%20%20%20%20rw%20%5Bf.left_inv%5D%0A%20%20%20%20exact%20g.left_inv%20x%0A%20%20right_inv%20%3A%3D%20by%0A%20%20%20%20intro%20x%0A%20%20%20%20show%20f.toFun%20%28g.toFun%20%28g.invFun%20%28f.invFun%20x%29%29%29%20%3D%20x%0A%20%20%20%20rw%20%5Bg.right_inv%5D%0A%20%20%20%20exact%20f.right_inv%20x" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20Perm3.comp%20%28f%20g%20%3A%20Perm3%29%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20f.toFun%20%E2%88%98%20g.toFun%0A%20%20invFun%20%3A%3D%20g.invFun%20%E2%88%98%20f.invFun%0A%20%20left_inv%20%3A%3D%20by%0A%20%20%20%20intro%20x%0A%20%20%20%20show%20g.invFun%20%28f.invFun%20%28f.toFun%20%28g.toFun%20x%29%29%29%20%3D%20x%0A%20%20%20%20rw%20%5Bf.left_inv%5D%0A%20%20%20%20exact%20g.left_inv%20x%0A%20%20right_inv%20%3A%3D%20by%0A%20%20%20%20intro%20x%0A%20%20%20%20show%20f.toFun%20%28g.toFun%20%28g.invFun%20%28f.invFun%20x%29%29%29%20%3D%20x%0A%20%20%20%20rw%20%5Bg.right_inv%5D%0A%20%20%20%20exact%20f.right_inv%20x" title="Lean playground" loading="lazy" style="width:100%;height:307px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`Perm3.comp f g` composes `f` *after* `g` (apply `g.toFun` first, then
`f.toFun`). This is the standard function-composition convention. Its
inverse composes the two inverses in the *opposite* order
(`g.invFun ∘ f.invFun`), which is exactly $(fg)^{-1} = g^{-1}f^{-1}$, the
same "reverse the order" fact Chapter 7's Theorem 3
(`inv_op`) proves abstractly for every group. This construction shows concretely
why the fact holds: to undo "first $g$, then $f$," one must first undo $f$,
then undo $g$.

<p><a href="https://live.lean-lang.org/#code=def%20Perm3.identity%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20fun%20x%20%3D%3E%20x%0A%20%20invFun%20%3A%3D%20fun%20x%20%3D%3E%20x%0A%20%20left_inv%20%3A%3D%20fun%20_%20%3D%3E%20rfl%0A%20%20right_inv%20%3A%3D%20fun%20_%20%3D%3E%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20Perm3.identity%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20fun%20x%20%3D%3E%20x%0A%20%20invFun%20%3A%3D%20fun%20x%20%3D%3E%20x%0A%20%20left_inv%20%3A%3D%20fun%20_%20%3D%3E%20rfl%0A%20%20right_inv%20%3A%3D%20fun%20_%20%3D%3E%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`Perm3.identity` is the identity permutation: it fixes every point, hence
both of its proof fields are immediate by `rfl`.

<p><a href="https://live.lean-lang.org/#code=def%20Perm3.inv%20%28f%20%3A%20Perm3%29%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20f.invFun%0A%20%20invFun%20%3A%3D%20f.toFun%0A%20%20left_inv%20%3A%3D%20f.right_inv%0A%20%20right_inv%20%3A%3D%20f.left_inv" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20Perm3.inv%20%28f%20%3A%20Perm3%29%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20f.invFun%0A%20%20invFun%20%3A%3D%20f.toFun%0A%20%20left_inv%20%3A%3D%20f.right_inv%0A%20%20right_inv%20%3A%3D%20f.left_inv" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`Perm3.inv` inverts a permutation by swapping its `toFun` and `invFun`,
and it correspondingly swaps which proof field (`left_inv` or
`right_inv`) plays which role, since inverting a bijection simply swaps
which direction counts as "forward."

### Two concrete permutations, and a computed proof they do not commute

<p><a href="https://live.lean-lang.org/#code=--%20Swap%200%20and%201%2C%20leave%202%20fixed.%0Adef%20swap01%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20fun%20x%20%3D%3E%20match%20x%20with%0A%20%20%20%20%7C%200%20%3D%3E%201%20%7C%201%20%3D%3E%200%20%7C%202%20%3D%3E%202%0A%20%20invFun%20%3A%3D%20fun%20x%20%3D%3E%20match%20x%20with%0A%20%20%20%20%7C%200%20%3D%3E%201%20%7C%201%20%3D%3E%200%20%7C%202%20%3D%3E%202%0A%20%20left_inv%20%3A%3D%20by%20intro%20x%3B%20match%20x%20with%20%7C%200%20%3D%3E%20rfl%20%7C%201%20%3D%3E%20rfl%20%7C%202%20%3D%3E%20rfl%0A%20%20right_inv%20%3A%3D%20by%20intro%20x%3B%20match%20x%20with%20%7C%200%20%3D%3E%20rfl%20%7C%201%20%3D%3E%20rfl%20%7C%202%20%3D%3E%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20Swap%200%20and%201%2C%20leave%202%20fixed.%0Adef%20swap01%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20fun%20x%20%3D%3E%20match%20x%20with%0A%20%20%20%20%7C%200%20%3D%3E%201%20%7C%201%20%3D%3E%200%20%7C%202%20%3D%3E%202%0A%20%20invFun%20%3A%3D%20fun%20x%20%3D%3E%20match%20x%20with%0A%20%20%20%20%7C%200%20%3D%3E%201%20%7C%201%20%3D%3E%200%20%7C%202%20%3D%3E%202%0A%20%20left_inv%20%3A%3D%20by%20intro%20x%3B%20match%20x%20with%20%7C%200%20%3D%3E%20rfl%20%7C%201%20%3D%3E%20rfl%20%7C%202%20%3D%3E%20rfl%0A%20%20right_inv%20%3A%3D%20by%20intro%20x%3B%20match%20x%20with%20%7C%200%20%3D%3E%20rfl%20%7C%201%20%3D%3E%20rfl%20%7C%202%20%3D%3E%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:212px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`swap01` is the permutation that swaps `0` and `1` while leaving `2`
fixed.

<p><a href="https://live.lean-lang.org/#code=--%20The%203-cycle%200%20%E2%86%92%201%20%E2%86%92%202%20%E2%86%92%200.%0Adef%20cycle012%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20fun%20x%20%3D%3E%20match%20x%20with%0A%20%20%20%20%7C%200%20%3D%3E%201%20%7C%201%20%3D%3E%202%20%7C%202%20%3D%3E%200%0A%20%20invFun%20%3A%3D%20fun%20x%20%3D%3E%20match%20x%20with%0A%20%20%20%20%7C%200%20%3D%3E%202%20%7C%201%20%3D%3E%200%20%7C%202%20%3D%3E%201%0A%20%20left_inv%20%3A%3D%20by%20intro%20x%3B%20match%20x%20with%20%7C%200%20%3D%3E%20rfl%20%7C%201%20%3D%3E%20rfl%20%7C%202%20%3D%3E%20rfl%0A%20%20right_inv%20%3A%3D%20by%20intro%20x%3B%20match%20x%20with%20%7C%200%20%3D%3E%20rfl%20%7C%201%20%3D%3E%20rfl%20%7C%202%20%3D%3E%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20The%203-cycle%200%20%E2%86%92%201%20%E2%86%92%202%20%E2%86%92%200.%0Adef%20cycle012%20%3A%20Perm3%20where%0A%20%20toFun%20%3A%3D%20fun%20x%20%3D%3E%20match%20x%20with%0A%20%20%20%20%7C%200%20%3D%3E%201%20%7C%201%20%3D%3E%202%20%7C%202%20%3D%3E%200%0A%20%20invFun%20%3A%3D%20fun%20x%20%3D%3E%20match%20x%20with%0A%20%20%20%20%7C%200%20%3D%3E%202%20%7C%201%20%3D%3E%200%20%7C%202%20%3D%3E%201%0A%20%20left_inv%20%3A%3D%20by%20intro%20x%3B%20match%20x%20with%20%7C%200%20%3D%3E%20rfl%20%7C%201%20%3D%3E%20rfl%20%7C%202%20%3D%3E%20rfl%0A%20%20right_inv%20%3A%3D%20by%20intro%20x%3B%20match%20x%20with%20%7C%200%20%3D%3E%20rfl%20%7C%201%20%3D%3E%20rfl%20%7C%202%20%3D%3E%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:212px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`cycle012` is the 3-cycle sending $0 \to 1 \to 2 \to 0$.

<p><a href="https://live.lean-lang.org/#code=%23eval%20%28Perm3.comp%20swap01%20cycle012%29.toFun%200%20%20%20--%200%0A%23eval%20%28Perm3.comp%20cycle012%20swap01%29.toFun%200%20%20%20--%202" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=%23eval%20%28Perm3.comp%20swap01%20cycle012%29.toFun%200%20%20%20--%200%0A%23eval%20%28Perm3.comp%20cycle012%20swap01%29.toFun%200%20%20%20--%202" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Both compositions send `0` somewhere, but to *different* places: applying
`cycle012` then `swap01` sends $0 \to 1 \to 0$, while applying `swap01`
then `cycle012` sends $0 \to 0 \to 1$. Concretely, `#eval` reports `0` for
the first and `2` for the second. This is **directly computed evidence**
that `Perm3.comp swap01 cycle012 ≠ Perm3.comp cycle012 swap01`; in other
words, this group is genuinely non-abelian. This is exactly the kind
of "compute a counterexample" move Chapter 8 uses again for matrices. It
is cheaper than any hand-written non-commutativity proof, and it yields,
for free, the specific pair of elements that fail to commute.

### Assembling `Group Perm3`

<p><a href="https://live.lean-lang.org/#code=theorem%20Perm3.ext%20%7Bf%20g%20%3A%20Perm3%7D%20%28h%20%3A%20%E2%88%80%20x%2C%20f.toFun%20x%20%3D%20g.toFun%20x%29%0A%20%20%20%20%28h%27%20%3A%20%E2%88%80%20x%2C%20f.invFun%20x%20%3D%20g.invFun%20x%29%20%3A%20f%20%3D%20g%20%3A%3D%20by%0A%20%20cases%20f%0A%20%20cases%20g%0A%20%20simp%20only%20%5Bmk.injEq%5D%0A%20%20constructor%0A%20%20%C2%B7%20funext%20x%3B%20exact%20h%20x%0A%20%20%C2%B7%20funext%20x%3B%20exact%20h%27%20x%0A%0Adef%20perm3Group%20%3A%20Group%20Perm3%20where%0A%20%20op%20%3A%3D%20Perm3.comp%0A%20%20id%20%3A%3D%20Perm3.identity%0A%20%20inv%20%3A%3D%20Perm3.inv%0A%20%20assoc%20%3A%3D%20by%0A%20%20%20%20intro%20f%20g%20h%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20id_left%20%3A%3D%20by%0A%20%20%20%20intro%20f%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20id_right%20%3A%3D%20by%0A%20%20%20%20intro%20f%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20intro%20f%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20exact%20f.left_inv%20x%0A%20%20%20%20%C2%B7%20intro%20x%3B%20exact%20f.left_inv%20x%0A%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20intro%20f%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20exact%20f.right_inv%20x%0A%20%20%20%20%C2%B7%20intro%20x%3B%20exact%20f.right_inv%20x" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20Perm3.ext%20%7Bf%20g%20%3A%20Perm3%7D%20%28h%20%3A%20%E2%88%80%20x%2C%20f.toFun%20x%20%3D%20g.toFun%20x%29%0A%20%20%20%20%28h%27%20%3A%20%E2%88%80%20x%2C%20f.invFun%20x%20%3D%20g.invFun%20x%29%20%3A%20f%20%3D%20g%20%3A%3D%20by%0A%20%20cases%20f%0A%20%20cases%20g%0A%20%20simp%20only%20%5Bmk.injEq%5D%0A%20%20constructor%0A%20%20%C2%B7%20funext%20x%3B%20exact%20h%20x%0A%20%20%C2%B7%20funext%20x%3B%20exact%20h%27%20x%0A%0Adef%20perm3Group%20%3A%20Group%20Perm3%20where%0A%20%20op%20%3A%3D%20Perm3.comp%0A%20%20id%20%3A%3D%20Perm3.identity%0A%20%20inv%20%3A%3D%20Perm3.inv%0A%20%20assoc%20%3A%3D%20by%0A%20%20%20%20intro%20f%20g%20h%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20id_left%20%3A%3D%20by%0A%20%20%20%20intro%20f%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20id_right%20%3A%3D%20by%0A%20%20%20%20intro%20f%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20%20%20%C2%B7%20intro%20x%3B%20rfl%0A%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20intro%20f%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20exact%20f.left_inv%20x%0A%20%20%20%20%C2%B7%20intro%20x%3B%20exact%20f.left_inv%20x%0A%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20intro%20f%0A%20%20%20%20apply%20Perm3.ext%0A%20%20%20%20%C2%B7%20intro%20x%3B%20exact%20f.right_inv%20x%0A%20%20%20%20%C2%B7%20intro%20x%3B%20exact%20f.right_inv%20x" title="Lean playground" loading="lazy" style="width:100%;height:650px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`Perm3.ext` is a small helper (an *extensionality* lemma, in the same
spirit as Chapter 8's `Mat2.mk.injEq`-based reasoning): two `Perm3`s are
equal exactly when their `toFun`s agree everywhere *and* their `invFun`s
agree everywhere, since those are `Perm3`'s only two fields (the proof
fields do not matter, by proof irrelevance, Chapter 5). Each `Group` field
is then proved by reducing to this extensionality check and confirming
both functions involved agree pointwise. Most cases are `rfl` directly
(both sides compute to the same function once unfolded), and `inv_left`/
`inv_right` cite exactly `f.left_inv`/`f.right_inv`, the proof obligations
already bundled into `Perm3` itself.

**Mathematical reading.** `Perm3` (with composition) is $S_3$, the
symmetric group on three letters. It is the smallest non-abelian group
(order $6$) and the standard first example in any course covering
non-commutative groups. `swap01` and `cycle012` here are, respectively, a
transposition and a 3-cycle. Together they generate all of $S_3$, exactly
as in the usual presentation $S_3 = \langle r, s \mid r^3 = s^2 = e,\ srs
= r^{-1} \rangle$, with $r = $ `cycle012` and $s = $ `swap01`.

**Mathlib equivalent.** All of `Perm3`/`Perm3.comp`/`Perm3.ext`/
`perm3Group` above exists to build one thing: "the group of bijections of a
3-element set." Mathlib's ready-made model of exactly that is [`Equiv.Perm`](https://loogle.lean-lang.org/?q=Equiv.Perm),
already a [`Group`](https://loogle.lean-lang.org/?q=Group) instance for *any* type:

<p><a href="https://live.lean-lang.org/#code=example%20%3A%20Group%20%28Equiv.Perm%20%28Fin%203%29%29%20%3A%3D%20inferInstance%0A%0A--%20Swap%200%20and%201%2C%20leave%202%20fixed%20%E2%80%94%20the%20Mathlib%20analogue%20of%20%60swap01%60.%0Adef%20swap01%27%20%3A%20Equiv.Perm%20%28Fin%203%29%20%3A%3D%20Equiv.swap%200%201%0A%0A--%20The%203-cycle%200%20%E2%86%92%201%20%E2%86%92%202%20%E2%86%92%200%20%E2%80%94%20the%20Mathlib%20analogue%20of%20%60cycle012%60.%0Adef%20cycle012%27%20%3A%20Equiv.Perm%20%28Fin%203%29%20%3A%3D%20finRotate%203%0A%0A%23eval%20%28swap01%27%20%2A%20cycle012%27%29%200%20%20%20--%200%0A%23eval%20%28cycle012%27%20%2A%20swap01%27%29%200%20%20%20%20--%202" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%3A%20Group%20%28Equiv.Perm%20%28Fin%203%29%29%20%3A%3D%20inferInstance%0A%0A--%20Swap%200%20and%201%2C%20leave%202%20fixed%20%E2%80%94%20the%20Mathlib%20analogue%20of%20%60swap01%60.%0Adef%20swap01%27%20%3A%20Equiv.Perm%20%28Fin%203%29%20%3A%3D%20Equiv.swap%200%201%0A%0A--%20The%203-cycle%200%20%E2%86%92%201%20%E2%86%92%202%20%E2%86%92%200%20%E2%80%94%20the%20Mathlib%20analogue%20of%20%60cycle012%60.%0Adef%20cycle012%27%20%3A%20Equiv.Perm%20%28Fin%203%29%20%3A%3D%20finRotate%203%0A%0A%23eval%20%28swap01%27%20%2A%20cycle012%27%29%200%20%20%20--%200%0A%23eval%20%28cycle012%27%20%2A%20swap01%27%29%200%20%20%20%20--%202" title="Lean playground" loading="lazy" style="width:100%;height:250px;border:1px solid #ccc;border-radius:8px;">
</iframe>

No `Perm3` bundle, no hand-written extensionality lemma, and no field-by-field
`Group` construction are needed: `Equiv.Perm (Fin 3)` (the type of bijections
`Fin 3 ≃ Fin 3`) is already known to be a group, [`Equiv.swap`](https://loogle.lean-lang.org/?q=Equiv.swap) and
[`finRotate`](https://loogle.lean-lang.org/?q=finRotate) are Mathlib's own constructors for a transposition and a
rotation, and `*` is the already-registered group operation (composition,
matching `Perm3.comp`'s convention). The two `#eval`s are the same
"compute a witness of non-commutativity" move as `swap01`/`cycle012`
above, now applied to the library's own $S_3$.

## Next

Continue to [Accessing the fields](05-accessing-fields.md).

---

[← Integers example](03-integers-example.md) | [Index](00-index.md) | [Next: Accessing the fields →](05-accessing-fields.md)
