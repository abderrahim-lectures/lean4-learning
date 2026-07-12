## `structure`: bundling data together

[← Index](00-index.md) | [Next: Structures with type parameters →](02-type-parameters.md)

---

A `structure` groups several pieces of data under one name. We will use
this Lean feature constantly once we define groups and rings.

```lean
structure Point where
  x : Nat
  y : Nat

def origin : Point := { x := 0, y := 0 }

#eval origin.x        -- 0
```

Key points:

- `Point.mk` is the automatically generated **constructor**. This is the
  function that actually builds a `Point` out of an `x` and a `y`. `{ x :=
  ..., y := ... }` is shorthand for `Point.mk ... ...`. It names each field
  so you can't mix up the order.
- There's an even shorter way to write this: `⟨0, 0⟩` builds the exact
  same `Point`. It just lists the values in field-declaration order
  instead of naming them. Read `⟨_, _⟩` as **"here are the pieces, in
  order — you figure out which constructor I mean."** Lean can always
  figure it out, because the *expected type* (here, `Point`, from `def
  origin : Point := ...`) tells it exactly which constructor and which
  fields you must fill in. This is also where the official name comes
  from: it's called the **anonymous constructor**, because you never write
  `Point.mk`. You leave it anonymous, and Lean infers it from context.
  You'll see `⟨_, _⟩` used constantly from Chapter 3 onward, for proofs as
  much as for data.
- `p.x` is **field projection** notation, shorthand for `Point.x p`.
  `origin.x` above is exactly this projection applied to `origin`.

```lean
def shift (p : Point) (dx dy : Nat) : Point :=
  { x := p.x + dx, y := p.y + dy }

#eval (shift origin 3 4).y   -- 4
```

`shift` shows a structure used on *both* sides of a function: it takes a
`Point` in (reading its fields back out with the same `p.x`/`p.y`
projection notation) and builds a new one via `{ x := ..., y := ... }`,
the same field-naming syntax `origin` used above.

One more thing worth knowing before we move on: structures can bundle
*proofs* alongside data, not just data. This is exactly how we'll define a
group — a carrier type, an operation, and proofs that the operation
satisfies the group axioms, all in one `structure`.

**Mathematical reading.** `structure Point where x : Nat; y : Nat` is the
Cartesian product $\mathrm{Point} = \mathbb{N} \times \mathbb{N}$, with `x`
and `y` playing the role of the two projections
$\pi_1, \pi_2 : \mathrm{Point} \to \mathbb{N}$. Here `p.x` computes
$\pi_1(p)$, `p.y` computes $\pi_2(p)$, and `{ x := ..., y := ... }` builds
an element via the universal property of the product (a pair of maps into
the factors determines a unique map into the product). More generally, a
`structure` with fields of types $A_1, \ldots, A_n$ is the $n$-fold product
$A_1 \times \cdots \times A_n$. Once fields are allowed to be *proofs*
(propositions), the same construction becomes a **subset cut out by
conditions**: a structure `{ data : D, proof : P data }` is the dependent
pair (subset) $\{\, d \in D \mid P(d) \,\}$, categorically a subobject of
$D$.

---

[← Index](00-index.md) | [Next: Structures with type parameters →](02-type-parameters.md)
