## Theorem 3: inverse of a product

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md) | [Next: Exercises →](05-exercises.md)

---

**Claim.** `Grp.inv (Grp.op a b) = Grp.op (Grp.inv b) (Grp.inv a)`.

**Finding the proof.** This *looks* like it should again be "chain of
equalities," but there's a shortcut once you recognize the goal's shape
matches a theorem you already have. The claim states that some element
(`Grp.inv (Grp.op a b)`) equals some other expression built from `a`, `b`.
Theorem 2 already tells you: *to show `x = Grp.inv y`, it suffices to show
`x` is a left inverse of `y`* — i.e. reduce an inverse-computation goal to a
single equation `Grp.op x y = Grp.id`, which is usually easier to attack
directly with `assoc`/`inv_left`/`inv_right` than staring at `inv (...)`.
This is a general and reusable move: **once you've proved a
uniqueness/characterization lemma, use it to convert "compute this thing"
goals into "verify this thing satisfies the characterizing property"
goals** — almost always a simpler target.

Applying that here (with the goal read backwards, `apply Eq.symm` first, so
`left_inverse_unique` unifies against the "b" slot), the remaining goal is
`Grp.op (Grp.op (Grp.inv b) (Grp.inv a)) (Grp.op a b) = Grp.id` — pure
cancellation: regroup with `assoc` until `Grp.inv a` sits next to `a`,
cancel via `inv_left`, then `Grp.inv b` sits next to `b`, cancel again.

```lean
theorem inv_op (a b : G) :
    Grp.inv (Grp.op a b) = Grp.op (Grp.inv b) (Grp.inv a) := by
  apply Eq.symm
  apply left_inverse_unique
  -- Goal: op (op (inv b) (inv a)) (op a b) = id
  rw [Grp.assoc]
  -- Goal: op (inv b) (op (inv a) (op a b)) = id
  rw [← Grp.assoc (Grp.inv a) a b]
  -- Goal: op (inv b) (op (op (inv a) a) b) = id
  rw [Grp.inv_left]
  -- Goal: op (inv b) (op id b) = id
  rw [Grp.id_left]
  -- Goal: op (inv b) b = id
  exact Grp.inv_left b
```

Notice how much of this `rw` chain is **regrouping via `assoc` to bring a
cancelable pair adjacent**, then cancelling. That two-step pattern —
*regroup, then cancel* — recurs constantly in algebra and is worth
recognizing on sight rather than re-deriving from scratch each time.

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
"for free" on every group you build afterward. Here is that promise
redeemed: `inv_op`, proved above for an *arbitrary* `Grp : Group G`,
applies immediately to `perm3Group` — Chapter 6's non-abelian permutation
group — with no new proof required:

```lean
example : perm3Group.inv (perm3Group.op swap01 cycle012) =
    perm3Group.op (perm3Group.inv cycle012) (perm3Group.inv swap01) :=
  inv_op perm3Group swap01 cycle012
```

That's the entire proof — a single application of the already-proved
`inv_op`, instantiated at `Grp := perm3Group`, `a := swap01`,
`b := cycle012`. You can also check it computationally, pointwise, on
every element of `Fin 3`:

```lean
#eval (perm3Group.inv (perm3Group.op swap01 cycle012)).toFun 0  -- 0
#eval (perm3Group.op (perm3Group.inv cycle012) (perm3Group.inv swap01)).toFun 0  -- 0
#eval (perm3Group.inv (perm3Group.op swap01 cycle012)).toFun 1  -- 2
#eval (perm3Group.op (perm3Group.inv cycle012) (perm3Group.inv swap01)).toFun 1  -- 2
#eval (perm3Group.inv (perm3Group.op swap01 cycle012)).toFun 2  -- 1
#eval (perm3Group.op (perm3Group.inv cycle012) (perm3Group.inv swap01)).toFun 2  -- 1
```

Both sides agree on every input — exactly what `inv_op`'s proof
guarantees, now witnessed by direct computation rather than taken on
faith. This is the concrete content of "prove it once, get it for free
everywhere": nothing about `swap01`, `cycle012`, or the fact that
`perm3Group` is non-abelian required revisiting `inv_op`'s proof at all.

---

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md) | [Next: Exercises →](05-exercises.md)
