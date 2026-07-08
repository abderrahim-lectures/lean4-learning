## Dependent types, categorically

[← `def`, `let`, implicit arguments](02-def-let-implicit.md) | [Index](00-index.md)

---

Every function you've seen so far has a *fixed* codomain: `double : Nat → Nat`
returns a `Nat` no matter what `n` you feed it, the same way an ordinary
function $f : A \to B$ between sets has one fixed target set $B$. Lean's type
theory allows something more general: a family of types *indexed by* a
value, and a function whose return type changes depending on its input.
This is a **dependent type**, and it is the single feature that separates
Lean (and other proof assistants) from an ordinary typed programming
language — it is also, not coincidentally, best understood through a
categorical lens you already have.

### The non-dependent picture, first

An ordinary function $f : A \to B$ is a single morphism in a category
(objects = types, morphisms = functions — the dictionary from the previous
section). Nothing about $B$ depends on which element of $A$ you picked;
$B$ is just sitting there as a fixed object.

```lean
def double (n : Nat) : Nat := n * 2
-- double : Nat → Nat, a single fixed codomain
```

### The dependent picture

Now suppose instead of one fixed codomain, you have a whole *family* of
types, one for each vertex of a graph — exactly what Chapter 11's `Path`
does:

```lean
inductive Path {V A : Type} (Q : Quiver V A) : V → V → Type where
  | nil (v : V) : Path Q v v
  | cons {u v w : V} (a : A) (h : Q.source a = v) (h' : Q.target a = w)
      (p : Path Q u v) : Path Q u w
```

`Path Q : V → V → Type` is not a single type — it is a **family of types
indexed by a pair of vertices** $(u, w) \in V \times V$. In ordinary
mathematical notation, if $V$ is the vertex set, this family is exactly a
function

$$
\mathrm{Path}_Q : V \times V \longrightarrow \mathbf{Set}
$$

(or $\to \mathbf{Type}$, if you want to stay inside Lean's universe of
types rather than committing to sets specifically) sending a pair of
vertices $(u, w)$ to the *set of paths from $u$ to $w$* in the quiver $Q$.
This is precisely the data of an **indexed family of objects** — the same
notion, dressed differently, as a $V \times V$-indexed family of
$\mathrm{Hom}$-sets $\mathrm{Hom}_{\mathcal{C}}(u, w)$ in a locally small
category $\mathcal{C}$. In fact that comparison is not an analogy — it *is*
the same structure: Chapter 11 constructs $\mathrm{Path}_Q$ as exactly the
free category on the quiver $Q$, so `Path Q u w` literally *is*
$\mathrm{Hom}_{\mathrm{Free}(Q)}(u, w)$.

### Dependent function types: $\Pi$-types

The companion notion is a **dependent function**, whose return type
depends on its *argument's value*, not just its argument's type. In Lean,
`Path.append` is a good example of ordinary (non-dependent-in-return-type)
dependent function structure baked into its signature via implicit indices:

```lean
def Path.append {V A : Type} {Q : Quiver V A} {u v w : V}
    (p : Path Q u v) (q : Path Q v w) : Path Q u w := ...
```

Reading the type signature $u, v, w$-first: for *every* choice of vertices
$u, v, w$, and every pair of paths $p \in \mathrm{Path}_Q(u,v)$,
$q \in \mathrm{Path}_Q(v,w)$, we produce an element of $\mathrm{Path}_Q(u,w)$
— a genuinely dependent statement, since the *type* of the output
(`Path Q u w`) mentions the *values* `u`, `w` bound earlier in the same
signature. In full dependent-type-theory notation, a dependent function
type is written with $\Pi$ (a "dependent product," generalizing the
ordinary function-space $A \to B$):

$$
\prod_{x : A} B(x)
$$

read "for every $x : A$, an element of the type $B(x)$, which is allowed to
depend on $x$." When $B(x)$ happens to not depend on $x$ at all, this
collapses exactly to the ordinary function type $A \to B$ — so $\Pi$-types
strictly generalize function types, the same way a fiber bundle with a
constant fiber is just a product. Every `∀` you saw in Chapter 3
(`∀ n : Nat, n ≥ 0`) *is* a $\Pi$-type: a proposition `P n : Prop` is a
family of types indexed by `n` (recall `Prop`-valued families are
"propositional," i.e. each fiber has at most one inhabitant up to proof
irrelevance), and `∀ n, P n` is the dependent function type
$\prod_{n : \mathtt{Nat}} P(n)$ — a function producing, for each `n`, a
proof of the (n-dependent) statement `P n`.

### Why this matters for the rest of the book

Chapter 11's `Path` is the book's running example of a genuinely dependent
type, and its `cons` constructor is the book's running example of a
dependent function: the two proof arguments `h : Q.source a = v` and
`h' : Q.target a = w` are exactly what make the construction *type-safe*
composition-of-arrows, mirroring how a category's composition
$\circ : \mathrm{Hom}(v,w) \times \mathrm{Hom}(u,v) \to \mathrm{Hom}(u,w)$
is only ever applied to pairs of morphisms whose endpoints already match —
except that in Lean, "the endpoints match" is not a side-condition checked
externally, it is *encoded in the type itself*, so a term that doesn't
respect it is not merely wrong, it does not type-check at all. This is the
payoff dependent types offer a working algebraist: invariants you would
otherwise state as separate lemmas (associativity of composition only
makes sense for composable triples; a group action is only defined on the
right orbit) can instead be built into what a term's type *is*, and Lean's
kernel enforces them the same way it enforces `2 + 2 : Nat` rather than
`2 + 2 : Bool`.

> Read more: [Appendix B §4](../15-lambda-calculus/04-dependent-types-coc.md)
> gives Π-types (and Σ-types) their formal typing rules, rather than only
> the categorical analogy given here.

---

[← `def`, `let`, implicit arguments](02-def-let-implicit.md) | [Index](00-index.md) | [Next: Terminology →](04-terminology.md)
