## Theorem 2: $(-1) \cdot a = -a$

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Exercises →](04-exercises.md)

---

**Claim.**
`Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a = Rg.addGrp.toGroup.inv a`.

**Finding the proof.** Same reduction move as Theorem 3 of Chapter 7:
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
  apply left_inverse_unique Rg.addGrp.toGroup
  -- Goal: op (mul (inv one) a) a = id
  have step : Rg.addGrp.op (Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a) a =
      Rg.addGrp.op (Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a) (Rg.mul Rg.one a) :=
    congrArg (Rg.addGrp.op (Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a))
      (show a = Rg.mul Rg.one a from (Rg.one_mul a).symm)
  rw [step]
  -- Goal: op (mul (inv one) a) (mul one a) = id
  rw [← Rg.right_distrib]
  -- Goal: mul (op (inv one) one) a = id
  rw [Rg.addGrp.toGroup.inv_left]
  -- Goal: mul Rg.addGrp.id a = id, i.e. 0 * a = 0
  exact mul_zero_left Rg a
```

Two things worth noting about the proof's shape, both found by actually
compiling it:

- **No `apply Eq.symm` at the start.** The goal
  `Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a = Rg.addGrp.toGroup.inv a`
  already has the exact shape `left_inverse_unique` concludes
  (`b = Grp.inv a`, with `b` unifying to
  `Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a`) — flipping it with `Eq.symm`
  first produces the *wrong* shape, and `apply left_inverse_unique` then
  fails to unify. When `apply`ing a lemma whose conclusion is an equality,
  check which side is which *before* reaching for `Eq.symm`, rather than
  adding it reflexively.
- **`congrArg`, not `conv_lhs => rw [...]`.** Plain `rw [h]` here would try
  to rewrite *every* occurrence of `a` in the goal, including the one
  inside `mul (inv one) a` that must stay put — exactly the same class of
  problem as Theorem 1's `h2` on the previous page. `congrArg f h` sidesteps
  it by directly constructing "apply `f` to both sides of `h`" as its own
  standalone fact (`step`, above), which is then used with a single,
  unambiguous `rw [step]`.

This proof cites `mul_zero_left`, the mirror of Theorem 1 with
`right_distrib` in place of `left_distrib` — left as Exercise 1, since
writing it yourself, by mechanically dualizing Theorem 1's proof, is the
best way to confirm you actually understand *why* Theorem 1 needed
`left_distrib` and not `right_distrib` in the first place.

**Mathematical reading.** This is the sign rule $(-1)\cdot a = -a$. By
uniqueness of additive inverses it suffices to check $(-1)\cdot a$ is a left
inverse of $a$:
$$
(-1)\cdot a + a = (-1)\cdot a + 1\cdot a = \big((-1) + 1\big)\cdot a
= 0\cdot a = 0,
$$
using $1\cdot a = a$, `right_distrib` (backwards), $-1 + 1 = 0$, and the
absorbing law $0\cdot a = 0$. It expresses that left multiplication
$x \mapsto x\cdot a$ is a group homomorphism, so it commutes with negation:
$(-1)\cdot a = -(1\cdot a) = -a$. Consequently multiplication by $-1$ *is*
the negation map, the ring-theoretic source of "$-a = (-1)a$."

---

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Exercises →](04-exercises.md)
