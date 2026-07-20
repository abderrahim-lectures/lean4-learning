## Extending structures

[← Type parameters](02-type-parameters.md) | [Index](00-index.md)

---

### Recall

Formal definitions cited in this section, gathered here for quick
reference (full citations in the [Bibliography](../bibliography.md)):

- **Forgetful functor.** "A functor which simply 'forgets' some or all
  of the structure of an algebraic object is commonly called a
  forgetful functor (or, an underlying functor). Thus the forgetful
  functor $U : \mathbf{Grp} \to \mathbf{Set}$ assigns to each group
  $G$ the set $UG$ of its elements..." ([MacLane1998], Ch. I §3,
  p. 14). Brief: `extends` builds a new structure containing
  everything an existing one has, plus more, generating a `.toX`
  forgetful projection for free.

```lean
structure Point3D extends Point where
  z : Nat

def origin3D : Point3D := { x := 0, y := 0, z := 0 }

#eval origin3D.x   -- inherited field, 0
```

`extends` is used later: a `CommGroup` (commutative group) will `extend`
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

### References

Full citations in the [Bibliography](../bibliography.md). Formal
definitions are gathered in Recall, above.

- Lean 4 documentation ([LeanDocs]) — the auto-generated `.toX` projection produced by `extends`, used above as `origin3D.x` and `.toPoint`.
- Mac Lane ([MacLane1998]), Ch. I §3 "Functors," p. 14 — forgetful functor.

[LeanDocs]: ../bibliography.md#leandocs
[MacLane1998]: ../bibliography.md#maclane1998

**Key points.** A `structure` bundles data (and optionally proofs) under
one name, built via the anonymous constructor `⟨...⟩` and read back out
via field projection `.field`. `extends` builds a new structure containing
everything an existing one has, plus more, generating a `.toX` forgetful
projection for free — the exact mechanism `CommGroup` uses to add
commutativity to `Group` in Chapter 6.

**Socratic questions.**

1. *`⟨0, 0⟩` and `{ x := 0, y := 0 }` build the identical `Point`. Since
   the named form says more, why does the anonymous form ever get used?*
   Because the *expected type* already says which fields are which —
   `def origin : Point := ⟨0, 0⟩` cannot be ambiguous, since Lean already
   knows a `Point` is being built and in what field order. The named form
   earns its keep only when that context is not enough to make the
   assignment obvious to a reader.
2. *`Point3D extends Point` generates `.toPoint` automatically. What
   would have to be written by hand instead, if `extends` did not
   exist?* A separate function `Point3D.toPoint : Point3D → Point`
   projecting out the shared fields one at a time — exactly what a
   forgetful functor does explicitly, which is the whole reason `extends`
   is read categorically rather than as a mere convenience keyword.
3. *A `structure` can bundle proofs as fields, not only data. What
   changes about *checking* that a term has the right type, once one of
   its fields is a proof rather than a number?* Nothing about the
   mechanism — Lean still checks the field has the stated type — but the
   stated type is now a proposition, so supplying that field means
   supplying a proof, checked once at construction time. This is exactly
   what makes `Group` (Chapter 6) impossible to build carelessly: the
   axiom fields cannot be filled in with nonsense that happens to
   type-check as data can.

## Next

Continue to [Chapter 3: Propositions and proofs](../03-propositions-and-proofs/00-index.md).

---

[← Type parameters](02-type-parameters.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 3: Propositions & Proofs →](../03-propositions-and-proofs/00-index.md)
