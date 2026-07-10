## Translating the definition into a Lean `structure`

[← Definition](01-definition.md) | [Index](00-index.md) | [Next: Integers example →](03-integers-example.md)

---

We build this up piece by piece rather than writing the whole thing at once.

**Step 1 — just the data**, no axioms yet:

```lean
structure GroupData (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
```

This says: to build a `GroupData G`, supply an operation, an identity
element, and an inverse function. Lean does not yet check any axioms — a
`GroupData` could be complete nonsense (e.g. `op` that ignores its
arguments). We fix that next.

**Mathematical reading.** `GroupData G` is the *signature* of a group on the
carrier $G$ — the raw data $(\,\cdot : G\times G \to G,\ e \in G,\ (-)^{-1}
: G \to G\,)$ with no laws imposed. As a set it is the product
$$
\mathrm{GroupData}(G) = (G^{G\times G}) \times G \times (G^{G}),
$$
the collection of all "magma-with-distinguished-element-and-unary-op"
structures on $G$. It is a *magma* signature, not yet a group; the axioms
below carve out the genuine group structures as a subset.

**Step 2 — add the axioms as extra fields.** In Lean, a *proof* can be a
field of a structure, just like data. We add one field per axiom, each of
type "a proposition that must hold for every element":

```lean
structure Group (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
  assoc : ∀ a b c : G, op (op a b) c = op a (op b c)
  id_left : ∀ a : G, op id a = a
  id_right : ∀ a : G, op a id = a
  inv_left : ∀ a : G, op (inv a) a = id
  inv_right : ∀ a : G, op a (inv a) = id
```

Reading this line by line:

- `op : G → G → G` — the group operation, curried (Chapter 2).
- `id : G` — a single, fixed element of `G`, playing the role of $e$.
- `inv : G → G` — a function assigning to each element its inverse.
- `assoc : ∀ a b c : G, op (op a b) c = op a (op b c)` — a *proof
  obligation*: whoever constructs a `Group G` must supply a term proving
  this statement holds for every `a b c`.
- The remaining four fields are the identity and inverse axioms, split into
  left and right versions since we haven't assumed commutativity.

This is the general recipe you'll see throughout the book: **a mathematical
structure is data + proofs, bundled together**, and Lean's `structure`
mechanism is a direct, literal translation of that idea.

**Mathematical reading.** `Group G` is the type of *group structures on the
fixed carrier $G$* — a dependent tuple
$$
\Big(\,\cdot,\ e,\ (-)^{-1},\ \underbrace{\alpha}_{\text{assoc}},\
\underbrace{\lambda_\ell,\lambda_r}_{\text{identity}},\
\underbrace{\iota_\ell,\iota_r}_{\text{inverse}}\,\Big),
$$
where the last five components are *proofs* of the group axioms, i.e.
elements of the propositions
$$
\forall a,b,c,\ (a\cdot b)\cdot c = a\cdot(b\cdot c);\quad
\forall a,\ e\cdot a = a;\ \ldots;\quad \forall a,\ a\cdot a^{-1}=e.
$$
Because these fields are propositions (proof-irrelevant), `Group G` is
precisely the *subset* of `GroupData G` cut out by the group axioms — the
$\Sigma$-type $\sum_{d : \mathrm{GroupData}(G)} \mathrm{Axioms}(d)$. This is
the same $\Sigma$-type you already met in Chapter 3 as "a witness together
with a proof about it" — here the witness is a whole bundle of group data
`d : GroupData G` rather than a single element, and the proof is the
conjunction of the five axioms about it, but the shape is identical: exactly
the pairing a `structure` performs when it bundles data fields with proof
fields, as `Group` itself does above. This is
the mathematician's "a group is a set with operations *such that* the axioms
hold": the "such that" is a genuine
[subobject](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
of the space of raw data.

> Read more: Mathlib's actual `Group` (`Mathlib.Algebra.Group.Defs`) is a
> `class`, not this book's plain `structure`, and inherits from a chain of
> smaller classes (`Mul`, `One`, `Inv`, `Monoid`, ...) rather than listing
> all axioms in one place — see [Chapter 13](../13-next-steps/02-moving-to-mathlib.md)
> for the bridge between the two styles, and
> [Chapter 5 §1](../05-rigor-check/01-structure-vs-class.md) for why this
> book delays that mechanism.

---

[← Definition](01-definition.md) | [Index](00-index.md) | [Next: Integers example →](03-integers-example.md)
