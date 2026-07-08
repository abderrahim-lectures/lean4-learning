## Example: a finite commutative ring, $\mathbb{Z}/3\mathbb{Z}$

[← Integers example](04-integers-example.md) | [Index](00-index.md) | [Next: Accessing nested fields →](06-accessing-fields.md)

---

`intRing` is commutative, infinite, and — being $\mathbb{Z}$ itself — the
initial ring (Chapter 7's Theorem 1/2 hold for it as trivially as
possible, since it has essentially the "obvious" ring structure).
Chapter 7's matrix example shows a genuinely *noncommutative* ring; this
section shows the other direction the axioms can specialize: a
**commutative, finite** ring, small enough to check every axiom by direct
computation rather than by citing library lemmas.

### The carrier: `Fin 3`

`Fin 3` is Lean's type of "naturals less than 3," i.e. $\{0, 1, 2\}$, and
its built-in `+`/`*` already wrap around modulo 3 — `Fin 3`'s arithmetic
*is* $\mathbb{Z}/3\mathbb{Z}$'s arithmetic:

```lean
#eval (2 : Fin 3) + 2   -- 1   (2 + 2 = 4 ≡ 1 mod 3)
#eval (2 : Fin 3) * 2   -- 1   (2 * 2 = 4 ≡ 1 mod 3)
```

### Building `Group (Fin 3)`, `CommGroup (Fin 3)`, `Ring (Fin 3)`

Because `Fin 3` has only three elements, every one of `Group`/`Ring`'s
axioms is a **finite, decidable** statement — literally "check this
equation holds for all $3$ (or $3^2$, or $3^3$) choices of its variables,"
exactly the kind of goal Chapter 12 recommends handing to `decide` rather
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

```lean
#eval fin3Ring.addGrp.op 2 2          -- 1  (2 + 2 = 1 mod 3)
#eval fin3Ring.mul 2 2                 -- 1  (2 * 2 = 1 mod 3)
#eval fin3Ring.addGrp.toGroup.inv 1     -- 2  (-1 = 2 mod 3)
```

Contrast this construction style directly with `intRing` (previous
section) and `mat2Ring` (next section): `intRing`'s axioms needed
`Int.add_assoc`-style library citations because `Int` is infinite — there
is no way to "check all cases" of a statement about *every* integer.
`Fin 3`'s axioms, being statements about only finitely many (and
concretely enumerable) elements, can instead be dispatched by exhaustive
case-checking, which is exactly what `decide` automates. Recognizing which
regime a goal is in — infinite carrier needing a real argument, versus
finite carrier where brute enumeration suffices — is itself a useful
instinct to build; see Chapter 12 for more on when `decide` is (and isn't)
the appropriate tool.

**Mathematical reading.** `fin3Ring` is $\mathbb{Z}/3\mathbb{Z}$, the
finite field with three elements (though we've only built the `Ring`
structure here — a `Field` would additionally require every nonzero
element to be invertible under multiplication, true for $\mathbb{Z}/3$
precisely because $3$ is prime, but not part of `Ring`'s axioms and not
checked here). It is the quotient $\mathbb{Z}/(3)$ by the ideal generated
by $3$, with `Fin 3`'s built-in wraparound arithmetic implementing
reduction mod $3$ directly at the level of the representation, rather than
via an explicit quotient construction.

## Next

Continue to [Accessing nested fields](06-accessing-fields.md).

---

[← Integers example](04-integers-example.md) | [Index](00-index.md) | [Next: Accessing nested fields →](06-accessing-fields.md)
