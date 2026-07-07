# Chapter 9: Quivers and path algebras

This chapter combines everything so far — inductive types (Chapter 1),
structures (Chapter 2), and rings (Chapters 7–8) — to build a genuinely
interesting example: the **path algebra** of a quiver.

## What is a quiver?

A **quiver** (in this algebraic sense — not related to Lean 4's `Mathlib`
name for something similar, which we are not using) is simply a *directed
graph*: a set of vertices and a set of directed edges (called **arrows**)
between them. Formally, a quiver $Q$ consists of:

- a set of vertices $Q_0$,
- a set of arrows $Q_1$,
- two functions $s, t : Q_1 \to Q_0$ giving each arrow's **source** and
  **target**.

Picture an arrow $\alpha : i \to j$ as a literal arrow drawn from vertex $i$
to vertex $j$; $s(\alpha) = i$ and $t(\alpha) = j$.

### Example quiver

Take vertices $\{1, 2, 3\}$ and arrows

$$
\alpha : 1 \to 2, \qquad \beta : 2 \to 3
$$

## Paths

A **path** in $Q$ is a sequence of arrows that can be composed head-to-tail:
$\alpha_1, \alpha_2, \dots, \alpha_n$ with $t(\alpha_i) = s(\alpha_{i+1})$ for
each consecutive pair. We also allow, for each vertex $i$, a **trivial path**
$e_i$ of length $0$ that starts and ends at $i$ and composes with nothing but
itself.

In our example, the paths are: $e_1, e_2, e_3$ (trivial), $\alpha$, $\beta$,
and $\beta\alpha$ (first $\alpha$, then $\beta$) — and nothing else, since
there's no arrow out of $3$ or into $1$.

## Defining a quiver in Lean

We encode a quiver as a `structure`, parameterized by a type of vertices and
a type of arrows:

```lean
structure Quiver (V : Type) (A : Type) where
  source : A → V
  target : A → V
```

This is a direct transcription: `V` is the type of vertices, `A` the type of
arrows, and `source`/`target` are exactly $s$ and $t$ above.

### Our example quiver, formalized

Encode the three vertices as `Fin 3` (values `0, 1, 2`, standing for
vertices `1, 2, 3`) and the two nontrivial arrows as an inductive type:

```lean
inductive ExampleArrow where
  | alpha : ExampleArrow   -- 0 → 1
  | beta : ExampleArrow     -- 1 → 2

def exampleQuiver : Quiver (Fin 3) ExampleArrow where
  source := fun a => match a with
    | ExampleArrow.alpha => 0
    | ExampleArrow.beta => 1
  target := fun a => match a with
    | ExampleArrow.alpha => 1
    | ExampleArrow.beta => 2
```

`inductive ExampleArrow where | alpha : ExampleArrow | beta : ExampleArrow`
defines a brand-new type with exactly two values, `alpha` and `beta` — this
is the same `inductive` mechanism that builds `Nat` (Chapter 1) and `Bool`,
just with two constructors that carry no extra data.

## Paths as an inductive type indexed by source and target

The key idea for formalizing "paths compose head-to-tail" is to make `Path`
an inductive type *indexed* by its own source and target vertex — Lean
tracks, in the type itself, which vertex a path starts and ends at.

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
  building nonsense paths — you cannot `cons` an arrow onto a path unless
  the arrow's source really does match where the path left off.

Note `cons` builds the path by appending the new arrow at the *end*,
matching how you'd naturally describe "take path `p`, then follow arrow
`a`."

### Building the path $\beta\alpha$ (first $\alpha$, then $\beta$) in our example

```lean
def pathAlpha : Path exampleQuiver 0 1 :=
  Path.cons ExampleArrow.alpha rfl rfl (Path.nil 0)

def pathBetaAlpha : Path exampleQuiver 0 2 :=
  Path.cons ExampleArrow.beta rfl rfl pathAlpha
```

- `pathAlpha` starts from `Path.nil 0` (the trivial path at vertex `0`) and
  appends `alpha` (source `0`, target `1` — both proved by `rfl` since they
  compute directly from the `match` in `exampleQuiver`'s definition).
- `pathBetaAlpha` appends `beta` (source `1`, target `2`) onto `pathAlpha`,
  giving a path from `0` to `2` — exactly $\beta\alpha$.

If you tried `Path.cons ExampleArrow.beta rfl rfl (Path.nil 0)` instead
(appending `beta`, whose source is `1`, directly onto the trivial path at
`0`), Lean would reject it: the proof obligation `Q.source ExampleArrow.beta = 0`
is `1 = 0`, which is false, so no `rfl` (or any other proof) exists. This is
the type system enforcing "you can't compose arrows that don't match up" —
for free, at compile time.

## Path composition

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

### The path algebra

The **path algebra** $kQ$ of a quiver $Q$ over a field (or ring) $k$ is the
ring whose elements are $k$-linear combinations of paths in $Q$, with
multiplication given by path composition (composing two paths whose
endpoints don't match gives $0$). Formalizing $kQ$ fully (as a `Ring`, per
Chapter 7) requires "formal sums of paths with ring coefficients," which is
a genuinely bigger construction — essentially a finitely-supported function
from paths to $k$ — and is a great next project once you're comfortable
with everything above. We stop at "paths and their composition" here
because that data (the *category* of paths, really) is the beating heart of
the construction; the ring structure on top is bookkeeping once you have it.

## Exercises

1. Add a third arrow `gamma : ExampleArrow` with `source gamma = 2` and
   `target gamma = 0`, creating a cycle `0 → 1 → 2 → 0`. Build the path
   `gamma ∘ beta ∘ alpha : Path exampleQuiver 0 0`.
2. Prove `theorem append_nil_left {V A} {Q : Quiver V A} {u v} (p : Path Q u v) : Path.append (Path.nil u) p = p`
   by induction on `p` (mirroring the structure of `Path.append`'s own
   recursion), spelling out the base (`Path.nil`) and inductive
   (`Path.cons`) cases as in Chapter 4's `induction` examples.
3. (Optional, harder) Sketch — in comments, no need to complete the Lean —
   what a `structure PathAlgebra (V A : Type) (Q : Quiver V A) (k : Type) (Rg : Ring k)`
   would need to contain to satisfy `Ring`'s fields from Chapter 7.

## Next

Continue to [Chapter 10: Working efficiently in Lean](10-working-efficiently.md).
