## Extending structures

[← Type parameters](02-type-parameters.md) | [Index](00-index.md)

---

```lean
structure Point3D extends Point where
  z : Nat

def origin3D : Point3D := { x := 0, y := 0, z := 0 }

#eval origin3D.x   -- inherited field, 0
```

We'll use `extends` later: a `CommGroup` (commutative group) will `extend`
`Group` with one extra axiom (commutativity), instead of repeating all the
group fields.

**Mathematical reading.** `structure Point3D extends Point where z : Nat`
is the product $\mathrm{Point3D} = \mathrm{Point} \times \mathbb{N} \cong
\mathbb{N} \times \mathbb{N} \times \mathbb{N}$, together with the
*forgetful map* $\mathrm{Point3D} \to \mathrm{Point}$ (projecting away
$z$), generated automatically as `.toPoint`. In algebraic language, this is
exactly the pattern "a $\mathrm{Point3D}$-structure is a $\mathrm{Point}$-structure
plus one more piece of data." This is precisely how a `CommGroup` will
later be "a `Group`-structure plus one more axiom ($ab = ba$)": a
full subcategory of `Group` cut out by an extra condition, with the
forgetful functor $\mathrm{CommGroup} \to \mathrm{Group}$ being exactly
`.toGroup`.

## Next

Continue to [Chapter 3: Propositions and proofs](../03-propositions-and-proofs/00-index.md).

---

[← Type parameters](02-type-parameters.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 3: Propositions & Proofs →](../03-propositions-and-proofs/00-index.md)
