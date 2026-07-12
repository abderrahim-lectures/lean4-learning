## Theorem 1: the identity is unique

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)

---

**Claim.** If `e' : G` also satisfies `∀ a, Grp.op e' a = a`, then
`e' = Grp.id`.

**Finding the proof.** Start by stating the goal and looking at what's
available:

```lean
theorem id_unique (e' : G) (h : ∀ a : G, Grp.op e' a = a) : e' = Grp.id := by
  sorry
```

The goal is `e' = Grp.id`, an equality between two elements of `G` about
which we individually know very little: `e'` only through `h`, and `Grp.id`
only through `Grp`'s own axioms. **When a goal is "show two opaque things
are equal," the standard move is to find a *third* expression that both
sides equal on their own, then chain the two equalities.** Ask: is there
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

Why `rw [← step2]` and not `rw [step2]`? The goal is `e' = Grp.id`, and
`step2 : Grp.op e' Grp.id = e'` has `e'` on its *right*. `rw [step2]` would
rewrite the goal's `Grp.op e' Grp.id`, but the goal doesn't contain that
term yet — it contains `e'`. `rw [← step2]` rewrites right-to-left,
replacing `e'` (which the goal *does* contain) with `Grp.op e' Grp.id`.
This right-to-left choice, "which side of my `have` actually appears in
the goal right now," is something to check every time you reach for `rw`,
not something to guess.

**Mathematical reading.** This is the classical *uniqueness of the identity*:
if $e'$ is a left identity ($e'\cdot a = a$ for all $a$) then $e' = e$. The
one-line proof is
$$
e' \overset{\text{id\_right}}{=} e' \cdot e \overset{h}{=} e,
$$
evaluating the hypothesis at $a = e$ and comparing with the axiom $e'\cdot e
= e'$: both compute $e' \cdot e$, so $e' = e$. The two `have`s are these two
equalities, and the `rw`/`exact` glue them at their common expression $e'\cdot
e$: the standard "two things equal to a common third are equal." (The
same argument in mirror shows a right identity is also unique, so a group's
identity is unique, full stop.)

**Mathlib equivalent.** Phrased against Mathlib's `Group` class, `Grp.op`/
`Grp.id`/`Grp.id_right` become the ordinary `*`/`1`/`mul_one`, and the
whole "third expression" chain collapses into a single `.symm.trans`:

```lean
example {G : Type*} [Group G] (e' : G) (h : ∀ a : G, e' * a = a) : e' = 1 :=
  (mul_one e').symm.trans (h 1)
```

This is the same proof, the same two facts glued at their common value
$e'\cdot 1$: `h 1` is the book's `step1` and `mul_one e'` is `step2`. The
only difference is that `1` is written for `Grp.id`, and there's no
field-projection to spell out, since `*`/`1` already mean "whatever this
type's `Group` instance says they mean."

---

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)
