## Theorem 1: multiplication by zero gives zero

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)

---

**Claim.** `Rg.mul a Rg.addGrp.id = Rg.addGrp.id`, i.e. $a \cdot 0 = 0$.

**Finding the proof.** In ordinary notation, here is the standard trick,
worth having memorized as a pattern applicable to *any* additive-identity
argument: start from $0 = 0 + 0$, multiply through, and cancel.

$$
a \cdot 0 \overset{?}{=} 0
$$

There is no `Ring` axiom that directly states this — `mul_zero` isn't a
field of `Ring` (Chapter 8), it has to be *derived* from `left_distrib` plus
group cancellation. The generic recipe: *whenever a goal involves `0` (or
any identity element) somewhere non-trivially, try rewriting it as
`0 + 0`* — this is exactly analogous to
[Chapter 7's Theorem 2](../07-group-theorems/03-theorem-2.md)'s "pad with
the identity" trick, but here it's the input to the equation you're trying to prove,
rather than the output.

$$
a \cdot 0 = a \cdot (0 + 0) = a\cdot 0 + a \cdot 0
$$

using `left_distrib` on the last step. Write $x := a \cdot 0$; we've shown
$x = x + x$. Now the goal has become "an additive-group element that equals
its own double is zero" — a pure group fact, provable by adding $-x$ to
both sides and using associativity/cancellation exactly as in Chapter 7.
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
        (Rg.addGrp.op (Rg.mul a Rg.addGrp.id) (Rg.mul a Rg.addGrp.id)) :=
    congrArg (Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul a Rg.addGrp.id))) h1
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [← Rg.addGrp.toGroup.assoc] at h2
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [Rg.addGrp.toGroup.id_left] at h2
  exact h2.symm
```

`h2` is proved with `congrArg`, not `by rw [h1]` — plain `rw [h1]` rewrites
*every* syntactic occurrence of `h1`'s left-hand side in the goal,
including copies produced by the substitution itself, so it doesn't land
on the exact stated goal here. `congrArg f h1` sidesteps this entirely: it
directly builds "apply `f` to both sides of `h1`," which is precisely
"add $-x$ to both sides of $x = x+x$" with no occurrence-targeting
ambiguity.

If you lose track partway through, the recovery move is always the same:
write the *current* hypothesis (`h1`, then `h2`) in your head using
ordinary `+`/`0` notation, check it against the paper derivation above, and
find exactly which line of the paper proof you're at. The Lean proof is
long only because each paper-proof line ("add $-x$ to both sides", "regroup",
"cancel") is one `rw`; nothing here is conceptually harder than the five-line
sketch above it.

**Mathematical reading.** This is the absorbing law $a\cdot 0 = 0$, which is
*not* an axiom but a consequence of distributivity plus additive
cancellation. Writing $x = a\cdot 0$:
$$
x = a\cdot 0 = a\cdot(0+0) = a\cdot 0 + a\cdot 0 = x + x,
$$
using $0 = 0+0$ and `left_distrib`; adding $-x$ and cancelling gives $0 = x$.
Conceptually this says the map $x \mapsto a\cdot x$ is a group homomorphism
of $(R,+)$, and homomorphisms send the identity to the identity — $0$ absorbs
because multiplication is additive in each argument.

---

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)
