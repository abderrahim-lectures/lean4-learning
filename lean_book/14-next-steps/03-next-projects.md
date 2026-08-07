## Suggested next projects

[← Moving to Mathlib](02-moving-to-mathlib.md) | [Index](00-index.md) | [Next: Solutions →](04-solutions.md)

---

Each project below follows the same shape as the checkpoint projects after
Chapters 6 and 12: learning objectives, prerequisites, milestones, a
concrete deliverable, and a self-verification step. Unlike the checkpoint
projects, none of these are worked solutions. They are genuinely open,
for the reader to carry out, with no appendix entry.

### 1. Redo `Group`/`Ring` as type classes

**Learning objectives.** Feel directly what Chapter 14, Section 2 only described,
the ergonomic difference between the plain `structure`s of this book and
the `class`-based hierarchy of Mathlib, and the typeclass/instance search
mechanism of Lean.

**Prerequisites.** Chapter 6, Section 1 (`structure` vs `class`), Chapter 7
(`Group`), Chapter 9 (`Ring`). `MyGroup` in the Chapter 6 appendix (exercise
2) is a smaller version of the first milestone below and a good warm-up.

**Milestones.**

1. Declare `class Group (G : Type) where` with the same five fields the
   `Group` structure of this book has, then `class Ring (R : Type) where`
   similarly (deciding whether `Ring` extends an `AddCommGroup`/`CommGroup`
   class, as Mathlib does, or still nests one as a field).
2. Register at least two instances per class (e.g. `Int` and `Bool`,
   reusing the proofs of `intGroup`/`boolXorGroup` from Chapters 7–9).
3. Redo one theorem generically, `id_unique` (Chapter 8) is the smallest,
   against the `[Group G]` assumption instead of a `Grp : Group G`
   argument, and notice which parts of the statement got shorter.

**Deliverable.** `class Group`, `class Ring`, at least two instances of
each, and one theorem restated in the type-class style.

**Self-verification.** The restated theorem should type-check with no
explicit `Grp`/`Rg` argument threaded through. `#check` its statement and
confirm Lean finds the right instance automatically at each of the two
concrete types with no extra proof supplied at the call site.

### 2. Finish the path-algebra construction

**Learning objectives.** Finitely-supported functions as the underlying
data of a `Ring`, and connecting the `Module` vocabulary of Chapter 11 forward
to `Quiver`/`Path` of Chapter 12.

**Prerequisites.** Chapter 9 (`Ring`), Chapter 11 (`Module`), Chapter 12
(`Path`), the checkpoint project of Chapter 12 (`Path.length`) as a warm-up, and
the sketch of `PathAlgebraElem` in Exercise 3 of Chapter 12.

**Milestones.**

1. Restrict first to a quiver with finitely many paths total. The
   example quiver from Chapter 12, Section 3 has exactly six (`e_0, e_1, e_2,
   alpha, beta, beta∘alpha`), so "finitely supported" can start as a
   plain function on a finite index rather than needing the `Finsupp` of
   Mathlib.
2. Define pointwise addition on this finite carrier and prove it forms a
   `CommGroup` (Chapter 9, Section 2).
3. Define multiplication by path composition, `0` on any pair whose
   endpoints do not match (as the chapter text describes), and prove the
   monoid laws (`mul_assoc`/`one_mul`/`mul_one`) using the sum of trivial
   paths as `one`.
4. Assemble `Ring (PathAlgebraElem exampleQuiver k)` for a small, fully
   concrete `k` (`fin3Ring`, `Fin 3` from Chapter 9, Section 5, is a good first
   choice, since `decide` can then check the ring axioms outright).

**Deliverable.** A `Ring` instance on a finite path algebra for a
concretely chosen `k`.

**Self-verification.** `#eval` the product of two hand-chosen path-algebra
elements and check it against a hand computation of the same product; if
`k` is fully decidable (as `Fin 3` is), the ring axioms can additionally be
discharged by `decide` rather than by hand, the same shortcut taken by
`fin3Ring` in Chapter 9, Section 5.

### 3. Acyclic quivers have finite-dimensional path algebras

**Learning objectives.** Combinatorial reasoning about `Path.length`
(the checkpoint project of Chapter 12), and connecting it to the `Module`
notion of a finite spanning set from Chapter 11.

**Prerequisites.** Chapter 11 (`Module`), Chapter 12, the `Path.length`
checkpoint project (a prerequisite in substance, not just in reading
order: this project is exactly the "harder" continuation its own
self-verification note gestures at).

**Milestones.**

1. Define what "acyclic" means for a `Quiver`: no nontrivial path from any
   vertex back to itself (`∀ v, ∀ p : Path Q v v, <p is the trivial path>`
   is one natural phrasing).
2. Prove that in an acyclic quiver with a finite vertex type, the
   `Path.length` of every path is bounded by the number of vertices, the idea being
   that a path visiting more vertices than exist must repeat one, forcing
   a nontrivial cycle.
3. Instantiate the bound on `exampleQuiver` (acyclic, from Chapter 12, Section 3)
   and on `cyclicQuiver` (Chapter 12 Exercise 1, which has a cycle) to see
   the argument apply in the first case and correctly fail to apply in the
   second.
4. Conclude finite-dimensionality: an acyclic quiver on finitely many
   vertices has only finitely many paths (bounded length, finitely many
   arrows to choose at each step), hence the path algebra of Project 2 is a
   finite-dimensional `Module` over `k` in the sense of Chapter 11.

**Deliverable.** A stated and proved length bound for acyclic quivers,
checked against both example quivers.

**Self-verification.** `#eval` the length of every path in `exampleQuiver` and
confirm none exceeds the vertex count (`3`); separately, in `cyclicQuiver`
(Chapter 12 appendix, Exercise 1), build a path that goes around the cycle
`gamma ∘ beta ∘ alpha` twice (by `Path.append`ing `cPathGammaBetaAlpha` to
itself), confirm its length exceeds `3`, and confirm the proof of the bound
genuinely does not apply there, as it must not for a cyclic quiver.

### 4. Compare against `CategoryTheory.Quiver` of Mathlib

**Learning objectives.** Reading real Mathlib source, and recognizing the
own constructions of this book inside a more general, abstract presentation.

**Prerequisites.** Chapter 12 (the `Quiver`/`Path` of this book), Project 1
above (comfort with the type-class style Mathlib uses throughout).

**Milestones.**

1. Read the `Quiver` class of `Mathlib.Combinatorics.Quiver.Basic` (already
   introduced in the "Mathlib equivalent" box of Chapter 12, Section 3) and
   the extension of it by `Mathlib.CategoryTheory.Quiver` with identities and
   composition, comparing field-for-field against the plain
   `Quiver`/`Path` of this book.
2. Find `Prefunctor` in Mathlib (a quiver homomorphism) and, separately,
   define a `structure QuiverHom` by hand for two of the own quivers of this book
   (`exampleQuiver`, `cyclicQuiver` from the exercises of Chapter 12),
   mapping vertices to vertices and arrows to paths.
3. Write the identity `QuiverHom` and composition of two `QuiverHom`s,
   noticing the parallel to the `LinearMap` exercises of Chapter 11 (identity
   and composition being exactly what make a class of structures into a
   category, Chapter 11 Exercise 2).

**Deliverable.** A hand-written `QuiverHom` between two of the own quivers of
this book, with its `Prefunctor` counterpart in Mathlib identified by name.

**Self-verification.** `#check @Prefunctor` and compare its fields,
one-by-one in a comment, against the fields of `QuiverHom` itself.

### 5. A concrete `kQ`-module

**Learning objectives.** Turn the closing remark of Chapter 12, Section 5,
"representations of $Q$ are exactly $kQ$-modules," into an actual, if
small, worked example.

**Prerequisites.** Chapter 11 (`Module`), Chapter 12, and Project 2 above
(at least its first two milestones: a concrete, finite path algebra to be
a module *over*).

**Milestones.**

1. Using the example quiver and the finite path algebra of Project 2, assign a
   small carrier module to each vertex (e.g. `Fin 3` under the
   `fin3Ring`-flavored addition of Chapter 9, Section 5) and a linear map to each arrow, exactly
   the data of a quiver representation (the remark of Chapter 12, Section 5, made
   concrete).
2. Package this data as a genuine `Module (PathAlgebraElem exampleQuiver
   k) (SomeCarrier)` instance (the `Module` structure of Chapter 11, Section 2), using
   the `Ring` of Project 2 as the scalar ring `Rg`.
3. Confirm the module axioms hold by checking that the scalar action of a
   path-algebra element on a carrier element agrees with manually
   composing the linear maps assigned to the arrows of that path.

**Deliverable.** One concrete `Module` instance realizing a representation
of the example quiver.

**Self-verification.** `#eval` the action of a length-2 path-algebra
element (e.g. the class of $\beta\alpha$) on a chosen carrier element, and
confirm it matches applying the two assigned linear maps of the arrows in
sequence by hand.

### Aside: Church encodings — data from nothing but functions

Everything in this book is built from the `inductive` mechanism of Lean:
`Nat`, `Bool`, `Path`, every `structure`. It is worth knowing, purely as a
curiosity, that none of that machinery was ever strictly necessary. The
untyped λ-calculus, variables, `fun x => t`-style abstraction, and
application, nothing else, is already expressive enough to build
booleans, numbers, and arbitrary data by encoding them as functions.

**Church booleans.** Define
$$
\mathrm{true} := \lambda x.\, \lambda y.\, x
\qquad
\mathrm{false} := \lambda x.\, \lambda y.\, y
$$
A boolean, in this encoding, *is* a choice function. To use one, apply it
to the two branches of an if-expression.
$$
\mathrm{if}\; b \;\mathrm{then}\; t \;\mathrm{else}\; e \;:=\; b\, t\, e
$$
Check: $\mathrm{true}\, t\, e = (\lambda x.\lambda y. x)\, t\, e
\longrightarrow_\beta t$ (discarding $e$), and symmetrically
$\mathrm{false}\, t\, e \longrightarrow_\beta e$. "If-then-else" is not a
primitive at all. It is just *application*, once booleans are represented
this way. The actual `Bool` of Lean (an `inductive` with two constructors) is a
*convenience*, not a necessity. The calculus itself never needed a
booleans primitive to express conditional behavior.

**Church numerals.** Represent the natural number $n$ as "apply a function
$n$ times."
$$
\underline{0} := \lambda f.\, \lambda x.\, x
\qquad
\underline{1} := \lambda f.\, \lambda x.\, f\, x
\qquad
\underline{2} := \lambda f.\, \lambda x.\, f\,(f\, x)
\qquad
\underline{n} := \lambda f.\, \lambda x.\, f^n\, x
$$
Compare directly to the own Peano definition of `Nat`,
$\mathtt{Nat} ::= \mathtt{zero} \mid \mathtt{succ}(n)$ (Chapter 1). A
Church numeral $\underline{n}$ *is* "apply $\mathtt{succ}$, $n$ times, to
$\mathtt{zero}$," the same inductive shape, represented not as data but
as a higher-order function that knows how to iterate.

- **Successor:** $\mathrm{succ} := \lambda n.\, \lambda f.\, \lambda x.\,
  f\,(n\, f\, x)$, meaning "apply $f$ one more time than $n$ does."
- **Addition:** $\mathrm{plus} := \lambda m.\lambda n.\lambda f.\lambda x.\,
  m\, f\,(n\, f\, x)$, meaning "apply $f$, $m$ more times, starting from where $n$
  has already applied $f$, $n$ times." This is the same recursive shape that makes
  `Nat.add` recurse on its second argument (Chapter 5).
- **Multiplication** is even more striking: $\mathrm{mult} := \lambda m.
  \lambda n.\lambda f.\, m\,(n\, f)$, meaning "apply *'apply $f$, $n$ times'*, $m$
  times." Multiplication is literally function composition, iterated.

None of this is meant to suggest that one should ever program this way. It
shows, concretely, that a system with only variables, abstraction, and
application already has the expressive power to build booleans, naturals,
and (by pairing constructions along the same lines) arbitrary tree-shaped
data, before any type system or `inductive` keyword enters the picture.
The actual `Bool` and `Nat` of Lean use `inductive` instead, for efficiency and
because pattern-matching (`match`, [`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)) is far more convenient to
write and reason about than repeated application. The *expressiveness*
was never in question. If this is interesting, a next step is to encode
pairs the same way ($\mathrm{pair} := \lambda a.\lambda b.\lambda f.\,
f\, a\, b$) and check by hand that projecting back out a component
β-reduces correctly.

#### References

Full citations in the [Bibliography](../bibliography.md).

- Church ([Church1941]), §8, is the original source of this encoding, verified present. The symbol index confirms §8 formally defines "1, 2, 3, S" (the positive integers and successor function as iterating functions), matching the later gloss of Ch. 20 §19, "the positive integers... are certain functions of functions, namely the finite powers of a function in the sense of iteration."
- Pierce ([Pierce2002]), §5.2, gives a worked, step-by-step derivation of Church booleans and numerals, including `succ`/`plus`, matching the presentation above.
- Rojas ([Rojas2015]) offers a freely available, worked-example-heavy walkthrough of the same encodings, with more reduction sequences spelled out in full.

[Church1941]: ../bibliography.md#church1941
[Pierce2002]: ../bibliography.md#pierce2002
[Rojas2015]: ../bibliography.md#rojas2015

---

[← Moving to Mathlib](02-moving-to-mathlib.md) | [Index](00-index.md) | [Next: Solutions →](04-solutions.md)
