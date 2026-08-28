## Translating the definition into a Lean `structure`

[← Definition](01-definition.md) | [Index](00-index.md) | [Next: Integers example →](03-integers-example.md)

---

The definition names three pieces of data and three families of axioms.
Lean has no primitive for "data plus proof obligations" other than
`structure` itself, so the translation proceeds in two steps: record the
data first, with nothing checked, then add one field per axiom.

**Step 1. Just the data.**

```lean
structure GroupData (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
```

A `GroupData G` is an operation, an identity element, and an inverse
function, with no axiom checked. It can still be nonsense: `op` could
ignore both arguments.

**Mathematical reading.** `GroupData G` is the *signature* of a group on
the carrier $G$, the raw data $(\,\cdot : G\times G \to G,\ e \in G,\
(-)^{-1} : G \to G\,)$ with no laws imposed, the product
$$
\mathrm{GroupData}(G) = (G^{G\times G}) \times G \times (G^{G}).
$$
It is a *magma* signature, not yet a group; the axioms below cut out the
genuine group structures as a subset.

**Step 2. Add the axioms as extra fields.** A proof can be a field of a
structure exactly as data can. One field per axiom, each of type "a
proposition that must hold for every element":

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

`assoc` is a *proof obligation*: whoever constructs a `Group G` must
supply a term proving it for every `a b c`. The remaining four fields are
the identity and inverse axioms, split left/right because commutativity
has not been assumed. Collapsing them into one field each would
silently assume it.

**Mathematical reading.** `Group G` is the type of *group structures on
the fixed carrier $G$*, a dependent tuple
$$
\Big(\,\cdot,\ e,\ (-)^{-1},\ \underbrace{\alpha}_{\text{assoc}},\
\underbrace{\lambda_\ell,\lambda_r}_{\text{identity}},\
\underbrace{\iota_\ell,\iota_r}_{\text{inverse}}\,\Big),
$$
where the last five components are proofs of
$$
\forall a,b,c,\ (a\cdot b)\cdot c = a\cdot(b\cdot c);\quad
\forall a,\ e\cdot a = a;\ \ldots;\quad \forall a,\ a\cdot a^{-1}=e.
$$
`Group G` is exactly the subset of `GroupData G` cut out by these five
propositions, the $\Sigma$-type $\sum_{d : \mathrm{GroupData}(G)}
\mathrm{Axioms}(d)$, the same shape as Chapter 4's "witness together with
a proof about it," here with a whole bundle of data as the witness. This
matches "a set with operations *such that* the axioms hold"; the "such
that" is a genuine
[subobject](../02-terminology-and-coc/01-terminology.md#category-theory-terms-used-beyond-the-baseline)
of the space of raw data.

> Read more. The actual `Group` in Mathlib (`Mathlib.Algebra.Group.Defs`) is a
> `class`, not the plain `structure` used in this book, inheriting from a chain of
> smaller classes (`Mul`, `One`, `Inv`, `Monoid`, ...) instead of listing
> all axioms in one place. See [Chapter 14](../14-next-steps/02-moving-to-mathlib.md)
> for the bridge between the two styles, and
> [Chapter 6, Section 1](../06-rigor-check/01-structure-vs-class.md) for why this
> book delays that mechanism.

**Programmer's corner (Python).** An ordinary Python class checks none of
this:

```python
class Group:
    def __init__(self, op, id, inv):
        self.op = op
        self.id = id
        self.inv = inv
```

`Group(op=lambda a, b: a - b, id=0, inv=lambda a: a)` type-checks and
runs, and is not a group, since subtraction is not associative. The bug
surfaces later, silently, wherever a theorem assuming associativity is
applied to this `op` without re-checking the assumption. `GroupData`
above has the identical defect. Values are bundled but nothing is
checked, which is exactly why `Group` adds the five axiom fields: a term of type `Group
G` cannot exist unless proofs of `assoc`, `id_left`, `id_right`,
`inv_left`, and `inv_right` were actually supplied, so every theorem in
the rest of the book taking a `Group G` gets those five facts for free,
checked once, rather than trusting every caller to have built the
underlying data correctly.

---

[← Definition](01-definition.md) | [Index](00-index.md) | [Next: Integers example →](03-integers-example.md)
