# Chapter 8: Ring examples and basic theorems

[← Ch. 7: Rings](07-rings.md) | [Table of contents](../README.md) | [Ch. 9: Modules →](09-modules.md)

---

As in Chapter 6, the point here is the search process for each proof, not
just the final term. Ring proofs are a good stress-test of that process
because the goals get visually noisy fast (nested `addGrp.toGroup.op`
everywhere) — part of what you're learning is how to not get lost in that
noise and instead track "what algebraic fact am I one step away from using."

## Setup

```lean
variable {R : Type} (Rg : Ring R)
```

We'll write out fully-qualified field names (`Rg.addGrp.toGroup.inv`, etc.)
in every proof, precisely so it's always traceable which structure a fact
came from — but when *reading* a goal yourself, it helps to mentally
abbreviate `Rg.addGrp.op` as `+`, `Rg.addGrp.id` as `0`,
`Rg.addGrp.toGroup.inv` as unary `-`, `Rg.mul` as `*`, `Rg.one` as `1`. Do
that translation in your head first, find the proof in ordinary ring
notation, *then* translate back to the fully-qualified names — trying to
pattern-match on the qualified names directly is much harder than it needs
to be.

## Theorem 1: multiplication by zero gives zero

**Claim.** `Rg.mul a Rg.addGrp.id = Rg.addGrp.id`, i.e. $a \cdot 0 = 0$.

**Finding the proof.** In ordinary notation, here is the standard trick,
worth having memorized as a pattern applicable to *any* additive-identity
argument: start from $0 = 0 + 0$, multiply through, and cancel.

$$
a \cdot 0 \overset{?}{=} 0
$$

There is no `Ring` axiom that directly states this — `mul_zero` isn't a
field of `Ring` (Chapter 7), it has to be *derived* from `left_distrib` plus
group cancellation. The generic recipe: *whenever a goal involves `0` (or
any identity element) somewhere non-trivially, try rewriting it as
`0 + 0`* — this is exactly analogous to Theorem 6's "pad with the identity"
trick, but here it's the input to the equation you're trying to prove,
rather than the output.

$$
a \cdot 0 = a \cdot (0 + 0) = a\cdot 0 + a \cdot 0
$$

using `left_distrib` on the last step. Write $x := a \cdot 0$; we've shown
$x = x + x$. Now the goal has become "an additive-group element that equals
its own double is zero" — a pure group fact, provable by adding $-x$ to
both sides and using associativity/cancellation exactly as in Chapter 6.
**Recognizing that the ring-shaped goal reduces to a group-shaped goal you
already know how to solve** is the actual insight; everything after that is
mechanical `rw`.

```lean
theorem mul_zero (a : R) : Rg.mul a Rg.addGrp.id = Rg.addGrp.id := by
  have h0 : Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id = Rg.addGrp.id :=
    Rg.addGrp.toGroup.id_left Rg.addGrp.id
  have h1 : Rg.mul a (Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id) =
      Rg.addGrp.op (Rg.mul a Rg.addGrp.id) (Rg.mul a Rg.addGrp.id) :=
    Rg.left_distrib a Rg.addGrp.id Rg.addGrp.id
  rw [h0] at h1
  -- h1 : Rg.mul a Rg.addGrp.id = op (mul a 0) (mul a 0), i.e. x = x + x
  have h2 :
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul a Rg.addGrp.id)) (Rg.mul a Rg.addGrp.id) =
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul a Rg.addGrp.id))
        (Rg.addGrp.op (Rg.mul a Rg.addGrp.id) (Rg.mul a Rg.addGrp.id)) := by
    rw [h1]
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [← Rg.addGrp.toGroup.assoc] at h2
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [Rg.addGrp.toGroup.id_left] at h2
  exact h2.symm
```

If you lose track partway through, the recovery move is always the same:
write the *current* hypothesis (`h1`, then `h2`) in your head using
ordinary `+`/`0` notation, check it against the paper derivation above, and
find exactly which line of the paper proof you're at. The Lean proof is
long only because each paper-proof line ("add $-x$ to both sides", "regroup",
"cancel") is one `rw`; nothing here is conceptually harder than the five-line
sketch above it.

## Theorem 2: $(-1) \cdot a = -a$

**Claim.**
`Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a = Rg.addGrp.toGroup.inv a`.

**Finding the proof.** Same reduction move as Theorem 3 of Chapter 6:
"show $x = -a$" is exactly the shape of `left_inverse_unique`'s conclusion,
so — instead of computing $(-1)\cdot a$ directly — reduce the goal to
verifying $x$ is a left additive-inverse of $a$, i.e.
$((-1)\cdot a) + a = 0$. That target is now purely about combining two
products with a common right factor $a$, which is what `right_distrib`
(read backwards) is *for*: $((-1)\cdot a) + (1 \cdot a) = ((-1) + 1)\cdot a$.
Since $(-1) + 1 = 0$ (an additive-group fact, `inv_left`) and $0 \cdot a = 0$
(the mirror of Theorem 1 — see the exercises), the whole thing collapses.

The key recognition step, stated generally: **a goal of the form
`p * a + q * a = ...` is a `right_distrib` target waiting to happen, read
right-to-left**; scan any additive expression of two products sharing a
factor for this pattern before trying anything else.

```lean
theorem neg_one_mul (a : R) :
    Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a = Rg.addGrp.toGroup.inv a := by
  apply Eq.symm
  apply left_inverse_unique Rg.addGrp.toGroup
  -- Goal: op (mul (inv one) a) a = id
  conv_lhs => rw [show a = Rg.mul Rg.one a from (Rg.one_mul a).symm]
  -- Goal: op (mul (inv one) a) (mul one a) = id
  rw [← Rg.right_distrib]
  -- Goal: mul (op (inv one) one) a = id
  rw [Rg.addGrp.toGroup.inv_left]
  -- Goal: mul Rg.addGrp.id a = id, i.e. 0 * a = 0
  exact mul_zero_left Rg a
```

`conv_lhs => rw [...]` deserves a note: plain `rw` would try to rewrite
*every* occurrence of `a` in the goal, including the one inside
`mul (inv one) a` that we want to leave alone. `conv_lhs` narrows the
rewrite to only the left-hand side of the goal's equation — a targeting
tool, not a new algebraic idea. Whenever a plain `rw` seems like it would
hit the wrong occurrence of a term, `conv` (or restating the goal with
`show` first) is the fix; reach for it rather than fighting `rw`'s default
"rewrite everywhere" behavior.

This proof cites `mul_zero_left`, the mirror of Theorem 1 with
`right_distrib` in place of `left_distrib` — left as Exercise 1, since
writing it yourself, by mechanically dualizing Theorem 1's proof, is the
best way to confirm you actually understand *why* Theorem 1 needed
`left_distrib` and not `right_distrib` in the first place.

## Exercises

1. Prove `theorem mul_zero_left (a : R) : Rg.mul Rg.addGrp.id a = Rg.addGrp.id`
   by mirroring Theorem 1's proof line by line, swapping `left_distrib` for
   `right_distrib`. Before writing any Lean, write the two-line paper sketch
   (à la Theorem 1's `$a \cdot 0 = a\cdot(0+0) = \ldots$`) yourself first.
2. Prove
   `theorem neg_mul (a b : R) : Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b)`.
   Strategy: this is "show $x = -(ab)$," so reduce via `left_inverse_unique`
   to "show $x + ab = 0$," then look for a `right_distrib`-shaped
   simplification of $(-a)\cdot b + a \cdot b$, exactly as in Theorem 2.

## Next

Continue to [Chapter 9: Modules over a ring](09-modules.md).

---

[← Ch. 7: Rings](07-rings.md) | [Table of contents](../README.md) | [Ch. 9: Modules →](09-modules.md)
