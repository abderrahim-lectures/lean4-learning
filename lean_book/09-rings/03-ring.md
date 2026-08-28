## `Ring`: bundling an additive `CommGroup` with multiplication

[← CommGroup](02-comm-group.md) | [Index](00-index.md) | [Next: Integers example →](04-integers-example.md)

---

`CommGroup` closed off the additive side of a ring. `extends Group G`
plus one extra axiom, `comm`, is already enough to say "$(R, +)$ is an
abelian group." What a group, even a commutative one, still cannot
express is a *second* operation living alongside the first, one that
interacts with addition through distributivity rather than standing
apart from it. `Ring` is exactly that. `CommGroup` supplies (R1) whole,
as a single bundled field, and the definition below adds the remaining
axioms (R2)–(R4) needed to make multiplication a genuine second citizen
of the structure.

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

Consider each field in turn.

- `addGrp : CommGroup R`. The whole additive structure ($+$, $0$, unary
  minus, and commutativity) is a single field, itself a bundled structure.
  This is the "structures containing structures" pattern.
- `mul`, `one`. The multiplicative operation and its identity, `1`.
- `mul_assoc`, `one_mul`, `mul_one`. Multiplication is associative and has
  a two-sided identity. Note, however, that `mul` is **not** required to be
  commutative or to have inverses. General rings need neither. (A
  commutative ring would add a `mul_comm` field, the same way `CommGroup`
  added `comm` to `Group`.)
- `left_distrib`, `right_distrib`. Multiplication distributes over
  addition on both sides. Both are needed precisely because `mul` is not
  assumed to be commutative.

`addGrp.op` will be written constantly below; notation-free helper
abbreviations could be defined later. For now everything is spelled out so
each usage is traceable to the definition above.

**Mathematical reading.** `Ring R` is exactly the textbook definition of a
(unital, not-necessarily-commutative) ring, presented as a tuple
$$
\Big(\,(R,+,0,-)\in\mathbf{Ab},\ \cdot : R\times R\to R,\ 1\in R,\
\text{proofs of }(\mathrm{R2}),(\mathrm{R3}),(\mathrm{R4})\,\Big).
$$
The field `addGrp` is the *underlying additive abelian group*, so a ring is
"an abelian group $(R,+)$ carrying a compatible monoid structure
$(R,\cdot,1)$", a monoid (a set with an associative operation and identity
element, i.e. a group without inverses). The remaining fields say
$(R,\cdot,1)$ is a monoid (`mul_assoc`, `one_mul`, `mul_one`) and that the
two operations interact through the two-sided distributive laws, that is,
multiplication is compatible with addition on both sides. Nesting `addGrp`
as a whole substructure mirrors the
[forgetful functor](../02-terminology-and-coc/01-terminology.md#category-theory-terms-used-beyond-the-baseline)
$\mathbf{Ring}\to\mathbf{Ab}$ sending a ring to its additive group.

> Read more. `Ring` in Mathlib (`Mathlib.Algebra.Ring.Defs`) sits inside a
> much larger hierarchy, `Semiring`, `NonUnitalRing`, `CommRing`,
> `DivisionRing`, `Field`, each adding or dropping exactly one axiom
> compared to its neighbors; see [Chapter 14](../14-next-steps/02-moving-to-mathlib.md).
> For the classical (non-Lean) statement of these axioms and their
> standard consequences, *Abstract Algebra* by Dummit & Foote or
> *Algebra: Chapter 1* by Aluffi (the latter using the same categorical
> framing this book uses) are standard references.

**Programmer note (Python).** `mul_assoc` and `left_distrib`/
`right_distrib` are not free assumptions here. Whoever builds a
`Ring R` must supply an actual proof of each, for the specific `mul`
and `addGrp.op` chosen. Python's built-in `float` looks like it forms
a ring, `+`, `*`, `0.0`, `1.0` are all present, but the axioms above
simply do not hold for it.

```python
a, b, c = 0.1, 0.2, 0.3
print((a + b) + c == a + (b + c))   # False
```

`(a + b) + c` and `a + (b + c)` are two different `float` values,
differing in the last bit, because floating-point rounding depends on
the order additions happen in. Associativity, the very first axiom
listed above, silently fails, and nothing in Python raises an error
about it, since `float` was never required to prove any such thing
before being handed the `+` operator. Code that assumes
`(a + b) + c == a + (b + c)`, to reorder a sum for performance or
parallelize it across workers, is trusting a law that Python's own
numeric types do not actually satisfy. `mul_assoc` above rules this
out completely for anything built as a `Ring`. If `R` were instantiated
with a type where associativity genuinely failed, `mul_assoc` could not
be proved, and no `Ring R` value could be constructed at all.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Ring.** "(i) $(R, +)$ is an abelian group, (ii) $\times$ is
  associative ... (iii) the distributive laws hold" ([DummitFoote2003],
  §7.1 "Basic Definitions and Examples," pp. 222–223). A basic
  consequence: "$0a = a0 = 0$ for all $a \in R$" (p. 225, Proposition
  1).
- Aluffi ([Aluffi2009]) is offered as further reading, not an independently verified factual claim. The use of forgetful functors and universal properties by Aluffi is publicly documented in the table of contents of that book, not quoted from a verified excerpt.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003
[Aluffi2009]: ../bibliography.md#aluffi2009

---

[← CommGroup](02-comm-group.md) | [Index](00-index.md) | [Next: Integers example →](04-integers-example.md)
