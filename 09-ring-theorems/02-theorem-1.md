## Theorem 1: multiplication by zero gives zero

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)

---

**Claim.** `Rg.mul a Rg.addGrp.id = Rg.addGrp.id`, i.e. $a \cdot 0 = 0$.

**Finding the proof.** In ordinary notation, the standard trick is as
follows; it is worth memorizing as a pattern applicable to any
additive-identity argument: start from $0 = 0 + 0$, multiply through, and
cancel.

$$
a \cdot 0 \overset{?}{=} 0
$$

No `Ring` axiom directly states this. [`mul_zero`](https://loogle.lean-lang.org/?q=mul_zero) is not a
field of `Ring` (Chapter 8); it must instead be *derived* from `left_distrib`
plus group cancellation. The general recipe: whenever a goal involves `0`
(or any identity element) in a non-trivial way, attempt rewriting it as
`0 + 0`. This is exactly [Chapter 7's Theorem 2](../07-group-theorems/03-theorem-2.md)'s
"pad with the identity" trick, but here it is applied to the input of the
equation to be proved, rather than to the output.

$$
a \cdot 0 = a \cdot (0 + 0) = a\cdot 0 + a \cdot 0
$$

using `left_distrib` on the last step. Writing $x := a \cdot 0$, this shows
$x = x + x$. The goal has thereby become "an additive-group element that
equals its own double is zero" — a pure group fact, provable by adding
$-x$ to both sides and using associativity/cancellation exactly as in
Chapter 7. **Recognizing that the ring-shaped goal reduces to a
group-shaped goal already known to be solvable** is the real insight;
everything thereafter is mechanical `rw`.

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

`h2` is proved with `congrArg`, not `by rw [h1]`. Plain `rw [h1]` rewrites
*every* syntactic occurrence of `h1`'s left-hand side in the goal,
including copies produced by the substitution itself, and hence does not
land on the exact stated goal here. `congrArg f h1` avoids this problem
entirely: it directly builds "apply `f` to both sides of `h1`," which is
precisely "add $-x$ to both sides of $x = x+x$" with no ambiguity about
which occurrence is targeted.

If progress is lost partway through, the recovery move is always the
same: translate the *current* hypothesis (`h1`, then `h2`) into ordinary
`+`/`0` notation, check it against the paper derivation above, and
identify exactly which line of the paper proof this corresponds to. The
Lean proof is long only because each paper-proof line ("add $-x$ to both
sides", "regroup", "cancel") corresponds to one `rw`. Nothing here is
conceptually harder than the five-line sketch preceding it.

**Mathematical reading.** This is the absorbing law $a\cdot 0 = 0$, which
is *not* an axiom but a consequence of distributivity plus additive
cancellation. Writing $x = a\cdot 0$:
$$
x = a\cdot 0 = a\cdot(0+0) = a\cdot 0 + a\cdot 0 = x + x,
$$
using $0 = 0+0$ and `left_distrib`; adding $-x$ and cancelling gives $0 = x$.
Conceptually this says the map $x \mapsto a\cdot x$ is a group homomorphism
of $(R,+)$, and homomorphisms send the identity to the identity. $0$ absorbs
because multiplication is additive in each argument.

**Mathlib equivalent.** Where the book spends a full `have`/`congrArg`/`rw`
derivation getting from `left_distrib` and group cancellation to
$a\cdot 0=0$, Mathlib already proves this and gives it exactly the same
name:

```lean
example {R : Type*} [Ring R] (a : R) : a * 0 = 0 := mul_zero a
```

There is nothing to derive — `mul_zero` is proved once, generically, for
every `Ring` (indeed every `MulZeroClass`), by essentially the argument
above, and is then simply *available* rather than re-derived at each use
site.

---

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)
