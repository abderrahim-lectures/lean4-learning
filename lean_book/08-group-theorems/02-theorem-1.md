## Theorem 1: the identity is unique

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)

---

**Claim.** If `e' : G` also satisfies `∀ a, Grp.op e' a = a`, then
`e' = Grp.id`.

**Finding the proof.** We begin by stating the goal and examining what is
available.

```lean
theorem id_unique (e' : G) (h : ∀ a : G, Grp.op e' a = a) : e' = Grp.id := by
  have step1 : Grp.op e' Grp.id = Grp.id := h Grp.id
  have step2 : Grp.op e' Grp.id = e' := Grp.id_right e'
  rw [← step2]
  exact step1
```

The goal is `e' = Grp.id`, an equality between two elements of `G` about
which we individually know very little: `e'` only through `h`, and `Grp.id`
only through the axioms of `Grp` itself. **When a goal is "show two opaque things
are equal," the standard move is to find a *third* expression that both
sides equal on their own, then chain the two equalities.** We ask whether
there is anything both `e'` and `Grp.id` can be related to.

`h` lets us compute `Grp.op e' a` for *any* `a`, in particular for
`a := Grp.id`, giving `Grp.op e' Grp.id = Grp.id`. Separately, `Grp.id_right`
(a field of `Group`, so available for free) says `Grp.op e' Grp.id = e'`
(instantiating its universal quantifier at `e'`). Both describe
`Grp.op e' Grp.id`. That is the third expression. Once this is noticed, the
proof is a matter of bookkeeping.

```lean
theorem id_unique (e' : G) (h : ∀ a : G, Grp.op e' a = a) : e' = Grp.id := by
  have step1 : Grp.op e' Grp.id = Grp.id := h Grp.id
  have step2 : Grp.op e' Grp.id = e' := Grp.id_right e'
  rw [← step2]
  exact step1
```

Why `rw [← step2]` and not `rw [step2]`? The goal is `e' = Grp.id`, and
`step2 : Grp.op e' Grp.id = e'` has `e'` on its *right*. `rw [step2]` would
rewrite the `Grp.op e' Grp.id` in the goal, but the goal does not yet contain
that term. It contains `e'`. `rw [← step2]` rewrites right-to-left,
replacing `e'` (which the goal *does* contain) with `Grp.op e' Grp.id`.
This right-to-left choice, "which side of the `have` actually appears in
the goal at present," is something to check every time `rw` is invoked, not
something to guess. Put more sharply, **rewrite the side that actually
appears in the current goal**, not whichever side happens to look more
"finished." The direction of `rw` is dictated by what is already there, not
by where the proof is headed.

**Mathematical reading.** This is the classical *uniqueness of the identity*.
If $e'$ is a left identity ($e'\cdot a = a$ for all $a$) then $e' = e$. The
one-line proof is
$$
e' \overset{\text{id\_right}}{=} e' \cdot e \overset{h}{=} e,
$$
evaluating the hypothesis at $a = e$ and comparing with the axiom $e'\cdot e
= e'$. Both compute $e' \cdot e$, so $e' = e$. The two `have`s are these two
equalities, and the `rw`/`exact` glue them at their common expression $e'\cdot
e$, the standard "two things equal to a common third are equal." (The
same argument in mirror shows a right identity is also unique, so the
identity of a group is unique, full stop.)

**Programmer note (Python).** A Python codebase that wants
confidence in "the identity element is unique" reaches for a test.

```python
def test_identity_unique():
    assert my_group.op(other_identity, "a") == "a"
    assert other_identity == my_group.id
```

This test passes, once, for whichever `my_group` and whichever `"a"`
were chosen when writing it. It says nothing about the next group
someone defines, or the next element they pick, since the test only
ever ran the specific inputs written into it. `id_unique` above is not
a test run against one `Group`. `e'` and `Grp.id` are arbitrary, bound
by `∀`, so the proof, once it type-checks, holds for every group and
every candidate identity that will ever exist, including ones not yet
written. This is the difference the phrase "proof, not test" is
pointing at throughout this chapter. A test samples finitely many
cases and hopes they generalize. A proof, since it is a term whose type
quantifies over all of `G`, covers every case at once, the same way
`id_unique e'` can be applied to any group later in this book, or in
any project built on top of it, without re-checking anything.

**Mathlib equivalent.** Phrased against the [`Group`](https://loogle.lean-lang.org/?q=Group) class in Mathlib, `Grp.op`/
`Grp.id`/`Grp.id_right` become the ordinary `*`/`1`/[`mul_one`](https://loogle.lean-lang.org/?q=mul_one), and the
whole "third expression" chain collapses into a single `.symm.trans`.

```lean
example {G : Type*} [Group G] (e' : G) (h : ∀ a : G, e' * a = a) : e' = 1 :=
  (mul_one e').symm.trans (h 1)
```

This is the same proof, the same two facts glued at their common value
$e'\cdot 1$: `h 1` is `step1` in the book and `mul_one e'` is `step2`. The
only difference is that `1` is written for `Grp.id`, and there is no
field-projection to spell out, since `*`/`1` already mean "whatever the
`Group` instance for this type says they mean."

---

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)
