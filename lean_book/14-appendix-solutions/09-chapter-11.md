## Chapter 11: Quivers and path algebras

[← Chapter 10](08-chapter-10.md) | [Index](00-index.md)

---

**1. Adding a cycle**

```lean
inductive CyclicArrow where
  | alpha : CyclicArrow   -- 0 → 1
  | beta : CyclicArrow     -- 1 → 2
  | gamma : CyclicArrow    -- 2 → 0

def cyclicQuiver : Quiver (Fin 3) CyclicArrow where
  source := fun a => match a with
    | CyclicArrow.alpha => 0
    | CyclicArrow.beta => 1
    | CyclicArrow.gamma => 2
  target := fun a => match a with
    | CyclicArrow.alpha => 1
    | CyclicArrow.beta => 2
    | CyclicArrow.gamma => 0

def cPathAlpha : Path cyclicQuiver 0 1 :=
  Path.cons CyclicArrow.alpha rfl rfl (Path.nil 0)

def cPathBetaAlpha : Path cyclicQuiver 0 2 :=
  Path.cons CyclicArrow.beta rfl rfl cPathAlpha

def cPathGammaBetaAlpha : Path cyclicQuiver 0 0 :=
  Path.cons CyclicArrow.gamma rfl rfl cPathBetaAlpha
```

Each `rfl` again discharges a source/target proof obligation that reduces
definitionally from the `match` in `cyclicQuiver`. Note
`cPathGammaBetaAlpha` is a nontrivial *loop* at vertex `0` — the path
algebra of a quiver with cycles has elements of arbitrarily high "length,"
which is exactly why such algebras are typically infinite-dimensional
unless one imposes relations (an "admissible ideal") on the path algebra.

**2. `theorem append_nil_left`**

```lean
theorem append_nil_left {V A : Type} {Q : Quiver V A} {u v : V} (p : Path Q u v) :
    Path.append (Path.nil u) p = p := by
  induction p with
  | nil =>
    -- Goal: Path.append (Path.nil u) (Path.nil u) = Path.nil u
    -- (`nil`'s case binds no fresh variable here — the vertex is already
    -- fixed by p's own type — so there is nothing to name.)
    -- Path.append unfolds on its second argument being `nil`, giving
    -- `Path.nil u` on the nose.
    rfl
  | cons a h h' q' ih =>
    -- ih : Path.append (Path.nil u) q' = q'
    -- Goal: Path.append (Path.nil u) (Path.cons a h h' q') = Path.cons a h h' q'
    show Path.cons a h h' (Path.append (Path.nil u) q') = Path.cons a h h' q'
    rw [ih]
```

This mirrors `Path.append`'s own recursion, case for case: `Path.append`
was *defined* by matching on its second argument, so `induction p` (which
case-splits on exactly that argument, generating the matching induction
hypothesis `ih` in the `cons` case) unfolds the definition directly. In the
`nil` case both sides are definitionally `Path.nil u`. In the `cons` case,
unfolding `Path.append`'s defining equation turns the goal into
`Path.cons a h h' (Path.append (Path.nil u) q') = Path.cons a h h' q'`
(the `show` line makes this explicit rather than leaving it to
elaboration), and `rw [ih]` finishes by the induction hypothesis.

**3. Sketch of `PathAlgebra`**

```lean
-- A k-linear combination of paths from u to v, as a finitely-supported
-- function from paths to coefficients. `Finsupp`-style support tracking is
-- the honest way to do this; a simplified sketch:
structure PathAlgebraElem (V A : Type) (Q : Quiver V A) (k : Type) where
  -- coeff p = the coefficient of path p, for finitely many nonzero p
  coeff : {u v : V} → Path Q u v → k
  -- (a finiteness/support condition would be required here in a full
  -- development, e.g. via Mathlib's `Finsupp`)

-- To satisfy `Ring` (Chapter 8), `PathAlgebraElem` would need:
--   addGrp : CommGroup (PathAlgebraElem V A Q k)   -- pointwise addition of coefficients
--   mul    : concatenate paths, multiplying and summing coefficients over
--            all ways two paths compose (zero when endpoints don't match)
--   one    : the sum, over all vertices v, of 1 · (trivial path at v)
--            (an idempotent identity, since Q may have infinitely many
--            vertices this "one" is only literally an element when Q0 is
--            finite — for infinite Q the path algebra is typically only
--            a "ring with local units," a subtlety Mathlib's category-
--            theoretic treatment handles more gracefully than a bare Ring)
```

The honest finiteness/support bookkeeping (which paths have nonzero
coefficient) is exactly what makes a full formalization a genuine project
rather than a one-page exercise — this sketch identifies the three `Ring`
fields that need it (`addGrp`, `mul`, `one`) and why `one` is the subtle
one when $Q_0$ is infinite.

---

[← Chapter 10](08-chapter-10.md) | [Index](00-index.md) | [Table of contents](../README.md)
