## A first example: the integers under addition

[← Translating into Lean](02-translating.md) | [Index](00-index.md) | [Next: Permutations example →](04-permutations-example.md)

---

A definition with no inhabitant is empty. Does anything satisfy `Group`?
$(\mathbb{Z}, +, 0, -(-))$ does, and the construction proceeds field by
field, each obligation closed by a short, explicit tactic proof rather
than assumed.

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

Each field is a single `intro` followed by `exact`, naming the
core-library lemma that already states the fact about `Int`. Nothing is
hidden: `Int.add_assoc`, `Int.zero_add`, and the rest are themselves
proved, elsewhere, by induction on the same representation of `Nat`/`Int`
from Chapter 5, and reused here rather than re-derived.

**Mathematical reading.** This exhibits $(\mathbb{Z}, +, 0, -)$ as an
object of $\mathbf{Grp}$. `intGroup` is a proof that $\mathbb{Z}$ is a
group, built by supplying $(+, 0, -)$ and citing, not re-proving, each
axiom: associativity is $\mathrm{Int.add\_assoc}$, the identity laws are
$0 + a = a = a + 0$, the inverse laws are $(-a) + a = 0 = a + (-a)$. This
is the one-line textbook remark "$\mathbb{Z}$ under addition is an
abelian group," with the underlying inductions on $\mathbb{Z}$ written
out rather than assumed.

**Mathlib equivalent.** Mathlib needs no `intGroup`-style bundle at all.
`Int` is already an [`AddCommGroup`](https://loogle.lean-lang.org/?q=AddCommGroup) instance, and the five axioms above are
free-standing lemmas applying to every additive group, not only `Int`.

```lean
example : AddCommGroup Int := inferInstance

example (a b c : Int) : (a + b) + c = a + (b + c) := add_assoc a b c
example (a : Int) : 0 + a = a := zero_add a
example (a : Int) : a + 0 = a := add_zero a
example (a : Int) : -a + a = 0 := neg_add_cancel a
example (a : Int) : a + -a = 0 := add_neg_cancel a
```

Same five facts about $\mathbb{Z}$; where the book *assembles* a `Group
Int` term by hand, the instance already exists, found automatically by
[`inferInstance`](https://loogle.lean-lang.org/?q=inferInstance). [`add_assoc`](https://loogle.lean-lang.org/?q=add_assoc)/[`zero_add`](https://loogle.lean-lang.org/?q=zero_add)/etc.
are generic over *any* `AddCommGroup`, so they apply equally to the
`perm3Group`-style example of Section 4 once phrased in Mathlib's
`Group`/`AddCommGroup` classes, as that section does next.

---

[← Translating into Lean](02-translating.md) | [Index](00-index.md) | [Next: Permutations example →](04-permutations-example.md)
