## A first example: the integers under addition

[← Translating into Lean](02-translating.md) | [Index](00-index.md) | [Next: Accessing the fields →](04-accessing-fields.md)

---

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

**Mathematical reading.** This exhibits $(\mathbb{Z}, +, 0, -)$ as an object
of the category $\mathbf{Grp}$ — the term `intGroup` is a *proof that
$\mathbb{Z}$ is a group*, constructed by giving the data $(+, 0, -)$ and
verifying each axiom. The verification is not re-proved here but *cited*:
associativity is $\mathrm{Int.add\_assoc}$, the identity laws are $0 + a = a
= a + 0$, and the inverse laws are $(-a) + a = 0 = a + (-a)$. In textbook
terms this is the one-line remark "$\mathbb{Z}$ under addition is an abelian
group," with the underlying lemmas about $\mathbb{Z}$ (themselves ultimately
inductions on the integers) made explicit rather than assumed.

---

[← Translating into Lean](02-translating.md) | [Index](00-index.md) | [Next: Accessing the fields →](04-accessing-fields.md)
