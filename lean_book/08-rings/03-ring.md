## `Ring`: bundling an additive `CommGroup` with multiplication

[← CommGroup](02-comm-group.md) | [Index](00-index.md) | [Next: Integers example →](04-integers-example.md)

---

```lean
structure Ring (R : Type) where
  addGrp : CommGroup R
  mul : R → R → R
  one : R
  mul_assoc : ∀ a b c : R, mul (mul a b) c = mul a (mul b c)
  one_mul : ∀ a : R, mul one a = a
  mul_one : ∀ a : R, mul a one = a
  left_distrib : ∀ a b c : R, mul a (addGrp.op b c) = addGrp.op (mul a b) (mul a c)
  right_distrib : ∀ a b c : R, mul (addGrp.op a b) c = addGrp.op (mul a c) (mul b c)
```

Reading this field by field:

- `addGrp : CommGroup R` — the whole additive structure ($+$, $0$, unary
  minus, and commutativity) is a single field, itself a bundled structure.
  This is the "structures containing structures" pattern.
- `mul`, `one` — the multiplicative operation and its identity, `1`.
- `mul_assoc`, `one_mul`, `mul_one` — multiplication is associative and has
  a two-sided identity, but notice we do **not** require `mul` to be
  commutative or to have inverses — general rings need neither. (A
  commutative ring would add a `mul_comm` field, the same way `CommGroup`
  added `comm` to `Group`.)
- `left_distrib`, `right_distrib` — multiplication distributes over
  addition on both sides. We need both because we haven't assumed `mul` is
  commutative.

For convenience, since we'll write `addGrp.op` constantly, we can define
notation-free helper abbreviations later; for now we spell everything out so
each usage is traceable to the definition above.

**Mathematical reading.** `Ring R` is exactly the textbook definition of a
(unital, not-necessarily-commutative) ring, presented as a tuple
$$
\Big(\,(R,+,0,-)\in\mathbf{Ab},\ \cdot : R\times R\to R,\ 1\in R,\
\text{proofs of }(\mathrm{R2}),(\mathrm{R3}),(\mathrm{R4})\,\Big).
$$
The field `addGrp` is the *underlying additive abelian group*, so a ring is
"an abelian group $(R,+)$ carrying a compatible monoid structure
$(R,\cdot,1)$" — a monoid (a set with an associative operation and identity
element, i.e. a group without inverses). The remaining fields say
$(R,\cdot,1)$ is a monoid (`mul_assoc`, `one_mul`, `mul_one`) and that the
two operations interact via the two-sided distributive laws, i.e.
multiplication is compatible with addition on both sides. Nesting `addGrp`
as a whole substructure mirrors the
[forgetful functor](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
$\mathbf{Ring}\to\mathbf{Ab}$ sending a ring to its additive group.

> Read more: Mathlib's `Ring` (`Mathlib.Algebra.Ring.Defs`) sits inside a
> much larger hierarchy — `Semiring`, `NonUnitalRing`, `CommRing`,
> `DivisionRing`, `Field` — each adding or dropping exactly one axiom
> relative to its neighbors; see [Chapter 13](../13-next-steps/02-moving-to-mathlib.md).
> For the classical (non-Lean) statement of these axioms and their
> standard consequences, Dummit & Foote's *Abstract Algebra* or Aluffi's
> *Algebra: Chapter 0* (the latter emphasizing the same categorical
> framing this book uses) are standard references.

---

[← CommGroup](02-comm-group.md) | [Index](00-index.md) | [Next: Integers example →](04-integers-example.md)
