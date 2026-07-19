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

<p><a href="https://live.lean-lang.org/#code=inductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=inductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Reading this carefully:

- `Path Q : V → V → Type` — for each pair of vertices `(start, finish)`,
  `Path Q start finish` is the *type* of paths from `start` to `finish`.
  A term of this type is one specific path.
- `nil (v : V) : Path Q v v` — the trivial path at `v`, going from `v` to
  `v` in zero steps. This is $e_v$ from the math above.
- `cons {u v w : V} (a : A) (h : Q.source a = v) (h' : Q.target a = w) (p : Path Q u v) : Path Q u w` —
  given an existing path `p` from `u` to `v`, and an arrow `a` whose source
  is (provably, via `h`) `v` and whose target is (provably, via `h'`) `w`,
  `p` can be extended by appending `a`, producing a path from `u` to `w`.
  The two proof fields `h` and `h'` are exactly what *prevents* the
  construction of nonsense paths: an arrow cannot be `cons`ed onto a path unless
  its source matches where the path left off.

Note that `cons` builds the path by appending the new arrow at the *end*,
matching the natural description "take path `p`, then follow arrow
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

<p><a href="https://live.lean-lang.org/#code=def%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

- `pathAlpha` starts from `Path.nil 0` (the trivial path at vertex `0`) and
  appends `alpha` (source `0`, target `1`, both proved by `rfl` since they
  compute directly from the `match` in `exampleQuiver`'s definition).

<p><a href="https://live.lean-lang.org/#code=def%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

- `pathBetaAlpha` appends `beta` (source `1`, target `2`) onto `pathAlpha`,
  giving a path from `0` to `2`, exactly $\beta\alpha$.

Attempting `Path.cons ExampleArrow.beta rfl rfl (Path.nil 0)` instead
(appending `beta`, whose source is `1`, directly onto the trivial path at
`0`) is rejected by Lean: the proof obligation `Q.source ExampleArrow.beta = 0`
is `1 = 0`, which is false, so no `rfl` (or any other proof) exists. This is
the type system enforcing "arrows that do not match up cannot compose",
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

**Mathlib equivalent.** Mathlib's [`Quiver.Path`](https://loogle.lean-lang.org/?q=Quiver.Path) (building on the
`MyArrow`/`Quiver (Fin 3)` instance from the previous section) is the same
inductive family, `nil`/`cons`, just with `cons` taking the shorter path
*first* and the new arrow second. This is the mirror image of the book's
argument order, which takes the arrow first and the path last:

<p><a href="https://live.lean-lang.org/#code=--%20NOTE%3A%20deliberately%20%2Anot%2A%20%60open%20Quiver%60%20%E2%80%94%20Mathlib%20also%20has%20a%20root-level%0A--%20%60Path%60%20%28a%20continuous%20path%20between%20two%20points%20of%20a%20topological%20space%2C%0A--%20%60Mathlib.Topology.Path%60%29%2C%20so%20an%20opened%20%60Quiver.Path%60%20would%20clash%20with%0A--%20it.%20Spelling%20out%20%60Quiver.Path%60%20throughout%20avoids%20that.%0Adef%20pathAlpha%27%20%3A%20Quiver.Path%20%280%20%3A%20Fin%203%29%201%20%3A%3D%20Quiver.Path.cons%20Quiver.Path.nil%20MyArrow.alpha%0Adef%20pathBetaAlpha%27%20%3A%20Quiver.Path%20%280%20%3A%20Fin%203%29%202%20%3A%3D%20Quiver.Path.cons%20pathAlpha%27%20MyArrow.beta" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20NOTE%3A%20deliberately%20%2Anot%2A%20%60open%20Quiver%60%20%E2%80%94%20Mathlib%20also%20has%20a%20root-level%0A--%20%60Path%60%20%28a%20continuous%20path%20between%20two%20points%20of%20a%20topological%20space%2C%0A--%20%60Mathlib.Topology.Path%60%29%2C%20so%20an%20opened%20%60Quiver.Path%60%20would%20clash%20with%0A--%20it.%20Spelling%20out%20%60Quiver.Path%60%20throughout%20avoids%20that.%0Adef%20pathAlpha%27%20%3A%20Quiver.Path%20%280%20%3A%20Fin%203%29%201%20%3A%3D%20Quiver.Path.cons%20Quiver.Path.nil%20MyArrow.alpha%0Adef%20pathBetaAlpha%27%20%3A%20Quiver.Path%20%280%20%3A%20Fin%203%29%202%20%3A%3D%20Quiver.Path.cons%20pathAlpha%27%20MyArrow.beta" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

There is no `h : Q.source a = v`/`h' : Q.target a = w` pair to prove here.
`MyArrow.alpha : MyArrow 0 1` (i.e. `(0 : Fin 3) ⟶ 1`) already forces the
endpoints via its type, exactly as flagged in the previous section. So
`Path.cons` only ever needs the arrow itself, not separate proofs about it.

---

[← Defining a quiver in Lean](03-defining-a-quiver.md) | [Index](00-index.md) | [Next: Path composition →](05-path-composition.md)
