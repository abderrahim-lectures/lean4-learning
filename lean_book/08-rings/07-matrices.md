## Example: $2\times 2$ matrices — a genuinely noncommutative ring

[← Accessing nested fields](06-accessing-fields.md) | [Index](00-index.md) | [Next: Exercises →](08-exercises.md)

---

`intRing` above is commutative (`Int.mul_comm` exists, even though we didn't
wire it into `Ring`'s fields), so it doesn't test the fact that `Ring`
deliberately does *not* assume `mul_comm`. Matrices do: $M_2(\mathbb{Z})$,
the ring of $2\times 2$ integer matrices under matrix addition and
multiplication, has $AB \neq BA$ in general. It's also a good test
of [`mul_assoc`](https://loogle.lean-lang.org/?q=mul_assoc), since matrix multiplication's associativity is not a
one-line library lemma call. It genuinely takes some work, which is the
point of walking through it.

We represent a $2 \times 2$ matrix as a `structure` with four entries.
(There are more scalable representations — `Fin 2 → Fin 2 → Int`, or
Mathlib's general [`Matrix`](https://loogle.lean-lang.org/?q=Matrix) — but four named fields keep every computation
fully explicit, which is what we want here.)

```lean
structure Mat2 where
  a11 : Int
  a12 : Int
  a21 : Int
  a22 : Int

-- Core Lean 4 does not auto-generate a field-wise extensionality lemma
-- for a plain `structure` (that convenience is a Mathlib `@[ext]`
-- attribute); we supply one by hand, using the `mk.injEq` lemma core Lean
-- *does* generate for every structure, so it can be used below exactly
-- like an auto-generated `.ext` would be.
theorem Mat2.ext {X Y : Mat2} (h1 : X.a11 = Y.a11) (h2 : X.a12 = Y.a12)
    (h3 : X.a21 = Y.a21) (h4 : X.a22 = Y.a22) : X = Y := by
  cases X
  cases Y
  rw [Mat2.mk.injEq]
  exact ⟨h1, h2, h3, h4⟩
```

**Mathematical reading.** `Mat2` is the free $\mathbb{Z}$-module
$M_2(\mathbb{Z}) \cong \mathbb{Z}^4$ on the four matrix entries. The
extensionality lemma `Mat2.ext` — supplied by hand right alongside the
structure, since almost every proof below needs it — says two `Mat2`
values are equal exactly when all four entries match.

```lean
def Mat2.add (X Y : Mat2) : Mat2 where
  a11 := X.a11 + Y.a11
  a12 := X.a12 + Y.a12
  a21 := X.a21 + Y.a21
  a22 := X.a22 + Y.a22
```

`Mat2.add` is entrywise $+$.

```lean
def Mat2.neg (X : Mat2) : Mat2 where
  a11 := -X.a11
  a12 := -X.a12
  a21 := -X.a21
  a22 := -X.a22
```

`Mat2.neg` is entrywise $-$.

```lean
def Mat2.zero : Mat2 := ⟨0, 0, 0, 0⟩
```

`Mat2.zero` is the zero matrix.

```lean
-- (row i, col k) entry of X * Y is Σⱼ X[i,j] * Y[j,k]; with only two
-- indices this sum is just two terms, written out directly.
def Mat2.mul (X Y : Mat2) : Mat2 where
  a11 := X.a11 * Y.a11 + X.a12 * Y.a21
  a12 := X.a11 * Y.a12 + X.a12 * Y.a22
  a21 := X.a21 * Y.a11 + X.a22 * Y.a21
  a22 := X.a21 * Y.a12 + X.a22 * Y.a22
```

`Mat2.mul` is the matrix product with $(XY)_{ik} = \sum_j X_{ij}Y_{jk}$, here
the two-term sums since $n = 2$.

```lean
def Mat2.one : Mat2 := ⟨1, 0, 0, 1⟩
```

`Mat2.one` is the identity $I = \begin{psmallmatrix}1&0\\0&1\end{psmallmatrix}$.
Together these five definitions are the operations of the matrix ring
$M_2(\mathbb{Z})$.

### Why matrix multiplication is noncommutative — check it computationally first

Before building the `Ring Mat2` instance, let's confirm the very fact that
is the reason for using this example at all:

```lean
def X : Mat2 := ⟨1, 1, 0, 1⟩
def Y : Mat2 := ⟨1, 0, 1, 1⟩

#eval Mat2.mul X Y   -- ⟨2, 1, 1, 1⟩
#eval Mat2.mul Y X    -- ⟨1, 1, 1, 2⟩
```

`#eval` here is doing real work: it's a two-line proof by computation that
`mul` is not commutative. This is cheaper than any hand-written counterexample
proof, and it's exactly the kind of thing to try before committing to a
`theorem`. If you ever *do* want `¬ ∀ X Y, Mat2.mul X Y = Mat2.mul Y X` as
a theorem, this computed pair `(X, Y)` is your witness.

**Mathematical reading.** This is the standard counterexample to
commutativity of matrix multiplication: with $X =
\begin{psmallmatrix}1&1\\0&1\end{psmallmatrix}$ and $Y =
\begin{psmallmatrix}1&0\\1&1\end{psmallmatrix}$ (elementary shear matrices),
$$
XY = \begin{psmallmatrix}2&1\\1&1\end{psmallmatrix} \neq
\begin{psmallmatrix}1&1\\1&2\end{psmallmatrix} = YX,
$$
so $M_2(\mathbb{Z})$ is a *non*commutative ring. The pair $(X, Y)$ is a
concrete witness for the existential $\exists X, Y,\ XY \neq YX$.

**Mathlib equivalent.** Mathlib's `Matrix (Fin 2) (Fin 2) Int` is exactly
$M_2(\mathbb{Z})$, already a (noncommutative) `Ring` instance. There's no `Mat2`/
`Mat2.ext`/`add4_reorder` needed, and [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) works directly here (unlike
`Mat2`) because `Matrix` over `Int` already has `DecidableEq`:

```lean
example : Ring (Matrix (Fin 2) (Fin 2) Int) := inferInstance

def X' : Matrix (Fin 2) (Fin 2) Int := !![1, 1; 0, 1]
def Y' : Matrix (Fin 2) (Fin 2) Int := !![1, 0; 1, 1]

example : X' * Y' ≠ Y' * X' := by decide
```

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
    -- associativity, entrywise. `Mat2.ext` (the extensionality lemma
    -- defined above: two Mat2's are equal iff all four fields match) lets
    -- us split the single Mat2 equality into four Int equalities.
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
```

`mat2Group` verifies that $(M_2(\mathbb{Z}), +)$ is a group: every axiom
(`assoc`, `id_left`, `id_right`, `inv_left`, `inv_right`) is checked
entrywise, using `Mat2.ext` to split the single `Mat2` equality into four
`Int` equalities, each of which is then a direct citation of the matching
`Int` addition lemma.

```lean
def mat2CommGroup : CommGroup Mat2 where
  toGroup := mat2Group
  comm := by
    intro X Y
    apply Mat2.ext <;> exact Int.add_comm _ _
```

`mat2CommGroup` upgrades `mat2Group` to an abelian group by supplying
commutativity, again entrywise via `Mat2.ext` and `Int.add_comm`.

```lean
-- A reusable shuffle: rearranges (a+b)+(c+d) into (a+c)+(b+d) — exactly
-- what's needed whenever a "product of sums" expands into four cross
-- terms that must be regrouped to match the other side.
theorem add4_reorder (a b c d : Int) : a + b + (c + d) = a + c + (b + d) := by
  rw [Int.add_assoc a b (c + d)]
  rw [show b + (c + d) = c + (b + d) from by
    rw [← Int.add_assoc, Int.add_comm b c, Int.add_assoc]]
  rw [← Int.add_assoc a c (b + d)]

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
    -- four times per entry, not a single lemma call. Each entry equation
    -- unfolds (via `Int.add_mul`/`Int.mul_add`/`Int.mul_assoc`) to two
    -- sums of the same four products in a different order; `add4_reorder`
    -- is exactly the regrouping needed to match them up.
    apply Mat2.ext
    · show (X.a11 * Y.a11 + X.a12 * Y.a21) * Z.a11 + (X.a11 * Y.a12 + X.a12 * Y.a22) * Z.a21
          = X.a11 * (Y.a11 * Z.a11 + Y.a12 * Z.a21) + X.a12 * (Y.a21 * Z.a11 + Y.a22 * Z.a21)
      rw [Int.add_mul, Int.add_mul, Int.mul_add, Int.mul_add,
          Int.mul_assoc, Int.mul_assoc, Int.mul_assoc, Int.mul_assoc,
          add4_reorder]
    · show (X.a11 * Y.a11 + X.a12 * Y.a21) * Z.a12 + (X.a11 * Y.a12 + X.a12 * Y.a22) * Z.a22
          = X.a11 * (Y.a11 * Z.a12 + Y.a12 * Z.a22) + X.a12 * (Y.a21 * Z.a12 + Y.a22 * Z.a22)
      rw [Int.add_mul, Int.add_mul, Int.mul_add, Int.mul_add,
          Int.mul_assoc, Int.mul_assoc, Int.mul_assoc, Int.mul_assoc,
          add4_reorder]
    · show (X.a21 * Y.a11 + X.a22 * Y.a21) * Z.a11 + (X.a21 * Y.a12 + X.a22 * Y.a22) * Z.a21
          = X.a21 * (Y.a11 * Z.a11 + Y.a12 * Z.a21) + X.a22 * (Y.a21 * Z.a11 + Y.a22 * Z.a21)
      rw [Int.add_mul, Int.add_mul, Int.mul_add, Int.mul_add,
          Int.mul_assoc, Int.mul_assoc, Int.mul_assoc, Int.mul_assoc,
          add4_reorder]
    · show (X.a21 * Y.a11 + X.a22 * Y.a21) * Z.a12 + (X.a21 * Y.a12 + X.a22 * Y.a22) * Z.a22
          = X.a21 * (Y.a11 * Z.a12 + Y.a12 * Z.a22) + X.a22 * (Y.a21 * Z.a12 + Y.a22 * Z.a22)
      rw [Int.add_mul, Int.add_mul, Int.mul_add, Int.mul_add,
          Int.mul_assoc, Int.mul_assoc, Int.mul_assoc, Int.mul_assoc,
          add4_reorder]
  one_mul := by
    intro X
    apply Mat2.ext
    · show 1 * X.a11 + 0 * X.a21 = X.a11
      rw [Int.one_mul, Int.zero_mul, Int.add_zero]
    · show 1 * X.a12 + 0 * X.a22 = X.a12
      rw [Int.one_mul, Int.zero_mul, Int.add_zero]
    · show 0 * X.a11 + 1 * X.a21 = X.a21
      rw [Int.zero_mul, Int.one_mul, Int.zero_add]
    · show 0 * X.a12 + 1 * X.a22 = X.a22
      rw [Int.zero_mul, Int.one_mul, Int.zero_add]
  mul_one := by
    intro X
    apply Mat2.ext
    · show X.a11 * 1 + X.a12 * 0 = X.a11
      rw [Int.mul_one, Int.mul_zero, Int.add_zero]
    · show X.a11 * 0 + X.a12 * 1 = X.a12
      rw [Int.mul_zero, Int.mul_one, Int.zero_add]
    · show X.a21 * 1 + X.a22 * 0 = X.a21
      rw [Int.mul_one, Int.mul_zero, Int.add_zero]
    · show X.a21 * 0 + X.a22 * 1 = X.a22
      rw [Int.mul_zero, Int.mul_one, Int.zero_add]
  left_distrib := by
    intro X Y Z
    apply Mat2.ext
    · show X.a11 * (Y.a11 + Z.a11) + X.a12 * (Y.a21 + Z.a21)
          = (X.a11 * Y.a11 + X.a12 * Y.a21) + (X.a11 * Z.a11 + X.a12 * Z.a21)
      rw [Int.mul_add, Int.mul_add, add4_reorder]
    · show X.a11 * (Y.a12 + Z.a12) + X.a12 * (Y.a22 + Z.a22)
          = (X.a11 * Y.a12 + X.a12 * Y.a22) + (X.a11 * Z.a12 + X.a12 * Z.a22)
      rw [Int.mul_add, Int.mul_add, add4_reorder]
    · show X.a21 * (Y.a11 + Z.a11) + X.a22 * (Y.a21 + Z.a21)
          = (X.a21 * Y.a11 + X.a22 * Y.a21) + (X.a21 * Z.a11 + X.a22 * Z.a21)
      rw [Int.mul_add, Int.mul_add, add4_reorder]
    · show X.a21 * (Y.a12 + Z.a12) + X.a22 * (Y.a22 + Z.a22)
          = (X.a21 * Y.a12 + X.a22 * Y.a22) + (X.a21 * Z.a12 + X.a22 * Z.a22)
      rw [Int.mul_add, Int.mul_add, add4_reorder]
  right_distrib := by
    intro X Y Z
    apply Mat2.ext
    · show (X.a11 + Y.a11) * Z.a11 + (X.a12 + Y.a12) * Z.a21
          = (X.a11 * Z.a11 + X.a12 * Z.a21) + (Y.a11 * Z.a11 + Y.a12 * Z.a21)
      rw [Int.add_mul, Int.add_mul, add4_reorder]
    · show (X.a11 + Y.a11) * Z.a12 + (X.a12 + Y.a12) * Z.a22
          = (X.a11 * Z.a12 + X.a12 * Z.a22) + (Y.a11 * Z.a12 + Y.a12 * Z.a22)
      rw [Int.add_mul, Int.add_mul, add4_reorder]
    · show (X.a21 + Y.a21) * Z.a11 + (X.a22 + Y.a22) * Z.a21
          = (X.a21 * Z.a11 + X.a22 * Z.a21) + (Y.a21 * Z.a11 + Y.a22 * Z.a21)
      rw [Int.add_mul, Int.add_mul, add4_reorder]
    · show (X.a21 + Y.a21) * Z.a12 + (X.a22 + Y.a22) * Z.a22
          = (X.a21 * Z.a12 + X.a22 * Z.a22) + (Y.a21 * Z.a12 + Y.a22 * Z.a22)
      rw [Int.add_mul, Int.add_mul, add4_reorder]
```

Two points are worth pulling out:

1. **Every proof obligation here is spelled out explicitly, with no automation**
   — matching the rest of the book, and unlike an earlier draft of this
   section, which reached for Mathlib's `ring` tactic (a decision procedure
   for commutative-ring identities). Since this book never imports
   Mathlib, `ring` isn't actually available. Each entry equation is instead
   unfolded by hand through `Int.add_mul`/`Int.mul_add`/`Int.mul_assoc` down to
   a sum of the same four cross terms in a different order, and
   `add4_reorder` (proved once, above, and reused twelve times) supplies
   exactly the regrouping needed to match them. The `Ring Mat2` bundle
   itself is still noncommutative — nothing here is deciding *that* for
   you. You supplied `mul := Mat2.mul`, and the `mul_comm`-shaped fact is
   simply absent from `Ring`'s fields, exactly as Chapter 8's exercise on
   `left_distrib`/`right_distrib` anticipated.
2. **This is the general pattern for "ring of $n\times n$ matrices over a
   commutative ring $S$":** the entries live in $S$, every `Ring Mat2`
   proof obligation reduces (through distributivity/associativity in $S$,
   applied a bounded number of times depending on $n$) to a polynomial
   identity purely in $S$, and $\text{Mat}_n(S)$ itself is noncommutative as
   soon as $n \geq 2$, regardless of whether $S$ is commutative. Matrix
   rings are the standard first example that any general ring theory
   (Chapter 9's theorems, Mathlib's `Ring` hierarchy) has to handle
   *without* assuming commutativity, which is exactly why `Ring` doesn't
   bake in `mul_comm`.

**Mathematical reading.** `mat2Ring` is the ring $M_2(\mathbb{Z})$ assembled
formally: `mat2Group`/`mat2CommGroup` verify that $(M_2(\mathbb{Z}), +)$ is
an abelian group (all axioms hold *entrywise*, which is what `Mat2.ext`
followed by the $\mathbb{Z}$-lemma expresses — $M_2(\mathbb{Z}) \cong
\mathbb{Z}^4$ as additive groups), and `mat2Ring` supplies the monoid
$(M_2(\mathbb{Z}), \times, I)$ with distributivity. Associativity of $\times$
is the one substantial fact: $((XY)Z)_{i\ell} = \sum_{j,k} X_{ij}Y_{jk}Z_{k\ell}
= (X(YZ))_{i\ell}$, whose per-entry form is a polynomial identity over the
commutative ring $\mathbb{Z}$, so `ring` can close it. The construction
generalizes exactly the same way to $M_n(S)$ for any commutative ring $S$: entrywise
reduction turns each ring axiom into an $S$-polynomial identity, and
$M_n(S)$ is noncommutative for $n \ge 2$.

**Mathlib equivalent, continued.** Where the book spends most of this
section deriving `mul_assoc` for `Mat2` by hand (the `add4_reorder` helper,
reused twelve times across all five axioms), Mathlib already proves
associativity of matrix multiplication generically. It's simply
`mul_assoc` again, the same lemma name as every other ring in this
chapter's Mathlib boxes:

```lean
example (A B C : Matrix (Fin 2) (Fin 2) Int) : (A * B) * C = A * (B * C) :=
  mul_assoc A B C
```

And where the book's `mat2Ring` needs a custom `Int`-arithmetic rewrite
chain for each of `mul_assoc`/`one_mul`/`mul_one`/`left_distrib`/
`right_distrib`, Mathlib has an automated decision procedure for exactly
this class of goal, [`noncomm_ring`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) — the noncommutative-ring counterpart
of the `ring` tactic that the book's own note above says isn't available
without Mathlib:

```lean
example (A B C : Matrix (Fin 2) (Fin 2) Int) :
    A * (B + C) = A * B + A * C := by noncomm_ring
```

---

[← Accessing nested fields](06-accessing-fields.md) | [Index](00-index.md) | [Next: Exercises →](08-exercises.md)
