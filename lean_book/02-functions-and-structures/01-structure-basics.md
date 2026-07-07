## `structure`: bundling data together

[← Index](00-index.md) | [Next: Structures with type parameters →](02-type-parameters.md)

---

A `structure` groups several pieces of data under one name. This is the
Lean feature we will use constantly once we define groups and rings.

```lean
structure Point where
  x : Nat
  y : Nat

def origin : Point := { x := 0, y := 0 }

#eval origin.x        -- 0

def shift (p : Point) (dx dy : Nat) : Point :=
  { x := p.x + dx, y := p.y + dy }

#eval (shift origin 3 4).y   -- 4
```

Key points:

- `Point.mk` is the automatically generated **constructor**. `{ x := ..., y := ... }`
  is anonymous-constructor sugar for `Point.mk ... ...`.
  `p.x` is **field projection** notation, sugar for `Point.x p`.
- Structures can bundle *proofs* alongside data, not just data. This is
  exactly how we'll define a group: a carrier type, an operation, and
  proofs that the operation satisfies the group axioms — all in one
  `structure`.

**Mathematical reading.** `structure Point where x : Nat; y : Nat` is the
Cartesian product $\mathrm{Point} = \mathbb{N} \times \mathbb{N}$, with `x`
and `y` playing the role of the two projections
$\pi_1, \pi_2 : \mathrm{Point} \to \mathbb{N}$ — `p.x` computing $\pi_1(p)$,
`p.y` computing $\pi_2(p)$, and `{ x := ..., y := ... }` building an
element via the universal property of the product (a pair of maps into the
factors determines a unique map into the product). More generally, a
`structure` with fields of types $A_1, \ldots, A_n$ is the $n$-fold product
$A_1 \times \cdots \times A_n$; once fields are allowed to be *proofs*
(propositions), the same construction becomes a **subset cut out by
conditions** — a structure `{ data : D, proof : P data }` is the dependent
pair (subset) $\{\, d \in D \mid P(d) \,\}$, categorically a subobject of
$D$.

---

[← Index](00-index.md) | [Next: Structures with type parameters →](02-type-parameters.md)
