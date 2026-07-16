## Suggested next projects

[← Moving to Mathlib](02-moving-to-mathlib.md) | [Index](00-index.md) | [Next: Solutions →](04-solutions.md)

---

1. Redo `Group`/`Ring` from this book as Lean **type classes**
   (`class Group (G : Type) extends ...`) instead of plain `structure`s,
   and notice how theorem statements get shorter once `*`, `⁻¹`, `1` are
   available as notation.
2. Finish the path-algebra construction sketched in Chapter 11's Exercise 3:
   formal $k$-linear combinations of paths, with multiplication by
   concatenation (and $0$ when endpoints do not match) — observe that this is
   precisely "the free `Module` over $k$ on the set of paths," tying
   Chapter 10 and Chapter 11 together.
3. Prove that a quiver with no oriented cycles has a *finite-dimensional*
   path algebra (one polynomial-flavored way to make this precise: bound
   path length by the number of vertices) — "finite-dimensional" here means
   exactly Chapter 10's `Module` notion of a finite spanning/basis set.
4. Once the type-class style is familiar, explore Mathlib's `CategoryTheory.Quiver` and compare
   its definitions line-by-line against this book's `Quiver`/`Path`.
5. Redo `Module`'s "path algebra representations are modules over $kQ$"
   remark (end of Chapter 10) concretely: build the path algebra $kQ$ for
   the example quiver, then a small representation of it, as a
   `Module (PathAlgebraElem ...)`.

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

- Alonzo Church, *[The Calculi of Lambda-Conversion](https://archive.org/details/AnnalsOfMathematicalStudies6ChurchAlonzoTheCalculiOfLambdaConversionPrincetonUniversityPress1941)*, Princeton University Press, 1941 — the original source of this encoding.
- Benjamin C. Pierce, *[Types and Programming Languages](https://www.cis.upenn.edu/~bcpierce/tapl/)*, MIT Press, 2002, §5.2 — a worked, step-by-step derivation of Church booleans and numerals, including `succ`/`plus`, matching the presentation above.
- Raúl Rojas, ["A Tutorial Introduction to the Lambda Calculus"](https://arxiv.org/abs/1503.09060), 2015 — a freely available, worked-example-heavy walkthrough of the same encodings, with more reduction sequences spelled out in full.

---

[← Moving to Mathlib](02-moving-to-mathlib.md) | [Index](00-index.md) | [Next: Solutions →](04-solutions.md)
