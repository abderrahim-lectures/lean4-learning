## Path composition

[← Paths as an inductive type](04-paths-as-inductive-type.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

---

Section 4 built individual paths one arrow at a time, via `Path.cons`
extending a shorter path with one new arrow. Two paths already built,
separately, by whatever route, are often exactly what needs to be joined
into a single longer path, rather than rebuilt from scratch arrow by
arrow. That joining operation is **composition**, and, once every pair of
composable paths is given a $k$-linear coefficient, it is also the
multiplication that turns the set of all paths into the path algebra
$kQ$ this chapter has been building toward from the start.

Given a path `p : Path Q u v` and a path `q : Path Q v w`, they can be concatenated
into a path `Path Q u w`, defined by recursion on `q`.

```lean
def Path.append {V A : Type} {Q : Quiver V A} {u v w : V}
    (p : Path Q u v) (q : Path Q v w) : Path Q u w :=
  match q with
  | Path.nil _ => p
  | Path.cons a h h' q' => Path.cons a h h' (Path.append p q')
```

Reading the recursion.

- If `q` is trivial (`Path.nil _`, a path of length zero from `v` to `v`),
  then appending `p` before it just gives back `p` itself (there is nothing
  to append).
- If `q` ends with an arrow `a` (i.e. `q = Path.cons a h h' q'` for some
  shorter path `q'`), then appending `p` before all of `q` is the same as
  appending `p` before the shorter `q'`, and then re-attaching the same
  final arrow `a` on top.

This recursion terminates because each recursive call is on the strictly
shorter path `q'`. This is the same structural recursion principle behind
the `induction` tactic from Chapter 5. A `Path` cannot be printed on its
own (there is no generic way to display the arrows of an arbitrary quiver as
text), so watching this recursion step by step with `dbg_trace` has to
wait until the checkpoint project below, once `Path.length` gives the
result something printable to reduce to.

### A worked instance: rebuilding `pathBetaAlpha` via `append`

The previous section built `pathBetaAlpha : Path exampleQuiver 0 2`
directly, one `Path.cons` at a time. Here it is again, built instead by
*composing* the shorter path `pathAlpha` with a fresh one-arrow path using
`Path.append`. Both constructions produce the exact same path.

```lean
def pathBetaOnly : Path exampleQuiver 1 2 :=
  Path.cons ExampleArrow.beta rfl rfl (Path.nil 1)
```

`pathBetaOnly` is that fresh one-arrow path, a path from `1` to `2`
consisting of just the single arrow `beta`, built on its own rather than
by extending `pathAlpha`.

```lean
def pathBetaAlphaViaAppend : Path exampleQuiver 0 2 :=
  Path.append pathAlpha pathBetaOnly
```

`pathBetaAlphaViaAppend` composes the shorter path `pathAlpha` with
`pathBetaOnly` via `Path.append`, yielding a path from `0` to `2`. This has
the same endpoints as `pathBetaAlpha`, but is assembled by composition
rather than by chaining `Path.cons` calls directly.

```lean
example : pathBetaAlphaViaAppend = pathBetaAlpha := rfl
```

That final `rfl` is not a weak or approximate check. It says the two
constructions are *definitionally* the same term, reducing to an
identical normal form (Chapter 6), not merely "provably equal after some
argument." This is the concrete payoff of the recursive definition of
`Path.append`, composing paths built independently, via arbitrarily different
routes, agrees exactly with building the composite path directly by hand,
because both ultimately unfold to the same sequence of `Path.cons`
applications.

**Mathematical reading.** `Path.append` is **composition in the free
category** $\mathrm{Free}(Q)$, written throughout this section in *path
order*: "$p$ then $q$," matching the argument order of `Path.append p q`.
This is not the function-composition order $q \circ p$ standard in
category theory texts. The two conventions denote the same composite;
only the order in which the symbols are written differs. Mixing them
mid-explanation is a common source of confusion, so this book fixes path
order throughout. In path order, `Path.append` is the map

$$
\mathrm{Hom}(u,v) \times \mathrm{Hom}(v,w) \longrightarrow \mathrm{Hom}(u,w),
\qquad (p, q) \longmapsto p\,;\,q
$$

(the semicolon "$;$" is a common notation for path-order composition,
distinguishing it from function-order $\circ$). The identity laws, stated
in path order, are `Path.append p (Path.nil v) = p` (appending the trivial
path *after* `p` changes nothing; this case is implemented directly by the
`nil` branch of the `match` above, since recursion is on `q`), and,
separately, `Path.append (Path.nil u) p = p` (appending the trivial path
*before* `p` also changes nothing; proved as Exercise 2 by induction on
`p`, since the `nil` branch alone does not give this one for free). The
`cons` case of the recursion is a *definitional* recursion lemma
(`Path.append p (Path.cons a h h' q') = Path.cons a h h' (Path.append p q')`)
that lets induction unfold `Path.append` one arrow at a time. It is not
itself associativity. True associativity of composition,

$$
\mathrm{append}(\mathrm{append}(p, q), r) = \mathrm{append}(p, \mathrm{append}(q, r)),
$$

is a separate statement, provable by induction on the *third* path
argument, `r`, the same argument `Path.append` itself recurses on (as
the proof of `append_nil_left` already relies on, inducting on its second
argument). In the `nil` case both sides reduce to `append p q` directly.
In the `cons` case, both sides reduce, via exactly the `cons`-recursion
lemma above, applied on the outside of each `append`, to
`Path.cons a h h' (·)` wrapped around a strictly shorter instance of the
same equation, which the inductive hypothesis closes.
This book does not carry out that induction in Lean, but the argument above
is enough to see that it goes through. Associativity together with `nil` as
identities is what makes $\mathrm{Free}(Q)$ a genuine category, the
smallest/most general category containing the arrows of $Q$, in the sense of a
**universal property**. Concretely, for any category $C$ and any quiver
morphism $F : Q \to U(C)$ (a function on vertices and arrows into the
objects and morphisms of $C$, where $U : \mathbf{Cat} \to \mathbf{Quiv}$ is the
forgetful functor that remembers only the underlying quiver of a category,
objects and morphisms, forgetting identities and composition), there is a
*unique* functor $\hat F : \mathrm{Free}(Q) \to C$ extending $F$, i.e.
$U(\hat F) \circ \eta_Q = F$ where $\eta_Q : Q \to U(\mathrm{Free}(Q))$ is
the inclusion of generators. Equivalently,
$\mathrm{Hom}_{\mathbf{Cat}}(\mathrm{Free}(Q), C) \cong \mathrm{Hom}_{\mathbf{Quiv}}(Q, U(C))$,
naturally in $C$. $\mathrm{Free}$ is left adjoint to $U$. This book does not
formalize this functor or its uniqueness in Lean; it is stated here so the
term "universal property" names something specific rather than a vague
gesture at "the construction is canonical."

**Mathlib equivalent.** `Path.append` is already in Mathlib, as
`Quiver.Path.comp`. It is the same recursion (on the *second* path), with
the same "`nil` does nothing, `cons` re-attaches its trailing arrow" shape.

```lean
def pathBetaOnly' : Quiver.Path (1 : Fin 3) 2 := Quiver.Path.cons Quiver.Path.nil MyArrow.beta
def pathBetaAlphaViaComp' : Quiver.Path (0 : Fin 3) 2 := Quiver.Path.comp pathAlpha' pathBetaOnly'

example : pathBetaAlphaViaComp' = pathBetaAlpha' := rfl
```

This is the same closing `rfl` as the
`pathBetaAlphaViaAppend = pathBetaAlpha` check in the book, two paths built via
different routes (direct `cons`-chaining versus composing two shorter
paths) reduce to the identical term, because `Quiver.Path.comp` unfolds to
exactly the same sequence of `cons` applications `Path.append` does. Note
that this `rfl` only checks *this one concrete instance*. It is not a
proof of associativity or the identity laws in general (those are the
separate statements discussed above). It is reassurance that the concrete
`Free(Q)` machinery behaves as expected on a worked example.

### The path algebra

The **path algebra** $kQ$ of a quiver $Q$ over a field (or ring) $k$ is the
ring whose elements are $k$-linear combinations of paths in $Q$, with
multiplication given by path composition (composing two paths whose
endpoints do not match gives $0$). Formalizing $kQ$ fully (as a `Ring`, per
Chapter 9) requires "formal sums of paths with ring coefficients," which is
a genuinely bigger construction, essentially a finitely-supported function
from paths to $k$. It is a natural next project once the material above is
well understood. This chapter stops at "paths and their composition"
because that data (the *category* of paths, really) is the essential
content of the construction. Once it is in place, the ring structure on
top is routine to add.

**Mathematical reading.** The **path algebra** $kQ$ is the free $k$-module
on the set of all paths, $kQ = \bigoplus_{p\ \text{path}} k\cdot p$, with
multiplication extending path composition $k$-bilinearly, written here in the
same **path order** used throughout this section, so that it matches
`Path.append` and the quoted source below.
$$
p \cdot q = \begin{cases} p\,;q & \text{if } t(p) = s(q),\\ 0 &
\text{otherwise,}\end{cases}
$$
where $p\,;q$ means "first $p$, then $q$". (Sources that fix
function-composition order instead write this product as $q \cdot p = q \circ
p$; the algebra is the same, read right-to-left.) The unit is $\sum_{v\in V} e_v$ (the sum of the trivial paths), well-defined
as a finite sum, hence a genuine identity element, precisely when $Q_0$ is
finite. So representations of $Q$ are exactly $kQ$-modules, the bridge to
Chapter 11 promised there. The construction requires finitely-supported
functions $\{\text{paths}\} \to k$, i.e. the free module, which is why
only the composition (the category layer) is formalized here.

> **Not independently verified.** The description of $kQ$ as "the
> $k$-linearization of the free category $\mathrm{Free}(Q)$, its category
> algebra" is standard category-theory folklore, but it is *not* stated
> verbatim in either of the two sources cited by this chapter, Assem–Simson–Skowroński
> or Schiffler. Both define $kQ$
> directly by basis-and-multiplication, as above, without naming it a
> "category algebra." Treat that equivalence as a remark, not a cited
> fact, until a source stating it explicitly is added to the
> bibliography.

> Read more. The [`Module`](https://loogle.lean-lang.org/?q=Module),
> [`LinearMap`](https://loogle.lean-lang.org/?q=LinearMap), and direct-sum material of [Chapter 11](../11-modules/00-index.md) is exactly the vocabulary a full
> $kQ$-module (i.e. quiver representation) formalization would need.
> Externally, *Elements of the Representation
> Theory of Associative Algebras* (Vol. 1) by Assem–Simson–Skowroński and *Quiver
> Representations* by Schiffler both develop path algebras and their representations
> from scratch, at a similar level of explicitness to this chapter.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Path algebra $kQ$.** "Let $Q$ be a quiver. The path algebra $KQ$
  of $Q$ is the $K$-algebra whose underlying $K$-vector space has as
  its basis the set of all paths $(a \mid \alpha_1, \ldots, \alpha_l
  \mid b)$ of length $l \geq 0$ in $Q$ and such that the product of
  two basis vectors $(a \mid \alpha_1, \ldots, \alpha_l \mid b)$ and
  $(c \mid \beta_1, \ldots, \beta_k \mid d)$ of $KQ$ is defined by
  $(a \mid \alpha_1, \ldots, \alpha_l \mid b)(c \mid \beta_1, \ldots,
  \beta_k \mid d) = \delta_{bc}(a \mid \alpha_1, \ldots, \alpha_l,
  \beta_1, \ldots, \beta_k \mid d)$" ([AssemSimsonSkowronski2006],
  Ch. II §1, Definition 1.2).
- Assem, Simson, and Skowroński ([AssemSimsonSkowronski2006]), Definition 1.2, Ch. II §1, covers the path algebra $kQ$. Also notes each stationary path $\varepsilon_x$ is idempotent, and $\sum_{x\in Q_0}\varepsilon_x$ is the identity *when $Q_0$ is finite*. Note that the quoted product writes the arrows of the **left** factor first, i.e. in path order, the same order as `Path.append` and as the multiplication formula above.
- Schiffler ([Schiffler2014]), **Definition 4.5** (Chapter 5, §4.2), covers the same construction. The unit is given explicitly as $1 = \sum_{i\in Q_0} e_i$ in a lemma nearby in that section.

> **Numbering not independently verified.** An earlier draft of this box
> reported the Schiffler unit as "Lemma 4.3 in that source's numbering,"
> described as immediately following Definition 4.5, which cannot both be
> true. The definition number is the one this section relies on; the lemma
> number has been dropped rather than guessed. Check both against the printed
> source before quoting either.

[AssemSimsonSkowronski2006]: ../bibliography.md#assemsimsonskowronski2006
[Schiffler2014]: ../bibliography.md#schiffler2014

---

[← Paths as an inductive type](04-paths-as-inductive-type.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)
