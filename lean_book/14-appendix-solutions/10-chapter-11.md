## Chapter 11: Quivers and path algebras

[← Chapter 10](09-chapter-10.md) | [Index](00-index.md)

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

Each [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) again discharges a source/target proof obligation that reduces,
by definition, from the `match` in `cyclicQuiver`. Observe that
`cPathGammaBetaAlpha` is a nontrivial loop at vertex `0`. The path
algebra of a quiver with cycles has elements of arbitrarily high "length,"
which is exactly why such algebras are usually infinite-dimensional unless
relations (an "admissible ideal") are imposed on the path algebra.

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

This is exactly what the editor shows in the `cons` case: the Lean
Infoview lists every hypothesis the pattern match introduces —
`Q : Quiver V A`, `h : Q.source a = v`, `h' : Q.target a = wt`,
`q' : Path Q u vt`, and the induction hypothesis
`ih : (Path.nil u).append q' = q'` — above the line, with the goal
`(Path.nil u).append (Path.cons a h h' q') = Path.cons a h h' q'` below
it:

![The Lean Infoview panel in VS Code, showing the tactic state for the `cons` case of `append_nil_left`'s induction: hypotheses `V A : Type`, `Q : Quiver V A`, `u v vt wt : V`, `a : A`, `h : Q.source a = v`, `h' : Q.target a = wt`, `q' : Path Q u vt`, `ih : (Path.nil u).append q' = q'`, and the goal `(Path.nil u).append (Path.cons a h h' q') = Path.cons a h h' q'`.](../11-path-algebras/images/append-nil-left-infoview.png)

This mirrors `Path.append`'s own recursion, case for case. `Path.append`
was defined by matching on its second argument, so `induction p` (which
splits into cases on exactly that argument, generating the matching
induction hypothesis `ih` in the `cons` case) unfolds the definition
directly. In the `nil` case, both sides are `Path.nil u` by definition. In
the `cons` case, unfolding `Path.append`'s defining equation turns the goal
into `Path.cons a h h' (Path.append (Path.nil u) q') = Path.cons a h h' q'`
(the [`show`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) line makes this explicit rather than leaving it to
elaboration), and `rw [ih]` completes the proof using the induction
hypothesis.

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

The real finiteness/support bookkeeping (tracking which paths have nonzero
coefficient) is exactly what makes a full formalization a genuine project
rather than a one-page exercise. This sketch identifies the three `Ring`
fields that require it (`addGrp`, `mul`, `one`), and shows why `one` is the
subtle one when $Q_0$ is infinite.

**Checkpoint project: path length, and composition respects it**

```lean
def Path.length {V A : Type} {Q : Quiver V A} : {u v : V} → Path Q u v → Nat
  | _, _, Path.nil _ => 0
  | _, _, Path.cons _ _ _ p => p.length + 1

theorem Path.append_length {V A : Type} {Q : Quiver V A} {u v w : V}
    (p : Path Q u v) (q : Path Q v w) :
    (Path.append p q).length = p.length + q.length := by
  induction q with
  | nil =>
    simp only [Path.append, Path.length]
    rw [Nat.add_zero]
  | cons a h h' q' ih =>
    simp only [Path.append, Path.length]
    rw [ih, Nat.add_assoc]

example : (Path.append pathAlpha pathBetaOnly).length =
    pathAlpha.length + pathBetaOnly.length :=
  Path.append_length pathAlpha pathBetaOnly

#eval pathAlpha.length                                    -- 1
#eval pathBetaAlpha.length                                -- 2
#eval (Path.append pathAlpha pathBetaOnly).length          -- 2
```

`Path.length` recurses on the same two constructors as `Path.append`
itself (§4–§5): `nil` contributes `0`, and each `cons` adds one to the
length of the shorter path it extends. The proof of `append_length`
mirrors `Path.append`'s own recursion case for case, exactly as the
project asked, but with one genuine surprise if `rfl` is tried first in
either case: it fails. `Path` is *indexed* by both endpoints, and Lean
compiles a match on an indexed family like this so that its defining
equations reduce only through their auto-generated equation lemmas, not
through plain iota-reduction, once an abstract path (`p`, `q'`) is
involved — concrete, fully closed paths like `pathAlpha` still reduce
fine under `#eval`, which is why those three checks above work directly,
but the *general*, universally-quantified theorem does not close by
`rfl`. `simp only [Path.append, Path.length]` names exactly the two
definitions being unfolded and nothing else, so it plays the same explicit
role a `rw` would if these equations were reachable that way — it is not
standing in for an unknown pile of simp lemmas, only for the two named
here. This is the same kind of real, verified obstacle Chapter 6 §4's
`Perm3.ext` ran into with core Lean's lack of a `structure`
extensionality lemma, now met again with indexed recursion instead.

---

[← Chapter 10](09-chapter-10.md) | [Index](00-index.md) | [Table of contents](../README.md)
