# Chapter 2: Functions, definitions, and structures

[← Ch. 1: Basics](01-basics.md) | [Table of contents](../README.md) | [Ch. 3: Propositions & Proofs →](03-propositions-and-proofs.md)

---

Functions curry as usual (`add : Nat → Nat → Nat` is really
`Nat → (Nat → Nat)`); nothing here should be surprising if you've used any
ML-family or dependently-typed language. The interesting part of this
chapter is `structure`, which is how we'll package algebraic data.

## `structure`: bundling data together

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

## Structures with type parameters

```lean
structure Pair (α β : Type) where
  fst : α
  snd : β

def p : Pair Nat String := { fst := 1, snd := "one" }

#eval p.fst    -- 1
#eval p.snd     -- "one"
```

This generalizes directly to how we will write, e.g., `structure Group (α : Type)`.

## Extending structures

```lean
structure Point3D extends Point where
  z : Nat

def origin3D : Point3D := { x := 0, y := 0, z := 0 }

#eval origin3D.x   -- inherited field, 0
```

We'll use `extends` later: a `CommGroup` (commutative group) will `extend`
`Group` with one extra axiom (commutativity), rather than repeating all the
group fields.

## Next

Continue to [Chapter 3: Propositions and proofs](03-propositions-and-proofs.md).

---

[← Ch. 1: Basics](01-basics.md) | [Table of contents](../README.md) | [Ch. 3: Propositions & Proofs →](03-propositions-and-proofs.md)
