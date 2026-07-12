## Paths as an inductive type indexed by source and target

[← Defining a quiver in Lean](03-defining-a-quiver.md) | [Index](00-index.md) | [Next: Path composition →](05-path-composition.md)

---

The key idea for formalizing "paths compose head-to-tail" is to make `Path`
an inductive type *indexed* by its own source and target vertex. Lean
tracks, in the type itself, which vertex a path starts and ends at. This is
the dependent-types idea previewed all the way back in
[Chapter 1](../01-basics/03-dependent-types.md): `Path Q` is a family of
types indexed by pairs of vertices, exactly the categorical
$\mathrm{Hom}$-set family $\mathrm{Hom}_{\mathrm{Free}(Q)}(u,w)$ of the free
category on $Q$.

```lean
inductive Path {V A : Type} (Q : Quiver V A) : V → V → Type where
  | nil (v : V) : Path Q v v
  | cons {u v w : V} (a : A) (h : Q.source a = v) (h' : Q.target a = w)
      (p : Path Q u v) : Path Q u w
```

Reading this carefully:

- `Path Q : V → V → Type` — for each pair of vertices `(start, finish)`,
  `Path Q start finish` is the *type* of paths from `start` to `finish`.
  A term of this type is one specific path.
- `nil (v : V) : Path Q v v` — the trivial path at `v`, going from `v` to
  `v` in zero steps. This is $e_v$ from the math above.
- `cons {u v w : V} (a : A) (h : Q.source a = v) (h' : Q.target a = w) (p : Path Q u v) : Path Q u w` —
  given an existing path `p` from `u` to `v`, and an arrow `a` whose source
  is (provably, via `h`) `v` and whose target is (provably, via `h'`) `w`,
  we can extend `p` by appending `a`, producing a path from `u` to `w`.
  The two proof fields `h` and `h'` are exactly what *prevents* you from
  building nonsense paths. You cannot `cons` an arrow onto a path unless
  the arrow's source really does match where the path left off.

Note `cons` builds the path by appending the new arrow at the *end*,
matching how you'd naturally describe "take path `p`, then follow arrow
`a`."

**Mathematical reading.** `Path Q` is the family of Hom-sets of the **free
category** $\mathrm{Free}(Q)$ on the quiver $Q$: `Path Q u w` $=
\mathrm{Hom}_{\mathrm{Free}(Q)}(u, w)$, the set of directed paths $u
\rightsquigarrow w$. As an $(V\times V)$-indexed family it is the map
$V \times V \to \mathbf{Set}$, $(u,w) \mapsto \{\text{paths } u \to w\}$.
The constructors are the category structure: `nil v` is the identity
morphism $e_v = \mathrm{id}_v \in \mathrm{Hom}(v,v)$ (the length-$0$ path),
and `cons` extends a path by one arrow, with the proof fields $h : s(a) = v$,
$h' : t(a) = w$ enforcing head-to-tail composability. This is the
type-level encoding of "$\circ$ is only defined on composable pairs."
Because the composability constraint lives *in the type*, an ill-formed
composite simply fails to typecheck. This is exactly the dependent-type
payoff from Chapter 1.

### Building the path $\beta\alpha$ (first $\alpha$, then $\beta$) in our example

```lean
def pathAlpha : Path exampleQuiver 0 1 :=
  Path.cons ExampleArrow.alpha rfl rfl (Path.nil 0)
```

- `pathAlpha` starts from `Path.nil 0` (the trivial path at vertex `0`) and
  appends `alpha` (source `0`, target `1`, both proved by `rfl` since they
  compute directly from the `match` in `exampleQuiver`'s definition).

```lean
def pathBetaAlpha : Path exampleQuiver 0 2 :=
  Path.cons ExampleArrow.beta rfl rfl pathAlpha
```

- `pathBetaAlpha` appends `beta` (source `1`, target `2`) onto `pathAlpha`,
  giving a path from `0` to `2`, exactly $\beta\alpha$.

If you tried `Path.cons ExampleArrow.beta rfl rfl (Path.nil 0)` instead
(appending `beta`, whose source is `1`, directly onto the trivial path at
`0`), Lean would reject it: the proof obligation `Q.source ExampleArrow.beta = 0`
is `1 = 0`, which is false, so no `rfl` (or any other proof) exists. This is
the type system enforcing "you can't compose arrows that don't match up",
for free, at compile time.

**Mathematical reading.** `pathBetaAlpha` is the composite morphism
$\beta\circ\alpha \in \mathrm{Hom}_{\mathrm{Free}(Q)}(0,2)$, built as
$e_0$ followed by $\alpha : 0\to 1$ followed by $\beta : 1\to 2$. The `rfl`
proofs discharge the composability side-conditions $s(\alpha)=0$,
$t(\alpha)=1$, $s(\beta)=1$, $t(\beta)=2$, which hold definitionally. The
rejected term $\beta\circ e_0$ fails because it would require
$s(\beta) = 0$, i.e. $1 = 0$, a false equation with no proof. This is the
type system refusing to compose non-composable arrows, which in a category
is the statement that $\circ$ is a *partial* operation, defined only when
endpoints agree.

**Mathlib equivalent.** Mathlib's `Quiver.Path` (building on the
`MyArrow`/`Quiver (Fin 3)` instance from the previous section) is the same
inductive family, `nil`/`cons`, just with `cons` taking the shorter path
*first* and the new arrow second. This is the mirror image of the book's
argument order, which takes the arrow first and the path last:

```lean
-- NOTE: deliberately *not* `open Quiver` — Mathlib also has a root-level
-- `Path` (a continuous path between two points of a topological space,
-- `Mathlib.Topology.Path`), so an opened `Quiver.Path` would clash with
-- it. Spelling out `Quiver.Path` throughout avoids that.
def pathAlpha' : Quiver.Path (0 : Fin 3) 1 := Quiver.Path.cons Quiver.Path.nil MyArrow.alpha
def pathBetaAlpha' : Quiver.Path (0 : Fin 3) 2 := Quiver.Path.cons pathAlpha' MyArrow.beta
```

There is no `h : Q.source a = v`/`h' : Q.target a = w` pair to prove here.
`MyArrow.alpha : MyArrow 0 1` (i.e. `(0 : Fin 3) ⟶ 1`) already forces the
endpoints via its type, exactly as flagged in the previous section. So
`Path.cons` only ever needs the arrow itself, not separate proofs about it.

---

[← Defining a quiver in Lean](03-defining-a-quiver.md) | [Index](00-index.md) | [Next: Path composition →](05-path-composition.md)
