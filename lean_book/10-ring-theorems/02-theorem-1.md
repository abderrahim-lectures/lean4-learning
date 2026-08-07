## Theorem 1: multiplication by zero gives zero

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)

---

**Claim.** `Rg.mul a Rg.addGrp.id = Rg.addGrp.id`, i.e. $a \cdot 0 = 0$.

**Finding the proof.** In ordinary notation, the standard trick is as
follows. It is worth memorizing as a pattern applicable to any
additive-identity argument, start from $0 = 0 + 0$, multiply through, and
cancel.

$$
a \cdot 0 \overset{?}{=} 0
$$

No `Ring` axiom directly states this. [`mul_zero`](https://loogle.lean-lang.org/?q=mul_zero) is not a
field of `Ring` (Chapter 9); it must instead be *derived* from `left_distrib`
plus group cancellation. The general recipe is that whenever a goal involves `0`
(or any identity element) in a non-trivial way, attempt rewriting it as
`0 + 0`. This is exactly the "pad with the identity" trick of
[Theorem 2 of Chapter 8](../08-group-theorems/03-theorem-2.md),
but here it is applied to the input of the
equation to be proved, rather than to the output.

$$
a \cdot 0 = a \cdot (0 + 0) = a\cdot 0 + a \cdot 0
$$

using `left_distrib` on the last step. Writing $x := a \cdot 0$, this shows
$x = x + x$. The goal has thereby become "an additive-group element that
equals its own double is zero," a pure group fact, provable by adding
$-x$ to both sides and using associativity/cancellation exactly as in
Chapter 8. **Recognizing that the ring-shaped goal reduces to a
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

`h2` is proved with `congrArg`, not `by rw [h1]`. In an earlier draft,
attempting to rewrite with `h1` at this intermediate `have` using plain
`rw` caused occurrence-targeting problems. `rw [h1]` rewrites *every*
syntactic occurrence of the left-hand side of `h1` in the goal, including
copies produced by the substitution itself, and hence does not land on
the exact stated goal here. `congrArg f h1` avoids this problem entirely.
It directly builds "apply `f` to both sides of `h1`," which is precisely
"add $-x$ to both sides of $x = x+x$" with no ambiguity about which
occurrence is targeted.

If progress is lost partway through, the recovery move is always the
same, translate the *current* hypothesis (`h1`, then `h2`) into ordinary
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

**Programmer's corner (Python).** `mul_zero` looks obvious enough that a
Python codebase would never think to test it, `x * 0` is `0`, of
course. It genuinely is, for `int`. It is not, for every numeric type
Python ships.

```python
float('nan') * 0.0   # nan, not 0.0
float('inf') * 0.0   # nan, not 0.0
```

`nan` and `inf` are ordinary `float` values, reachable from perfectly
normal-looking arithmetic (`1.0 / 0.0` under the right settings, or the
result of an earlier overflow), and once one of them appears, "multiply
anything by zero and get zero" quietly stops holding, with no exception
raised anywhere to flag it. The theorem `mul_zero` proved above carries
no such asterisk, because it is proved from the `Ring` axioms of
Chapter 9 alone, and any `R` that can be given a genuine `Ring R` value
must, by that same proof, actually satisfy it, no matter what `R` turns
out to be later. There is no possibility of an `R` that type-checks as
a `Ring` and still has some element behaving like `nan`, since a `nan`-
like element would falsify `left_distrib` or one of the additive-group
axioms `mul_zero` is built from, and a `Ring R` value could never have
been constructed for it in the first place.

**Mathlib equivalent.** Where the book spends a full `have`/`congrArg`/`rw`
derivation getting from `left_distrib` and group cancellation to
$a\cdot 0=0$, Mathlib already proves this and gives it exactly the same
name.

```lean
example {R : Type*} [Ring R] (a : R) : a * 0 = 0 := mul_zero a
```

There is nothing to derive. `mul_zero` is proved once, generically, for
every `Ring` (indeed every `MulZeroClass`), by essentially the argument
above, and is then simply *available* rather than re-derived at each use
site.

---

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)
