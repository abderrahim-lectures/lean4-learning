## Translating the definition into a Lean `structure`

[← Definition](01-definition.md) | [Index](00-index.md) | [Next: Integers example →](03-integers-example.md)

---

The construction proceeds piece by piece rather than all at once.

**Step 1. Just the data**, no axioms yet.

```lean
structure GroupData (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
```

This says that to build a `GroupData G`, supply an operation, an identity
element, and an inverse function. Lean does not check any axioms yet. A
`GroupData` could still be complete nonsense (for example, an `op` that
ignores its arguments). We fix that next.

**Mathematical reading.** `GroupData G` is the *signature* of a group on the
carrier $G$, the raw data $(\,\cdot : G\times G \to G,\ e \in G,\ (-)^{-1}
: G \to G\,)$ with no laws imposed. As a set it is the product
$$
\mathrm{GroupData}(G) = (G^{G\times G}) \times G \times (G^{G}),
$$
the collection of all "magma-with-distinguished-element-and-unary-op"
structures on $G$. It is a *magma* signature, not yet a group. The axioms
below pick out the genuine group structures as a subset.

**Step 2. Add the axioms as extra fields.** In Lean, a *proof* can be a
field of a structure, just like data can. We add one field per axiom, each
of type "a proposition that must hold for every element."

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

Reading this line by line.

- `op : G → G → G` is the group operation, curried (Chapter 3).
- `id : G` is a single, fixed element of `G`, playing the role of $e$.
- `inv : G → G` is a function that assigns to each element its inverse.
- `assoc : ∀ a b c : G, op (op a b) c = op a (op b c)` is a *proof
  obligation*. Whoever constructs a `Group G` must supply a term that
  proves this statement holds for every `a b c`.
- The remaining four fields are the identity and inverse axioms. They are
  split into left and right versions because commutativity has not been
  assumed.

This is the general recipe used throughout the book: **a mathematical
structure is data plus proofs, bundled together**, and the `structure`
mechanism of Lean is a direct, literal translation of that idea.

**Mathematical reading.** `Group G` is the type of *group structures on the
fixed carrier $G$*, a dependent tuple
$$
\Big(\,\cdot,\ e,\ (-)^{-1},\ \underbrace{\alpha}_{\text{assoc}},\
\underbrace{\lambda_\ell,\lambda_r}_{\text{identity}},\
\underbrace{\iota_\ell,\iota_r}_{\text{inverse}}\,\Big),
$$
where the last five components are *proofs* of the group axioms, that is,
elements of the propositions
$$
\forall a,b,c,\ (a\cdot b)\cdot c = a\cdot(b\cdot c);\quad
\forall a,\ e\cdot a = a;\ \ldots;\quad \forall a,\ a\cdot a^{-1}=e.
$$
These five fields are propositions, so any two proofs of the same one are
considered definitionally equal. Lean does not distinguish between
different ways of proving the same axiom, only whether a proof exists.
This is why `Group G` is exactly the *subset* of `GroupData G` cut out by
the group axioms, the $\Sigma$-type
$\sum_{d : \mathrm{GroupData}(G)} \mathrm{Axioms}(d)$. This is
the same $\Sigma$-type already encountered in Chapter 4 as "a witness together
with a proof about it." Here the witness is a whole bundle of group data
`d : GroupData G` rather than a single element, and the proof is the
combination of the five axioms about it. The shape is identical. It is
exactly the pairing a `structure` performs when it bundles data fields with
proof fields, just as `Group` itself does above. This matches
the way a mathematician would say "a group is a set with operations *such
that* the axioms hold." The "such that" is a genuine
[subobject](../02-terminology-and-coc/01-terminology.md#category-theory-terms-used-beyond-the-baseline)
of the space of raw data.

> Read more. The actual `Group` in Mathlib (`Mathlib.Algebra.Group.Defs`) is a
> `class`, not the plain `structure` used in this book. It inherits from a chain of
> smaller classes (`Mul`, `One`, `Inv`, `Monoid`, ...) instead of listing
> all axioms in one place. See [Chapter 14](../14-next-steps/02-moving-to-mathlib.md)
> for the bridge between the two styles, and
> [Chapter 6, Section 1](../06-rigor-check/01-structure-vs-class.md) for why this
> book delays that mechanism.

**Programmer's corner (Python).** A Python programmer modeling a group
usually writes an ordinary class.

```python
class Group:
    def __init__(self, op, id, inv):
        self.op = op
        self.id = id
        self.inv = inv
```

Nothing here checks associativity, the identity laws, or the inverse
laws. `Group(op=lambda a, b: a - b, id=0, inv=lambda a: a)` type-checks
fine, runs fine, and is not a group at all, since subtraction is not
associative. The bug shows up later, silently, as a wrong answer
somewhere downstream, whenever some theorem that assumed associativity
gets applied to this particular `op` without ever re-checking the
assumption. `GroupData` above has exactly the same problem this bare Python class
has, values are just bundled and nothing about those values is
checked. That gap is exactly why `Group` adds the five axiom fields. A term of type `Group G` cannot exist unless proofs of
`assoc`, `id_left`, `id_right`, `inv_left`, and `inv_right` were
actually supplied, so every theorem in the rest of this book that takes
a `Group G` as an argument gets those five facts for free, checked once
at construction time, rather than having to hope every caller happened
to build the underlying data correctly.

---

[← Definition](01-definition.md) | [Index](00-index.md) | [Next: Integers example →](03-integers-example.md)
