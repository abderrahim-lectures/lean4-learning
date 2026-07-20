## Example: the integers as a ring

[← Ring](03-ring.md) | [Index](00-index.md) | [Next: Finite ring example →](05-finite-ring-example.md)

---

### Recall

Formal definition cited in this section, gathered here for quick
reference (full citation in the [Bibliography](../bibliography.md)):

- **Ring homomorphism.** "A ring homomorphism is a map $\varphi : R
  \to S$ satisfying (i) $\varphi(a+b) = \varphi(a)+\varphi(b)$ ... and
  (ii) $\varphi(ab) = \varphi(a)\varphi(b)$" ([DummitFoote2003], §7.3
  "Ring Homomorphisms and Quotient Rings," p. 239).

We reuse `intGroup` from Chapter 6 as the additive part.

```lean
def intCommGroup : CommGroup Int where
  toGroup := intGroup
  comm := by
    intro a b
    exact Int.add_comm a b
```

`toGroup := intGroup` fills the field inherited from `Group Int` inside
`CommGroup Int`'s definition. This is how `extends` works mechanically:
under the hood, `CommGroup G` really has fields `toGroup : Group G` and
`comm : ...`, and Lean's dot-notation makes `cg.op` mean `cg.toGroup.op`
automatically.

```lean
def intRing : Ring Int where
  addGrp := intCommGroup
  mul := fun a b => a * b
  one := 1
  mul_assoc := by
    intro a b c
    exact Int.mul_assoc a b c
  one_mul := by
    intro a
    exact Int.one_mul a
  mul_one := by
    intro a
    exact Int.mul_one a
  left_distrib := by
    intro a b c
    exact Int.mul_add a b c
  right_distrib := by
    intro a b c
    exact Int.add_mul a b c
```

Every proof obligation is again a one-line `exact` naming a specific
core-library fact about `Int` (`Int.mul_assoc`, `Int.one_mul`, ...), exactly
as in Chapter 6. Integer arithmetic is not being proved from nothing; rather,
already-known facts are assembled into the `Ring` bundle.

**Mathematical reading.** This shows $(\mathbb{Z}, +, \times, 0, 1)$ as
an object of $\mathbf{Ring}$ — in fact the
[*initial* object](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline),
since there is a
unique **ring homomorphism** $\mathbb{Z} \to R$ into any ring — a
function preserving $+$, $\times$, $0$, and $1$.
First
`intCommGroup` upgrades the additive group $(\mathbb{Z},+)$ to an abelian
group by supplying commutativity ($a + b = b + a$); then `intRing` adds the
multiplicative monoid $(\mathbb{Z}, \times, 1)$ and checks the distributive
laws $a(b+c) = ab + ac$ and $(a+b)c = ac + bc$. Each obligation is the named
$\mathbb{Z}$-arithmetic fact, so the term is the formal counterpart of
"$\mathbb{Z}$ is a commutative ring."

**Mathlib equivalent.** `Int` is already a [`CommRing`](https://loogle.lean-lang.org/?q=CommRing) instance, so there is no
`intRing`-style bundle to build. The obligations `intRing` checks by hand
are, again, generic lemmas that hold for every commutative ring:

```lean
example : CommRing Int := inferInstance

example (a b c : Int) : (a * b) * c = a * (b * c) := mul_assoc a b c
example (a : Int) : 1 * a = a := one_mul a
example (a : Int) : a * 1 = a := mul_one a
example (a b c : Int) : a * (b + c) = a * b + a * c := mul_add a b c
example (a b c : Int) : (a + b) * c = a * c + b * c := add_mul a b c
```

[`mul_add`](https://loogle.lean-lang.org/?q=mul_add)/[`add_mul`](https://loogle.lean-lang.org/?q=add_mul) are Mathlib's names for `left_distrib`/`right_distrib`.
They are the same laws, but stated generically over `[Ring R]` (or the weaker
`[Distrib R]`) instead of being cited per-type as `Int.mul_add`/`Int.add_mul`.

---

### References

Full citations in the [Bibliography](../bibliography.md). Formal
definitions are gathered in Recall, above.

- Dummit and Foote ([DummitFoote2003]), §7.3 "Ring Homomorphisms and Quotient Rings," p. 239 — ring homomorphism.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003

---

[← Ring](03-ring.md) | [Index](00-index.md) | [Next: Finite ring example →](05-finite-ring-example.md)
