## Example: the integers as a ring

[← Ring](03-ring.md) | [Index](00-index.md) | [Next: Accessing nested fields →](05-accessing-fields.md)

---

We reuse `intGroup` from Chapter 6 as the additive part.

```lean
def intCommGroup : CommGroup Int where
  toGroup := intGroup
  comm := by
    intro a b
    exact Int.add_comm a b

def intRing : Ring Int where
  addGrp := intCommGroup
  mul := fun a b => a * b
  one := 1
  mul_assoc := by
    intro a b c
    exact Int.mul_assoc a b c
  one_mul := by
    intro a
    exact Int.one_mul a
  mul_one := by
    intro a
    exact Int.mul_one a
  left_distrib := by
    intro a b c
    exact Int.mul_add a b c
  right_distrib := by
    intro a b c
    exact Int.add_mul a b c
```

Two things worth noticing:

1. `toGroup := intGroup` fills the field inherited from `Group Int` inside
   `CommGroup Int`'s definition — this is how `extends` works mechanically:
   under the hood, `CommGroup G` really has fields `toGroup : Group G` and
   `comm : ...`, and Lean's dot-notation makes `cg.op` mean
   `cg.toGroup.op` automatically.
2. Every proof obligation is again a one-line `exact` naming a specific
   core-library fact about `Int` (`Int.mul_assoc`, `Int.one_mul`, ...),
   exactly as in Chapter 6 — we are not proving integer arithmetic from
   nothing, only assembling already-known facts into the `Ring` bundle.

**Mathematical reading.** This exhibits $(\mathbb{Z}, +, \times, 0, 1)$ as
an object of $\mathbf{Ring}$ — indeed the *initial* object, since there is a
unique ring homomorphism $\mathbb{Z} \to R$ into any ring. First
`intCommGroup` upgrades the additive group $(\mathbb{Z},+)$ to an abelian
group by supplying commutativity ($a + b = b + a$); then `intRing` adds the
multiplicative monoid $(\mathbb{Z}, \times, 1)$ and checks the distributive
laws $a(b+c) = ab + ac$ and $(a+b)c = ac + bc$. Each obligation is the named
$\mathbb{Z}$-arithmetic fact, so the term is the formal counterpart of
"$\mathbb{Z}$ is a commutative ring."

---

[← Ring](03-ring.md) | [Index](00-index.md) | [Next: Accessing nested fields →](05-accessing-fields.md)
