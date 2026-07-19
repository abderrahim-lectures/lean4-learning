## `Ring`: bundling an additive `CommGroup` with multiplication

[← CommGroup](02-comm-group.md) | [Index](00-index.md) | [Next: Integers example →](04-integers-example.md)

---

<p><a href="https://live.lean-lang.org/#code=structure%20Ring%20%28R%20%3A%20Type%29%20where%0A%20%20addGrp%20%3A%20CommGroup%20R%0A%20%20mul%20%3A%20R%20%E2%86%92%20R%20%E2%86%92%20R%0A%20%20one%20%3A%20R%0A%20%20mul_assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20R%2C%20mul%20%28mul%20a%20b%29%20c%20%3D%20mul%20a%20%28mul%20b%20c%29%0A%20%20one_mul%20%3A%20%E2%88%80%20a%20%3A%20R%2C%20mul%20one%20a%20%3D%20a%0A%20%20mul_one%20%3A%20%E2%88%80%20a%20%3A%20R%2C%20mul%20a%20one%20%3D%20a%0A%20%20left_distrib%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20R%2C%20mul%20a%20%28addGrp.op%20b%20c%29%20%3D%20addGrp.op%20%28mul%20a%20b%29%20%28mul%20a%20c%29%0A%20%20right_distrib%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20R%2C%20mul%20%28addGrp.op%20a%20b%29%20c%20%3D%20addGrp.op%20%28mul%20a%20c%29%20%28mul%20b%20c%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Ring%20%28R%20%3A%20Type%29%20where%0A%20%20addGrp%20%3A%20CommGroup%20R%0A%20%20mul%20%3A%20R%20%E2%86%92%20R%20%E2%86%92%20R%0A%20%20one%20%3A%20R%0A%20%20mul_assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20R%2C%20mul%20%28mul%20a%20b%29%20c%20%3D%20mul%20a%20%28mul%20b%20c%29%0A%20%20one_mul%20%3A%20%E2%88%80%20a%20%3A%20R%2C%20mul%20one%20a%20%3D%20a%0A%20%20mul_one%20%3A%20%E2%88%80%20a%20%3A%20R%2C%20mul%20a%20one%20%3D%20a%0A%20%20left_distrib%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20R%2C%20mul%20a%20%28addGrp.op%20b%20c%29%20%3D%20addGrp.op%20%28mul%20a%20b%29%20%28mul%20a%20c%29%0A%20%20right_distrib%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20R%2C%20mul%20%28addGrp.op%20a%20b%29%20c%20%3D%20addGrp.op%20%28mul%20a%20c%29%20%28mul%20b%20c%29" title="Lean playground" loading="lazy" style="width:100%;height:231px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Consider each field in turn:

- `addGrp : CommGroup R` — the whole additive structure ($+$, $0$, unary
  minus, and commutativity) is a single field, itself a bundled structure.
  This is the "structures containing structures" pattern.
- `mul`, `one` — the multiplicative operation and its identity, `1`.
- `mul_assoc`, `one_mul`, `mul_one` — multiplication is associative and has
  a two-sided identity. Note, however, that `mul` is **not** required to be
  commutative or to have inverses. General rings need neither. (A
  commutative ring would add a `mul_comm` field, the same way `CommGroup`
  added `comm` to `Group`.)
- `left_distrib`, `right_distrib` — multiplication distributes over
  addition on both sides. Both are needed precisely because `mul` is not
  assumed to be commutative.

`addGrp.op` will be written constantly below; notation-free helper
abbreviations could be defined later. For now everything is spelled out so
each usage is traceable to the definition above.

**Mathematical reading.** `Ring R` is exactly the textbook definition of a
(unital, not-necessarily-commutative) ring, presented as a tuple
$$
\Big(\,(R,+,0,-)\in\mathbf{Ab},\ \cdot : R\times R\to R,\ 1\in R,\
\text{proofs of }(\mathrm{R2}),(\mathrm{R3}),(\mathrm{R4})\,\Big).
$$
The field `addGrp` is the *underlying additive abelian group*, so a ring is
"an abelian group $(R,+)$ carrying a compatible monoid structure
$(R,\cdot,1)$" — a monoid (a set with an associative operation and identity
element, i.e. a group without inverses). The remaining fields say
$(R,\cdot,1)$ is a monoid (`mul_assoc`, `one_mul`, `mul_one`) and that the
two operations interact through the two-sided distributive laws — that is,
multiplication is compatible with addition on both sides. Nesting `addGrp`
as a whole substructure mirrors the
[forgetful functor](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
$\mathbf{Ring}\to\mathbf{Ab}$ sending a ring to its additive group.

> Read more: Mathlib's `Ring` (`Mathlib.Algebra.Ring.Defs`) sits inside a
> much larger hierarchy — `Semiring`, `NonUnitalRing`, `CommRing`,
> `DivisionRing`, `Field` — each adding or dropping exactly one axiom
> compared to its neighbors; see [Chapter 13](../13-next-steps/02-moving-to-mathlib.md).
> For the classical (non-Lean) statement of these axioms and their
> standard consequences, Dummit & Foote's *Abstract Algebra* or Aluffi's
> *Algebra: Chapter 0* (the latter using the same categorical
> framing this book uses) are standard references.

### References

Full citations in the [Bibliography](../bibliography.md).

- Dummit and Foote ([DummitFoote2003]) — the standard classical (non-Lean) reference for the ring axioms (R1)–(R4) and their consequences.
- Aluffi ([Aluffi2009]) — a ring-theory treatment using the same categorical framing (forgetful functors, universal properties) this book uses.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003
[Aluffi2009]: ../bibliography.md#aluffi2009

---

[← CommGroup](02-comm-group.md) | [Index](00-index.md) | [Next: Integers example →](04-integers-example.md)
