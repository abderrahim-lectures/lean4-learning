## Example: a finite commutative ring, $\mathbb{Z}/3\mathbb{Z}$

[← Integers example](04-integers-example.md) | [Index](00-index.md) | [Next: Accessing nested fields →](06-accessing-fields.md)

---

`intRing` is commutative, infinite, and — being $\mathbb{Z}$ itself — the
initial ring (Chapter 7's Theorem 1/2 hold for it as easily as
possible, since it has essentially the "obvious" ring structure).
Chapter 7's matrix example shows a genuinely *noncommutative* ring. This
section shows the other direction the axioms can specialize to: a
**commutative, finite** ring, small enough to check every axiom by direct
computation rather than by citing library lemmas.

### The carrier: `Fin 3`

`Fin 3` is Lean's type of "naturals less than 3," i.e. $\{0, 1, 2\}$. Its
built-in `+`/`*` already wrap around modulo 3, so `Fin 3`'s arithmetic
*is* $\mathbb{Z}/3\mathbb{Z}$'s arithmetic:

```lean
#eval (2 : Fin 3) + 2   -- 1   (2 + 2 = 4 ≡ 1 mod 3)
#eval (2 : Fin 3) * 2   -- 1   (2 * 2 = 4 ≡ 1 mod 3)
```

### Building `Group (Fin 3)`, `CommGroup (Fin 3)`, `Ring (Fin 3)`

Because `Fin 3` has only three elements, every one of `Group`/`Ring`'s
axioms is a **finite, decidable** statement — literally "check this
equation holds for all $3$ (or $3^2$, or $3^3$) choices of its variables."
That's exactly the kind of goal Chapter 12 recommends handing to [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) rather
than proving by hand:

```lean
def fin3Group : Group (Fin 3) where
  op := fun a b => a + b
  id := 0
  inv := fun a => -a
  assoc := by decide
  id_left := by decide
  id_right := by decide
  inv_left := by decide
  inv_right := by decide

def fin3CommGroup : CommGroup (Fin 3) where
  toGroup := fin3Group
  comm := by decide

def fin3Ring : Ring (Fin 3) where
  addGrp := fin3CommGroup
  mul := fun a b => a * b
  one := 1
  mul_assoc := by decide
  one_mul := by decide
  mul_one := by decide
  left_distrib := by decide
  right_distrib := by decide
```

**Programmer's corner (Python).** `by decide` on a goal like `assoc` for
`Fin 3` is not magic. It's exactly what you'd get from

```python
domain = range(3)
all((a + b) + c == a + (b + c) for a in domain for b in domain for c in domain)
```

brute-force enumerate every combination of the (finitely many) variables
and check the equation holds for each. The difference isn't the algorithm,
it's *where* the check lives. `all(...)` is a runtime assertion: it only
runs if some line of code calls it. If you forget to call it (or a
later refactor deletes the call), Python will never notice the property
broke. `decide` instead runs as part of *type-checking* `fin3Group` itself.
The definition doesn't elaborate at all unless the brute-force check
succeeds, so there is no such thing as a `fin3Group` value that quietly
skipped its axiom checks. It's the same enumeration, but promoted from "a
test you hope someone runs" to a condition the kernel enforces before the
value can even exist.

```lean
#eval fin3Ring.addGrp.op 2 2          -- 1  (2 + 2 = 1 mod 3)
#eval fin3Ring.mul 2 2                 -- 1  (2 * 2 = 1 mod 3)
#eval fin3Ring.addGrp.toGroup.inv 1     -- 2  (-1 = 2 mod 3)
```

Compare this construction style directly with `intRing` (previous
section) and `mat2Ring` (next section): `intRing`'s axioms needed
`Int.add_assoc`-style library citations because `Int` is infinite. There
is no way to "check all cases" of a statement about *every* integer.
`Fin 3`'s axioms are statements about only finitely many (and
concretely enumerable) elements, so they can instead be handled by exhaustive
case-checking, which is exactly what `decide` automates. Recognizing which
regime a goal is in — infinite carrier needing a real argument, versus
finite carrier where brute enumeration is enough — is itself a useful
instinct to build. See Chapter 12 for more on when `decide` is (and isn't)
the right tool.

**Mathematical reading.** `fin3Ring` is $\mathbb{Z}/3\mathbb{Z}$, the
finite field with three elements (though we've only built the `Ring`
structure here — a `Field` would additionally require every nonzero
element to be invertible under multiplication, true for $\mathbb{Z}/3$
precisely because $3$ is prime, but this is not part of `Ring`'s axioms and not
checked here). It is the quotient $\mathbb{Z}/(3)$ by the ideal generated
by $3$, with `Fin 3`'s built-in wraparound arithmetic giving
reduction mod $3$ directly at the level of the representation, rather than
through an explicit quotient construction.

**Mathlib equivalent.** Mathlib's [`ZMod 3`](https://loogle.lean-lang.org/?q=ZMod) *is* $\mathbb{Z}/3\mathbb{Z}$,
already known to be a commutative ring (in fact a field, since $3$ is
prime). There is no `fin3Group`/`fin3CommGroup`/`fin3Ring` bundle, and no `decide`
calls needed to re-verify axioms already proved once, generically, for
every `n`:

```lean
example : CommRing (ZMod 3) := inferInstance

#eval (2 : ZMod 3) + 2   -- 1
#eval (2 : ZMod 3) * 2   -- 1
```

The book's `by decide` on `fin3Ring`'s fields brute-forces exactly the
finitely many cases needed for *this one* carrier. Mathlib instead proves
`ZMod n`'s ring axioms once for every `n` (through its construction as
`Fin n` with wraparound arithmetic, combined with the general machinery
for quotients of $\mathbb{Z}$), so `ZMod 3`'s instance costs nothing further
to obtain.

## Next

Continue to [Accessing nested fields](06-accessing-fields.md).

---

[← Integers example](04-integers-example.md) | [Index](00-index.md) | [Next: Accessing nested fields →](06-accessing-fields.md)
