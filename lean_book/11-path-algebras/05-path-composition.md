## Path composition

[← Paths as an inductive type](04-paths-as-inductive-type.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

---

Given a path `p : Path Q u v` and a path `q : Path Q v w`, we can concatenate
them into a path `Path Q u w`. We define this by recursion on `q`:

```lean
def Path.append {V A : Type} {Q : Quiver V A} {u v w : V}
    (p : Path Q u v) (q : Path Q v w) : Path Q u w :=
  match q with
  | Path.nil _ => p
  | Path.cons a h h' q' => Path.cons a h h' (Path.append p q')
```

Reading the recursion:

- If `q` is trivial (`Path.nil _`, a path of length zero from `v` to `v`),
  then appending `p` before it just gives back `p` itself (there's nothing
  to append).
- If `q` ends with an arrow `a` (i.e. `q = Path.cons a h h' q'` for some
  shorter path `q'`), then appending `p` before all of `q` is the same as
  appending `p` before the shorter `q'`, and then re-attaching the same
  final arrow `a` on top.

This recursion terminates because each recursive call is on the strictly
shorter path `q'` — the same structural recursion principle behind the
`induction` tactic from Chapter 4.

### A worked instance: rebuilding `pathBetaAlpha` via `append`

The previous section built `pathBetaAlpha : Path exampleQuiver 0 2`
directly, one `Path.cons` at a time. Here it is again, built instead by
*composing* the shorter path `pathAlpha` with a fresh one-arrow path via
`Path.append` — and, reassuringly, both constructions produce the exact
same path.

```lean
def pathBetaOnly : Path exampleQuiver 1 2 :=
  Path.cons ExampleArrow.beta rfl rfl (Path.nil 1)
```

`pathBetaOnly` is that fresh one-arrow path: a path from `1` to `2`
consisting of just the single arrow `beta`, built on its own rather than
by extending `pathAlpha`.

```lean
def pathBetaAlphaViaAppend : Path exampleQuiver 0 2 :=
  Path.append pathAlpha pathBetaOnly
```

`pathBetaAlphaViaAppend` composes the shorter path `pathAlpha` with
`pathBetaOnly` via `Path.append`, giving a path from `0` to `2` — the same
endpoints as `pathBetaAlpha`, but assembled by composition instead of by
chaining `Path.cons` calls directly.

```lean
example : pathBetaAlphaViaAppend = pathBetaAlpha := rfl
```

That final `rfl` is not a weak or approximate check — it says the two
constructions are *definitionally* the same term, reducing to an
identical normal form (Chapter 5), not merely "provably equal after some
argument." This is the concrete payoff of `Path.append`'s recursive
definition: composing paths built independently, via arbitrarily different
routes, agrees exactly with building the composite path directly by hand,
because both ultimately unfold to the same sequence of `Path.cons`
applications.

**Mathematical reading.** `Path.append` is **composition in the free
category** $\mathrm{Free}(Q)$, written throughout this section in *path
order* — "$p$ then $q$," matching the argument order of `Path.append p q`
— rather than the function-composition order $q \circ p$ you may be used
to from category theory texts (the two conventions denote the same
composite; only the order the symbols are written differs, and mixing
them mid-explanation is a common source of confusion, so this book fixes
path order throughout). In path order, `Path.append` is the map

$$
\mathrm{Hom}(u,v) \times \mathrm{Hom}(v,w) \longrightarrow \mathrm{Hom}(u,w),
\qquad (p, q) \longmapsto p\,;\,q
$$

(the semicolon "$;$" is a common notation for path-order composition,
distinguishing it from function-order $\circ$). The identity laws, stated
in path order: `Path.append p (Path.nil v) = p` (appending the trivial
path *after* `p` changes nothing — the case implemented directly by the
`nil` branch of the `match` above, since recursion is on `q`) and,
separately, `Path.append (Path.nil u) p = p` (appending the trivial path
*before* `p` also changes nothing — proved as Exercise 2 by induction on
`p`, since the `nil` branch alone doesn't give this one for free). The
`cons` case of the recursion is exactly associativity of concatenation.
Together with `nil` as identities, this makes $\mathrm{Free}(Q)$ a genuine
category — the smallest/most general category containing $Q$'s arrows, in
the sense of a
[universal property](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline).

### The path algebra

The **path algebra** $kQ$ of a quiver $Q$ over a field (or ring) $k$ is the
ring whose elements are $k$-linear combinations of paths in $Q$, with
multiplication given by path composition (composing two paths whose
endpoints don't match gives $0$). Formalizing $kQ$ fully (as a `Ring`, per
Chapter 8) requires "formal sums of paths with ring coefficients," which is
a genuinely bigger construction — essentially a finitely-supported function
from paths to $k$ — and is a great next project once you're comfortable
with everything above. We stop at "paths and their composition" here
because that data (the *category* of paths, really) is the beating heart of
the construction; the ring structure on top is bookkeeping once you have it.

**Mathematical reading.** The **path algebra** $kQ$ is the free $k$-module
on the set of all paths, $kQ = \bigoplus_{p\ \text{path}} k\cdot p$, with
multiplication extending path composition $k$-bilinearly:
$$
q \cdot p = \begin{cases} q\circ p & \text{if } t(p) = s(q),\\ 0 &
\text{otherwise,}\end{cases}
$$
and unit $\sum_{v\in V} e_v$ (the sum of the trivial paths). Equivalently
$kQ$ is the $k$-linearization of the free category $\mathrm{Free}(Q)$ — its
*category algebra* — so representations of $Q$ are exactly $kQ$-modules, the
bridge to Chapter 10 promised there. The construction requires
finitely-supported functions $\{\text{paths}\} \to k$, i.e. the free module,
which is why only the composition (the category layer) is formalized here.

> Read more: [Chapter 10](../10-modules/00-index.md)'s `Module`,
> `LinearMap`, and direct-sum material is exactly the vocabulary a full
> $kQ$-module (i.e. quiver representation) formalization would need.
> Externally, Assem–Simson–Skowroński's *Elements of the Representation
> Theory of Associative Algebras* (Vol. 1) and Schiffler's *Quiver
> Representations* both develop path algebras and their representations
> from scratch, at a similar level of explicitness to this chapter.

---

[← Paths as an inductive type](04-paths-as-inductive-type.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)
