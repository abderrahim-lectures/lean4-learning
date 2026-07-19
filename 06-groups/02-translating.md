## Translating the definition into a Lean `structure`

[← Definition](01-definition.md) | [Index](00-index.md) | [Next: Integers example →](03-integers-example.md)

---

The construction proceeds piece by piece rather than all at once.

**Step 1 — just the data**, no axioms yet:

<p><a href="https://live.lean-lang.org/#code=structure%20GroupData%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20GroupData%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This says: to build a `GroupData G`, supply an operation, an identity
element, and an inverse function. Lean does not check any axioms yet. A
`GroupData` could still be complete nonsense (for example, an `op` that
ignores its arguments). We fix that next.

**Mathematical reading.** `GroupData G` is the *signature* of a group on the
carrier $G$: the raw data $(\,\cdot : G\times G \to G,\ e \in G,\ (-)^{-1}
: G \to G\,)$ with no laws imposed. As a set it is the product
$$
\mathrm{GroupData}(G) = (G^{G\times G}) \times G \times (G^{G}),
$$
the collection of all "magma-with-distinguished-element-and-unary-op"
structures on $G$. It is a *magma* signature, not yet a group. The axioms
below pick out the genuine group structures as a subset.

**Step 2 — add the axioms as extra fields.** In Lean, a *proof* can be a
field of a structure, just like data can. We add one field per axiom, each
of type "a proposition that must hold for every element":

<p><a href="https://live.lean-lang.org/#code=structure%20Group%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Group%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id" title="Lean playground" loading="lazy" style="width:100%;height:231px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Reading this line by line:

- `op : G → G → G` — the group operation, curried (Chapter 2).
- `id : G` — a single, fixed element of `G`, playing the role of $e$.
- `inv : G → G` — a function that assigns to each element its inverse.
- `assoc : ∀ a b c : G, op (op a b) c = op a (op b c)` — a *proof
  obligation*: whoever constructs a `Group G` must supply a term that
  proves this statement holds for every `a b c`.
- The remaining four fields are the identity and inverse axioms. They are
  split into left and right versions because commutativity has not been
  assumed.

This is the general recipe used throughout the book: **a mathematical
structure is data plus proofs, bundled together**, and Lean's `structure`
mechanism is a direct, literal translation of that idea.

**Mathematical reading.** `Group G` is the type of *group structures on the
fixed carrier $G$*: a dependent tuple
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
These fields are propositions (proof-irrelevant), so `Group G` is exactly
the *subset* of `GroupData G` cut out by the group axioms: the
$\Sigma$-type $\sum_{d : \mathrm{GroupData}(G)} \mathrm{Axioms}(d)$. This is
the same $\Sigma$-type already encountered in Chapter 3 as "a witness together
with a proof about it." Here the witness is a whole bundle of group data
`d : GroupData G` rather than a single element, and the proof is the
combination of the five axioms about it. The shape is identical: it is
exactly the pairing a `structure` performs when it bundles data fields with
proof fields, just as `Group` itself does above. This matches
the mathematician's way of saying "a group is a set with operations *such
that* the axioms hold": the "such that" is a genuine
[subobject](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
of the space of raw data.

> Read more: Mathlib's actual `Group` (`Mathlib.Algebra.Group.Defs`) is a
> `class`, not this book's plain `structure`. It inherits from a chain of
> smaller classes (`Mul`, `One`, `Inv`, `Monoid`, ...) instead of listing
> all axioms in one place. See [Chapter 13](../13-next-steps/02-moving-to-mathlib.md)
> for the bridge between the two styles, and
> [Chapter 5 §1](../05-rigor-check/01-structure-vs-class.md) for why this
> book delays that mechanism.

---

[← Definition](01-definition.md) | [Index](00-index.md) | [Next: Integers example →](03-integers-example.md)
