# Chapter 5: Structures and classes — defining a `Group`

[← Ch. 4: Tactics](04-tactics.md) | [Table of contents](../README.md) | [Ch. 6: Group Theorems →](06-group-theorems.md)

---

## The mathematical definition

A **group** is a set $G$ together with:

- a binary operation $\cdot : G \times G \to G$,
- a distinguished element $e \in G$ (the identity),
- an inverse function $(-)^{-1} : G \to G$,

satisfying three axioms, for all $a, b, c \in G$:

$$
\begin{aligned}
\text{(associativity)} &\quad (a \cdot b) \cdot c = a \cdot (b \cdot c) \\
\text{(identity)} &\quad e \cdot a = a \quad\text{and}\quad a \cdot e = a \\
\text{(inverse)} &\quad a^{-1} \cdot a = e \quad\text{and}\quad a \cdot a^{-1} = e
\end{aligned}
$$

That's it — no commutativity required in general (a group where
$a \cdot b = b \cdot a$ always holds is called **abelian** or
**commutative**; we'll define that separately).

## Translating the definition into a Lean `structure`

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

## A first example: the integers under addition

Let's package $(\mathbb{Z}, +, 0, -(-))$ as a `Group Int`. We build it field
by field, proving each obligation with a short, explicit tactic proof.

```lean
def intGroup : Group Int where
  op := fun a b => a + b
  id := 0
  inv := fun a => -a
  assoc := by
    intro a b c
    -- Goal: (a + b) + c = a + (b + c)
    exact Int.add_assoc a b c
  id_left := by
    intro a
    -- Goal: 0 + a = a
    exact Int.zero_add a
  id_right := by
    intro a
    -- Goal: a + 0 = a
    exact Int.add_zero a
  inv_left := by
    intro a
    -- Goal: (-a) + a = 0
    exact Int.add_left_neg a
  inv_right := by
    intro a
    -- Goal: a + (-a) = 0
    exact Int.add_right_neg a
```

Each field is proved separately, and each proof is a single `intro` (to name
the universally quantified variables) followed by `exact` naming the exact
core-library lemma that already states this fact about `Int`. We are not
hiding any steps — `Int.add_assoc`, `Int.zero_add`, etc. are themselves
proved (elsewhere, in Lean's core library) by induction on the same
`Nat`/`Int` representation you saw in Chapter 4; we simply reuse them here
rather than re-deriving integer arithmetic from scratch.

## Accessing the fields

Because `intGroup` is a term of type `Group Int`, we can project out its
fields exactly as in Chapter 2:

```lean
#eval intGroup.op 3 4        -- 7
#eval intGroup.id             -- 0
#eval intGroup.inv 5          -- -5

#check intGroup.assoc         -- a proof, for every a b c, of associativity
```

## Why bundle proofs with data at all?

Once we have a term `Grp : Group G`, *any* theorem we prove about a
"generic" `Group G` — using only `Grp.assoc`, `Grp.id_left`, etc. — will
automatically apply to `intGroup`, and to every other group we build later
(symmetries of a shape, permutations, path algebras' underlying additive
group, ...). This is the payoff of the whole exercise: prove it once,
generically, get it for free everywhere.

## Exercises

1. Build `boolXorGroup : Group Bool` where `op` is boolean XOR (`Bool.xor`),
   `id := false`, and `inv := fun a => a` (every element is its own
   inverse). Prove each field using `by intro a; cases a <;> rfl` is
   tempting — instead, for practice, use `cases a with | false => rfl | true => rfl`
   for the fields that need a case split, to see exactly which case does
   what.
2. Convince yourself on paper that `inv_left` and `inv_right` are genuinely
   different obligations (they coincide automatically only once you've
   *proved* the group is commutative — this is exactly the content of
   Chapter 6's first theorem).

## Next

Continue to [Chapter 6: Group examples and basic theorems](06-group-theorems.md),
where we prove facts that hold for *every* group, generically.

---

[← Ch. 4: Tactics](04-tactics.md) | [Table of contents](../README.md) | [Ch. 6: Group Theorems →](06-group-theorems.md)
