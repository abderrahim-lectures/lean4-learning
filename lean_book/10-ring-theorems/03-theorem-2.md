## Theorem 2: $(-1) \cdot a = -a$

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Exercises →](04-exercises.md)

---

**Claim.**
`Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a = Rg.addGrp.toGroup.inv a`.

**Finding the proof.** This employs the same reduction move as Theorem 3
of Chapter 8: "show $x = -a$" is exactly the shape of
the conclusion of `left_inverse_unique`. Thus, instead of computing $(-1)\cdot a$
directly, we reduce the goal to verifying that $x$ is a left
additive-inverse of $a$, i.e. $((-1)\cdot a) + a = 0$. That target is now
purely about combining two products with a common right factor $a$, which
is what `right_distrib` (read backwards) is for:
$((-1)\cdot a) + (1 \cdot a) = ((-1) + 1)\cdot a$. Since $(-1) + 1 = 0$ (an
additive-group fact, `inv_left`) and $0 \cdot a = 0$ (the mirror of
Theorem 1, see the exercises), the whole expression collapses.

Stated generally, the pattern to notice is this: **a goal of the form
`p * a + q * a = ...` is a `right_distrib` target waiting to happen, read
right-to-left**. Any additive expression of two products sharing a factor
should be scanned for this pattern before anything else is attempted.

The proof below requires $0\cdot a = 0$, the mirror image of Theorem 1
($a\cdot 0 = 0$), with `right_distrib` in place of `left_distrib`. We
therefore prove that first, mechanically mirroring the proof of Theorem 1 line
by line.

```lean
theorem mul_zero_left (a : R) : Rg.mul Rg.addGrp.id a = Rg.addGrp.id := by
  have h0 : Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id = Rg.addGrp.id :=
    Rg.addGrp.toGroup.id_left Rg.addGrp.id
  have h1 : Rg.mul (Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id) a =
      Rg.addGrp.op (Rg.mul Rg.addGrp.id a) (Rg.mul Rg.addGrp.id a) :=
    Rg.right_distrib Rg.addGrp.id Rg.addGrp.id a
  rw [h0] at h1
  have h2 :
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a)) (Rg.mul Rg.addGrp.id a) =
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a))
        (Rg.addGrp.op (Rg.mul Rg.addGrp.id a) (Rg.mul Rg.addGrp.id a)) :=
    congrArg (Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a))) h1
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [← Rg.addGrp.toGroup.assoc] at h2
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [Rg.addGrp.toGroup.id_left] at h2
  exact h2.symm
```

Observe that this is the proof of Theorem 1 with every `left_distrib`/`a`
swapped for `right_distrib`/(argument order reversed). This confirms that
the "mirror image" claim is not merely a figure of speech, but a literal,
symmetrical match between the two proofs. The main theorem follows.

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

Two features of the shape of the proof are worth noting, both discovered by
actually compiling it.

- **No `apply Eq.symm` at the start.** The goal
  `Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a = Rg.addGrp.toGroup.inv a`
  already has the exact shape concluded by `left_inverse_unique`
  (`b = Grp.inv a`, with `b` unifying to
  `Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a`). Flipping it with `Eq.symm`
  first produces the *wrong* shape, and `apply left_inverse_unique` then
  fails to unify. When `apply`ing a lemma whose conclusion is an equality,
  one should check which side is which *before* reaching for `Eq.symm`,
  rather than adding it automatically.
- **`congrArg`, not `conv_lhs => rw [...]`.** Plain `rw [h]` here would
  rewrite *every* occurrence of `a` in the goal, including the one inside
  `mul (inv one) a` that must stay put. This is exactly the same kind of
  problem as `h2` of Theorem 1 on the previous page. An earlier draft tried
  `conv_lhs => rw [...]` to target only the intended occurrence, but this
  failed (Lean 4.32.2, current mathlib). `conv_lhs` navigates into the
  literal left-hand side of the goal, which does not line up with the
  occurrence that needs targeting here. `congrArg f h` avoids it by
  directly constructing "apply `f` to both sides of `h`" as its own
  standalone fact (`step`, above), which is then used with a single,
  unambiguous `rw [step]`.

**Mathematical reading.** This is the sign rule $(-1)\cdot a = -a$. By
uniqueness of additive inverses it suffices to check $(-1)\cdot a$ is a left
inverse of $a$:
$$
(-1)\cdot a + a = (-1)\cdot a + 1\cdot a = \big((-1) + 1\big)\cdot a
= 0\cdot a = 0,
$$
using $1\cdot a = a$, `right_distrib` (backwards), $-1 + 1 = 0$, and the
absorbing law $0\cdot a = 0$. It expresses that left multiplication
$x \mapsto x\cdot a$ is a group homomorphism, hence it commutes with
negation: $(-1)\cdot a = -(1\cdot a) = -a$. Thus multiplication by $-1$
*is* the negation map, which is the ring-theoretic source of
"$-a = (-1)a$."

**Mathlib equivalent.** Both `mul_zero_left` (the mirror lemma this proof
depends on) and the sign rule itself are already in Mathlib, again under
almost the same names.

```lean
example {R : Type*} [Ring R] (a : R) : 0 * a = 0 := zero_mul a
example {R : Type*} [Ring R] (a : R) : (-1 : R) * a = -a := neg_one_mul a
```

[`zero_mul`](https://loogle.lean-lang.org/?q=zero_mul) is the name Mathlib uses for `mul_zero_left`, and [`neg_one_mul`](https://loogle.lean-lang.org/?q=neg_one_mul) is exactly
Theorem 2. A multi-step derivation in the book (needing `mul_zero_left`,
`right_distrib`, and `left_inverse_unique` all at once) reduces to citing
one already-proved lemma.

---

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Exercises →](04-exercises.md)
