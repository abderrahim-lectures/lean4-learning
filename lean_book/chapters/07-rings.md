# Chapter 7: Rings — adding a second operation

[← Ch. 6: Group Theorems](06-group-theorems.md) | [Table of contents](../README.md) | [Ch. 8: Ring Theorems →](08-ring-theorems.md)

---

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

## Example: $2\times 2$ matrices — a genuinely noncommutative ring

`intRing` above is commutative (`Int.mul_comm` exists, even if we didn't
wire it into `Ring`'s fields), so it doesn't exercise the fact that `Ring`
deliberately does *not* assume `mul_comm`. Matrices do: $M_2(\mathbb{Z})$,
the ring of $2\times 2$ integer matrices under matrix addition and
multiplication, has $AB \neq BA$ in general. It's also a good stress-test
of `mul_assoc`, since matrix multiplication's associativity is not a
one-line library lemma call — it genuinely takes some work, which is the
point of walking through it.

We represent a $2 \times 2$ matrix as a `structure` with four entries
(there are more scalable representations — `Fin 2 → Fin 2 → Int`, or
Mathlib's general `Matrix` — but four named fields keep every computation
fully explicit, which is what we want here):

```lean
structure Mat2 where
  a11 : Int
  a12 : Int
  a21 : Int
  a22 : Int

def Mat2.add (X Y : Mat2) : Mat2 where
  a11 := X.a11 + Y.a11
  a12 := X.a12 + Y.a12
  a21 := X.a21 + Y.a21
  a22 := X.a22 + Y.a22

def Mat2.neg (X : Mat2) : Mat2 where
  a11 := -X.a11
  a12 := -X.a12
  a21 := -X.a21
  a22 := -X.a22

def Mat2.zero : Mat2 := ⟨0, 0, 0, 0⟩

-- (row i, col k) entry of X * Y is Σⱼ X[i,j] * Y[j,k]; with only two
-- indices this sum is just two terms, written out directly.
def Mat2.mul (X Y : Mat2) : Mat2 where
  a11 := X.a11 * Y.a11 + X.a12 * Y.a21
  a12 := X.a11 * Y.a12 + X.a12 * Y.a22
  a21 := X.a21 * Y.a11 + X.a22 * Y.a21
  a22 := X.a21 * Y.a12 + X.a22 * Y.a22

def Mat2.one : Mat2 := ⟨1, 0, 0, 1⟩
```

### Why matrix multiplication is noncommutative — check it computationally first

Before building the `Ring Mat2` instance, confirm the very fact that
motivates using this example at all:

```lean
def X : Mat2 := ⟨1, 1, 0, 1⟩
def Y : Mat2 := ⟨1, 0, 1, 1⟩

#eval Mat2.mul X Y   -- ⟨2, 1, 1, 1⟩
#eval Mat2.mul Y X    -- ⟨1, 1, 1, 2⟩
```

`#eval` here is doing real work: it's a two-line proof by computation that
`mul` is not commutative, cheaper than any hand-written counterexample
proof and exactly the kind of thing to reach for before committing to a
`theorem` — if you ever *do* want `¬ ∀ X Y, Mat2.mul X Y = Mat2.mul Y X` as
a theorem, this computed pair `(X, Y)` is your witness.

### The additive group and the ring

```lean
def mat2Group : Group Mat2 where
  op := Mat2.add
  id := Mat2.zero
  inv := Mat2.neg
  assoc := by
    intro X Y Z
    -- Goal: Mat2.add (Mat2.add X Y) Z = Mat2.add X (Mat2.add Y Z)
    show Mat2.mk _ _ _ _ = Mat2.mk _ _ _ _
    -- Each of the four field-equations reduces to Int addition's
    -- associativity, entrywise. `Mat2.ext` (the automatically generated
    -- extensionality lemma: two Mat2's are equal iff all four fields
    -- match) lets us split the single Mat2 equality into four Int
    -- equalities.
    apply Mat2.ext <;> exact Int.add_assoc _ _ _
  id_left := by
    intro X
    apply Mat2.ext <;> exact Int.zero_add _
  id_right := by
    intro X
    apply Mat2.ext <;> exact Int.add_zero _
  inv_left := by
    intro X
    apply Mat2.ext <;> exact Int.add_left_neg _
  inv_right := by
    intro X
    apply Mat2.ext <;> exact Int.add_right_neg _

def mat2CommGroup : CommGroup Mat2 where
  toGroup := mat2Group
  comm := by
    intro X Y
    apply Mat2.ext <;> exact Int.add_comm _ _

def mat2Ring : Ring Mat2 where
  addGrp := mat2CommGroup
  mul := Mat2.mul
  one := Mat2.one
  mul_assoc := by
    intro X Y Z
    -- Unlike addition, each entry of (X * Y) * Z expands to a sum of
    -- *four* products of three matrix entries (vs. Int.mul_assoc's single
    -- rebracketing) — associativity of matrix multiplication is
    -- distributivity-plus-associativity of the underlying ring applied
    -- four times per entry, not a single lemma call. `ring` (a decision
    -- procedure for commutative-ring identities, safe to use here since
    -- each entry equation only involves `Int`, which *is* commutative,
    -- even though `Mat2` itself is not) closes each resulting Int
    -- equation in one shot once the entrywise split has been made.
    apply Mat2.ext <;> ring
  one_mul := by
    intro X
    apply Mat2.ext <;> ring
  mul_one := by
    intro X
    apply Mat2.ext <;> ring
  left_distrib := by
    intro X Y Z
    apply Mat2.ext <;> ring
  right_distrib := by
    intro X Y Z
    apply Mat2.ext <;> ring
```

Two points worth pulling out:

1. **`Mat2.ext <;> ring` is a deliberate, scoped use of automation** (unlike
   the "always spell it out" rule elsewhere in this book) precisely because
   the underlying per-entry fact — a polynomial identity in `Int`, which
   *is* a commutative ring — is exactly what `ring` is designed to decide,
   and hand-deriving it would just be re-proving commutative-ring axioms
   Lean already has. What's *not* automated is the interesting content: the
   `Ring Mat2` bundle itself is noncommutative, and no automation is
   deciding *that* for you — you supplied `mul := Mat2.mul` and the
   `mul_comm`-shaped fact is simply absent from `Ring`'s fields, exactly as
   Chapter 7's exercise on `left_distrib`/`right_distrib` anticipated.
2. **This is the general pattern for "ring of $n\times n$ matrices over a
   commutative ring $S$":** the entries live in $S$, every `Ring Mat2`
   proof obligation reduces (via distributivity/associativity in $S$,
   applied a bounded number of times depending on $n$) to a polynomial
   identity purely in $S$, and $\text{Mat}_n(S)$ itself is noncommutative as
   soon as $n \geq 2$, regardless of whether $S$ is commutative. Matrix
   rings are the standard first example that any general ring theory
   (Chapter 8's theorems, Mathlib's `Ring` hierarchy) has to handle
   *without* assuming commutativity — which is exactly why `Ring` doesn't
   bake in `mul_comm`.

## Exercises

1. Build `boolAndOrRing`? Try it and see why it's surprisingly hard: is
   there a natural ring structure on `Bool`? (Hint: think of `Bool` as
   $\mathbb{Z}/2\mathbb{Z}$ — addition is XOR, multiplication is AND. Build
   `intAddGroupMod2 : CommGroup Bool` with `op := Bool.xor`, then a
   `Ring Bool` using `mul := Bool.and`, `one := true`.)
2. State (in words, no Lean needed yet) why we needed *both*
   `left_distrib` and `right_distrib` as separate axioms, tying it back to
   not assuming `mul` is commutative.
3. Using the witness pair `(X, Y)` computed above, state and prove
   `theorem mat2_not_comm : ∃ X Y : Mat2, Mat2.mul X Y ≠ Mat2.mul Y X`
   (hint: `⟨X, Y, by decide⟩` or `⟨X, Y, by simp [X, Y, Mat2.mul]⟩` —
   whichever your toolchain accepts; check what `decide` actually does here
   and whether it's appropriate per Chapter 10's discussion of decision
   procedures).

## Next

Continue to [Chapter 8: Ring examples and basic theorems](08-ring-theorems.md).

---

[← Ch. 6: Group Theorems](06-group-theorems.md) | [Table of contents](../README.md) | [Ch. 8: Ring Theorems →](08-ring-theorems.md)
