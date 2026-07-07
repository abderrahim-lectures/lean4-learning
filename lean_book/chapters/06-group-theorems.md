# Chapter 6: Group examples and basic theorems

In this chapter we prove theorems about an *arbitrary* group — given some
`Grp : Group G` for an unknown `G`, using only the fields from Chapter 5.
The point of this chapter is less the three theorems themselves (they're
standard) and more **the search process** for finding each proof: given a
goal, what do you look at, what do you try, and how do you recognize when
you're stuck versus one step away. Each theorem below is presented as that
search, not just its answer.

## Setup

```lean
variable {G : Type} (Grp : Group G)
```

`variable` adds `{G : Type} (Grp : Group G)` silently to every following
declaration that mentions `G` or `Grp`.

## Theorem 1: the identity is unique

**Claim.** If `e' : G` also satisfies `∀ a, Grp.op e' a = a`, then
`e' = Grp.id`.

**Finding the proof.** Start by stating the goal and looking at what's
available:

```lean
theorem id_unique (e' : G) (h : ∀ a : G, Grp.op e' a = a) : e' = Grp.id := by
  sorry
```

The goal is `e' = Grp.id`, an equality between two elements of `G` about
which we know very little individually — `e'` only through `h`, `Grp.id`
only through `Grp`'s own axioms. **When a goal is "show two opaque things
are equal," the standard move is to find a *third* expression both sides
independently equal, then chain the two equalities.** Ask: is there
anything both `e'` and `Grp.id` can be related to?

`h` lets you compute `Grp.op e' a` for *any* `a` — in particular for
`a := Grp.id`, giving `Grp.op e' Grp.id = Grp.id`. Separately, `Grp.id_right`
(a field of `Group`, so available for free) says `Grp.op e' Grp.id = e'`
(instantiating its universal quantifier at `e'`). Both describe
`Grp.op e' Grp.id` — that's the third expression. Once you notice this, the
proof is just bookkeeping:

```lean
theorem id_unique (e' : G) (h : ∀ a : G, Grp.op e' a = a) : e' = Grp.id := by
  have step1 : Grp.op e' Grp.id = Grp.id := h Grp.id
  have step2 : Grp.op e' Grp.id = e' := Grp.id_right e'
  rw [← step2]
  exact step1
```

Why `rw [← step2]` and not `rw [step2]`: the goal is `e' = Grp.id`, and
`step2 : Grp.op e' Grp.id = e'` has `e'` on its *right*. `rw [step2]` would
rewrite the goal's `Grp.op e' Grp.id` — but the goal doesn't contain that
term yet, it contains `e'`. `rw [← step2]` rewrites right-to-left, replacing
`e'` (which the goal *does* contain) with `Grp.op e' Grp.id`. This
right-to-left orientation choice — "which side of my `have` actually
appears in the goal right now" — is something to check every time you
reach for `rw`, not something to guess.

## Theorem 2: left inverses equal right inverses

**Claim.** If `Grp.op b a = Grp.id` for some `a b : G`, then
`b = Grp.inv a`.

**Finding the proof.** Same shape as Theorem 1 — an equality between two
elements known only through separate facts (`h` about `b`, the `Group`
axioms about `Grp.inv a`) — so the same strategy applies: relate both sides
to something in common. But here there's no single lemma that hands you
`Grp.op b Grp.id` the way `Grp.id_right` did in Theorem 1's simpler
setting; you have to *build* the chain by successively rewriting `b` itself.

The trick worth internalizing: **pad `b` with the identity, then swap the
identity for something you can cancel.** Concretely:

$$
b \;=\; b \cdot e \;=\; b \cdot (a \cdot a^{-1}) \;=\; (b \cdot a) \cdot a^{-1} \;=\; e \cdot a^{-1} \;=\; a^{-1}
$$

Each `=` above is licensed by exactly one `Group` field or the hypothesis
`h`, in this order: `id_right` (backwards), `inv_right` (backwards),
`assoc` (backwards), `h`, `id_left`. Writing the *paper* proof first, as a
chain of equalities, then reading off which axiom licenses each step, is
often faster than guessing tactics directly against the goal — do this on
scratch paper before opening the editor.

```lean
theorem left_inverse_unique (a b : G) (h : Grp.op b a = Grp.id) :
    b = Grp.inv a := by
  have e1 : b = Grp.op b Grp.id := (Grp.id_right b).symm
  rw [e1]
  -- Goal: op b id = inv a
  rw [← Grp.inv_right a]
  -- Goal: op b (op a (inv a)) = inv a
  rw [← Grp.assoc b a (Grp.inv a)]
  -- Goal: op (op b a) (inv a) = inv a
  rw [h]
  -- Goal: op id (inv a) = inv a
  exact Grp.id_left (Grp.inv a)
```

At each `rw`, the goal-state comment records what you'd see in the editor —
train yourself to predict that comment *before* running the tactic, then
check. When your prediction is wrong, that's the moment worth stopping and
understanding why (usually: the `rw` fired on a different occurrence of the
pattern than you expected, or in the wrong direction).

## Theorem 3: inverse of a product

**Claim.** `Grp.inv (Grp.op a b) = Grp.op (Grp.inv b) (Grp.inv a)`.

**Finding the proof.** This *looks* like it should again be "chain of
equalities," but there's a shortcut once you recognize the goal's shape
matches a theorem you already have. The claim states that some element
(`Grp.inv (Grp.op a b)`) equals some other expression built from `a`, `b`.
Theorem 2 already tells you: *to show `x = Grp.inv y`, it suffices to show
`x` is a left inverse of `y`* — i.e. reduce an inverse-computation goal to a
single equation `Grp.op x y = Grp.id`, which is usually easier to attack
directly with `assoc`/`inv_left`/`inv_right` than staring at `inv (...)`.
This is a general and reusable move: **once you've proved a
uniqueness/characterization lemma, use it to convert "compute this thing"
goals into "verify this thing satisfies the characterizing property"
goals** — almost always a simpler target.

Applying that here (with the goal read backwards, `apply Eq.symm` first, so
`left_inverse_unique` unifies against the "b" slot), the remaining goal is
`Grp.op (Grp.op (Grp.inv b) (Grp.inv a)) (Grp.op a b) = Grp.id` — pure
cancellation: regroup with `assoc` until `Grp.inv a` sits next to `a`,
cancel via `inv_left`, then `Grp.inv b` sits next to `b`, cancel again.

```lean
theorem inv_op (a b : G) :
    Grp.inv (Grp.op a b) = Grp.op (Grp.inv b) (Grp.inv a) := by
  apply Eq.symm
  apply left_inverse_unique
  -- Goal: op (op (inv b) (inv a)) (op a b) = id
  rw [Grp.assoc]
  -- Goal: op (inv b) (op (inv a) (op a b)) = id
  rw [← Grp.assoc (Grp.inv a) a b]
  -- Goal: op (inv b) (op (op (inv a) a) b) = id
  rw [Grp.inv_left]
  -- Goal: op (inv b) (op id b) = id
  rw [Grp.id_left]
  -- Goal: op (inv b) b = id
  exact Grp.inv_left b
```

Notice how much of this `rw` chain is **regrouping via `assoc` to bring a
cancelable pair adjacent**, then cancelling. That two-step pattern —
*regroup, then cancel* — recurs constantly in algebra and is worth
recognizing on sight rather than re-deriving from scratch each time.

## Exercises

1. Prove `theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a`. Before writing
   any tactics, ask: does this match the shape of a lemma you already have
   (Theorem 2 again)? What single fact about `a` and `Grp.inv a` would let
   you invoke it directly?
2. Prove `theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c`.
   Strategy hint: you cannot directly rewrite `b` or `c` in isolation —
   instead, apply `Grp.op (Grp.inv a)` to *both sides* of `h` first (as a
   `have`), then simplify each side down using `assoc`/`inv_left`/`id_left`,
   the same "regroup, then cancel" pattern as Theorem 3.

## Next

Continue to [Chapter 7: Rings](07-rings.md).
