# Chapter 7: Rings — adding a second operation

## The mathematical definition

A **ring** is a set $R$ with *two* binary operations, addition and
multiplication, such that:

$$
\begin{aligned}
\text{(R1)}&\quad (R, +, 0, -(-)) \text{ is a commutative group} \\
\text{(R2)}&\quad (a \cdot b) \cdot c = a \cdot (b \cdot c) \quad \text{(multiplication is associative)} \\
\text{(R3)}&\quad \exists\, 1 \in R,\ 1 \cdot a = a \text{ and } a \cdot 1 = a \quad \text{(multiplicative identity)} \\
\text{(R4)}&\quad a \cdot (b + c) = a \cdot b + a \cdot c, \quad (a + b) \cdot c = a \cdot c + b \cdot c \quad \text{(distributivity)}
\end{aligned}
$$

(Some textbooks don't require a multiplicative identity — that's called a
*rng* (missing the "i"). We include it, matching the most common convention.)

Note (R1) requires **commutative** addition, unlike our general `Group` from
Chapter 5. So before defining `Ring`, we first define what "commutative"
means as an extension of `Group`.

## `CommGroup`: extending `Group` with one extra axiom

```lean
structure CommGroup (G : Type) extends Group G where
  comm : ∀ a b : G, op a b = op b a
```

Recall `extends` from Chapter 2: a `CommGroup G` *is* a `Group G` (it has
every field `Group G` has — `op`, `id`, `inv`, `assoc`, etc.) plus one more
field, `comm`. Anywhere a `Group G` is expected, you can pass a
`CommGroup G` (via `.toGroup`).

## `Ring`: bundling an additive `CommGroup` with multiplication

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

## Example: the integers as a ring

We reuse `intGroup` from Chapter 5 as the additive part.

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
   exactly as in Chapter 5 — we are not proving integer arithmetic from
   nothing, only assembling already-known facts into the `Ring` bundle.

## Accessing nested fields

```lean
#eval intRing.addGrp.op 3 4     -- 7  (addition, via the nested CommGroup)
#eval intRing.mul 3 4            -- 12 (multiplication)
#eval intRing.one                 -- 1
#eval intRing.addGrp.toGroup.inv 5   -- -5  (additive inverse, via Group inside CommGroup)
```

## Exercises

1. Build `boolAndOrRing`? Try it and see why it's surprisingly hard: is
   there a natural ring structure on `Bool`? (Hint: think of `Bool` as
   $\mathbb{Z}/2\mathbb{Z}$ — addition is XOR, multiplication is AND. Build
   `intAddGroupMod2 : CommGroup Bool` with `op := Bool.xor`, then a
   `Ring Bool` using `mul := Bool.and`, `one := true`.)
2. State (in words, no Lean needed yet) why we needed *both*
   `left_distrib` and `right_distrib` as separate axioms, tying it back to
   not assuming `mul` is commutative.

## Next

Continue to [Chapter 8: Ring examples and basic theorems](08-ring-theorems.md).
