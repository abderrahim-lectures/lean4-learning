## Suggested next projects

[← Moving to Mathlib](02-moving-to-mathlib.md) | [Index](00-index.md) | [Next: Solutions →](04-solutions.md)

---

Each project below follows the same shape as the checkpoint projects after
Chapters 5 and 11: learning objectives, prerequisites, milestones, a
concrete deliverable, and a self-verification step. Unlike the checkpoint
projects, none of these are worked solutions — they are genuinely open,
for the reader to carry out, with no appendix entry.

### 1. Redo `Group`/`Ring` as type classes

**Learning objectives.** Feel directly what Chapter 13 §2 only described:
the ergonomic difference between this book's plain `structure`s and
Mathlib's `class`-based hierarchy, and Lean's typeclass/instance search
mechanism.

**Prerequisites.** Chapter 5 §1 (`structure` vs `class`), Chapter 6
(`Group`), Chapter 8 (`Ring`). The Chapter 5 appendix's `MyGroup` (exercise
2) is a smaller version of the first milestone below and a good warm-up.

**Milestones.**

1. Declare `class Group (G : Type) where` with the same five fields this
   book's `Group` structure has, then `class Ring (R : Type) where`
   similarly (deciding whether `Ring` extends an `AddCommGroup`/`CommGroup`
   class, as Mathlib does, or still nests one as a field).
2. Register at least two instances per class (e.g. `Int` and `Bool`,
   reusing `intGroup`/`boolXorGroup`'s proofs from Chapters 6–8).
3. Redo one theorem generically — `id_unique` (Chapter 7) is the smallest
   — against the `[Group G]` assumption instead of a `Grp : Group G`
   argument, and notice which parts of the statement got shorter.

**Deliverable.** `class Group`, `class Ring`, at least two instances of
each, and one theorem restated in the type-class style.

**Self-verification.** The restated theorem should type-check with no
explicit `Grp`/`Rg` argument threaded through — `#check` its statement and
confirm Lean finds the right instance automatically at each of the two
concrete types with no extra proof supplied at the call site.

### 2. Finish the path-algebra construction

**Learning objectives.** Finitely-supported functions as a `Ring`'s
underlying data, and connecting Chapter 10's `Module` vocabulary forward
to Chapter 11's `Quiver`/`Path`.

**Prerequisites.** Chapter 8 (`Ring`), Chapter 10 (`Module`), Chapter 11
(`Path`), Chapter 11's checkpoint project (`Path.length`) as a warm-up, and
Chapter 11's Exercise 3 sketch of `PathAlgebraElem`.

**Milestones.**

1. Restrict first to a quiver with finitely many paths total — the
   example quiver from Chapter 11 §3 has exactly six (`e_0, e_1, e_2,
   alpha, beta, beta∘alpha`) — so "finitely supported" can start as a
   plain function on a finite index rather than needing Mathlib's
   `Finsupp`.
2. Define pointwise addition on this finite carrier and prove it forms a
   `CommGroup` (Chapter 8 §2).
3. Define multiplication by path composition, `0` on any pair whose
   endpoints do not match (as the chapter text describes), and prove the
   monoid laws (`mul_assoc`/`one_mul`/`mul_one`) using the sum of trivial
   paths as `one`.
4. Assemble `Ring (PathAlgebraElem exampleQuiver k)` for a small, fully
   concrete `k` (Chapter 8 §5's `fin3Ring`, `Fin 3`, is a good first
   choice, since `decide` can then check the ring axioms outright).

**Deliverable.** A `Ring` instance on a finite path algebra for a
concretely chosen `k`.

**Self-verification.** `#eval` the product of two hand-chosen path-algebra
elements and check it against a hand computation of the same product; if
`k` is fully decidable (as `Fin 3` is), the ring axioms can additionally be
discharged by `decide` rather than by hand, the same shortcut Chapter 8 §5
took for `fin3Ring`.

### 3. Acyclic quivers have finite-dimensional path algebras

**Learning objectives.** Combinatorial reasoning about `Path.length`
(Chapter 11's checkpoint project), and connecting it to Chapter 10's
`Module` notion of a finite spanning set.

**Prerequisites.** Chapter 10 (`Module`), Chapter 11, the `Path.length`
checkpoint project (a prerequisite in substance, not just in reading
order: this project is exactly the "harder" continuation its own
self-verification note gestures at).

**Milestones.**

1. Define what "acyclic" means for a `Quiver`: no nontrivial path from any
   vertex back to itself (`∀ v, ∀ p : Path Q v v, <p is the trivial path>`
   is one natural phrasing).
2. Prove that in an acyclic quiver with a finite vertex type, every path's
   `Path.length` is bounded by the number of vertices — the idea being
   that a path visiting more vertices than exist must repeat one, forcing
   a nontrivial cycle.
3. Instantiate the bound on `exampleQuiver` (acyclic, from Chapter 11 §3)
   and on `cyclicQuiver` (Chapter 11 Exercise 1, which has a cycle) to see
   the argument apply in the first case and correctly fail to apply in the
   second.
4. Conclude finite-dimensionality: an acyclic quiver on finitely many
   vertices has only finitely many paths (bounded length, finitely many
   arrows to choose at each step), hence Project 2's path algebra is a
   finite-dimensional `Module` over `k` in Chapter 10's sense.

**Deliverable.** A stated and proved length bound for acyclic quivers,
checked against both example quivers.

**Self-verification.** `#eval` every path's length in `exampleQuiver` and
confirm none exceeds the vertex count (`3`); separately, in `cyclicQuiver`
(Chapter 11 appendix, Exercise 1), build a path that goes around the cycle
`gamma ∘ beta ∘ alpha` twice (by `Path.append`ing `cPathGammaBetaAlpha` to
itself), confirm its length exceeds `3`, and confirm the bound's proof
genuinely does not apply there, as it must not for a cyclic quiver.

### 4. Compare against Mathlib's `CategoryTheory.Quiver`

**Learning objectives.** Reading real Mathlib source, and recognizing this
book's own constructions inside a more general, abstract presentation.

**Prerequisites.** Chapter 11 (this book's `Quiver`/`Path`), Project 1
above (comfort with the type-class style Mathlib uses throughout).

**Milestones.**

1. Read `Mathlib.Combinatorics.Quiver.Basic`'s `Quiver` class (already
   introduced in Chapter 11 §1's "Mathlib equivalent" box) and
   `Mathlib.CategoryTheory.Quiver`'s extension of it with identities and
   composition, comparing field-for-field against this book's plain
   `Quiver`/`Path`.
2. Find Mathlib's `Prefunctor` (a quiver homomorphism) and, separately,
   define a `structure QuiverHom` by hand for two of this book's own
   quivers (`exampleQuiver`, `cyclicQuiver` from Chapter 11's exercises),
   mapping vertices to vertices and arrows to paths.
3. Write the identity `QuiverHom` and composition of two `QuiverHom`s,
   noticing the parallel to Chapter 10's `LinearMap` exercises (identity
   and composition being exactly what make a class of structures into a
   category, Chapter 10 Exercise 2).

**Deliverable.** A hand-written `QuiverHom` between two of this book's own
quivers, with its Mathlib `Prefunctor` counterpart identified by name.

**Self-verification.** `#check @Prefunctor` and compare its fields,
one-by-one in a comment, against `QuiverHom`'s own fields.

### 5. A concrete `kQ`-module

**Learning objectives.** Turn Chapter 11 §5's closing remark —
"representations of $Q$ are exactly $kQ$-modules" — into an actual, if
small, worked example.

**Prerequisites.** Chapter 10 (`Module`), Chapter 11, and Project 2 above
(at least its first two milestones: a concrete, finite path algebra to be
a module *over*).

**Milestones.**

1. Using the example quiver and Project 2's finite path algebra, assign a
   small carrier module to each vertex (e.g. `Fin 3` under Chapter 8 §5's
   `fin3Ring`-flavored addition) and a linear map to each arrow, exactly
   the data of a quiver representation (Chapter 11 §5's remark, made
   concrete).
2. Package this data as a genuine `Module (PathAlgebraElem exampleQuiver
   k) (SomeCarrier)` instance (Chapter 10 §2's `Module` structure), using
   Project 2's `Ring` as the scalar ring `Rg`.
3. Confirm the module axioms hold by checking that the scalar action of a
   path-algebra element on a carrier element agrees with manually
   composing the linear maps assigned to that path's arrows.

**Deliverable.** One concrete `Module` instance realizing a representation
of the example quiver.

**Self-verification.** `#eval` the action of a length-2 path-algebra
element (e.g. the class of $\beta\alpha$) on a chosen carrier element, and
confirm it matches applying the two arrows' assigned linear maps in
sequence by hand.

### Aside: Church encodings — data from nothing but functions

Everything in this book is built from Lean's `inductive` mechanism:
`Nat`, `Bool`, `Path`, every `structure`. It is worth knowing, purely as a
curiosity, that none of that machinery was ever strictly necessary. The
untyped λ-calculus — variables, `fun x => t`-style abstraction, and
application, nothing else — is already expressive enough to build
booleans, numbers, and arbitrary data by encoding them as functions.

**Church booleans.** Define
$$
\mathrm{true} := \lambda x.\, \lambda y.\, x
\qquad
\mathrm{false} := \lambda x.\, \lambda y.\, y
$$
A boolean, in this encoding, *is* a choice function — to use one, apply it
to the two branches of an if-expression:
$$
\mathrm{if}\; b \;\mathrm{then}\; t \;\mathrm{else}\; e \;:=\; b\, t\, e
$$
Check: $\mathrm{true}\, t\, e = (\lambda x.\lambda y. x)\, t\, e
\longrightarrow_\beta t$ (discarding $e$), and symmetrically
$\mathrm{false}\, t\, e \longrightarrow_\beta e$. "If-then-else" is not a
primitive at all — it is just *application*, once booleans are represented
this way. Lean's actual `Bool` (an `inductive` with two constructors) is a
*convenience*, not a necessity — the calculus itself never needed a
booleans primitive to express conditional behavior.

**Church numerals.** Represent the natural number $n$ as "apply a function
$n$ times":
$$
\underline{0} := \lambda f.\, \lambda x.\, x
\qquad
\underline{1} := \lambda f.\, \lambda x.\, f\, x
\qquad
\underline{2} := \lambda f.\, \lambda x.\, f\,(f\, x)
\qquad
\underline{n} := \lambda f.\, \lambda x.\, f^n\, x
$$
Compare directly to `Nat`'s own Peano definition
$\mathtt{Nat} ::= \mathtt{zero} \mid \mathtt{succ}(n)$ (Chapter 1): a
Church numeral $\underline{n}$ *is* "apply $\mathtt{succ}$, $n$ times, to
$\mathtt{zero}$" — the same inductive shape, represented not as data but
as a higher-order function that knows how to iterate.

- **Successor:** $\mathrm{succ} := \lambda n.\, \lambda f.\, \lambda x.\,
  f\,(n\, f\, x)$ — "apply $f$ one more time than $n$ does."
- **Addition:** $\mathrm{plus} := \lambda m.\lambda n.\lambda f.\lambda x.\,
  m\, f\,(n\, f\, x)$ — "apply $f$, $m$ times, starting from where $n$
  already applied it $n$ times," the same recursive shape that makes
  `Nat.add` recurse on its second argument (Chapter 4).
- **Multiplication** is even more striking: $\mathrm{mult} := \lambda m.
  \lambda n.\lambda f.\, m\,(n\, f)$ — "apply *'apply $f$, $n$ times'*, $m$
  times." Multiplication is literally function composition, iterated.

None of this is meant to suggest that one should ever program this way. It
shows, concretely, that a system with only variables, abstraction, and
application already has the expressive power to build booleans, naturals,
and (by pairing constructions along the same lines) arbitrary tree-shaped
data — before any type system or `inductive` keyword enters the picture.
Lean's actual `Bool` and `Nat` use `inductive` instead, for efficiency and
because pattern-matching (`match`, [`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)) is far more convenient to
write and reason about than repeated application — the *expressiveness*
was never in question. If this is interesting, a next step is to encode
pairs the same way ($\mathrm{pair} := \lambda a.\lambda b.\lambda f.\,
f\, a\, b$) and check by hand that projecting back out a component
β-reduces correctly.

#### References

Full citations in the [Bibliography](../bibliography.md).

- Church ([Church1941]) — the original source of this encoding.
- Pierce ([Pierce2002]), §5.2 — a worked, step-by-step derivation of Church booleans and numerals, including `succ`/`plus`, matching the presentation above.
- Rojas ([Rojas2015]) — a freely available, worked-example-heavy walkthrough of the same encodings, with more reduction sequences spelled out in full.

[Church1941]: ../bibliography.md#church1941
[Pierce2002]: ../bibliography.md#pierce2002
[Rojas2015]: ../bibliography.md#rojas2015

---

[← Moving to Mathlib](02-moving-to-mathlib.md) | [Index](00-index.md) | [Next: Solutions →](04-solutions.md)
