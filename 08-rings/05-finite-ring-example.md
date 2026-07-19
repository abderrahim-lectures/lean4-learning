## Example: a finite commutative ring, $\mathbb{Z}/3\mathbb{Z}$

[← Integers example](04-integers-example.md) | [Index](00-index.md) | [Next: Accessing nested fields →](06-accessing-fields.md)

---

`intRing` is commutative, infinite, and — being $\mathbb{Z}$ itself — the
initial ring (Chapter 7's Theorem 1/2 hold for it as easily as
possible, since it has essentially the "obvious" ring structure).
[This chapter's matrix example](07-matrices.md) shows a genuinely *noncommutative* ring. This
section shows the other direction the axioms can specialize to: a
**commutative, finite** ring, small enough to check every axiom by direct
computation rather than by citing library lemmas.

### The carrier: `Fin 3`

`Fin 3` is Lean's type of "naturals less than 3," i.e. $\{0, 1, 2\}$. Its
built-in `+`/`*` already wrap around modulo 3, so `Fin 3`'s arithmetic
*is* $\mathbb{Z}/3\mathbb{Z}$'s arithmetic:

<p><a href="https://live.lean-lang.org/#code=%23eval%20%282%20%3A%20Fin%203%29%20%2B%202%20%20%20--%201%20%20%20%282%20%2B%202%20%3D%204%20%E2%89%A1%201%20mod%203%29%0A%23eval%20%282%20%3A%20Fin%203%29%20%2A%202%20%20%20--%201%20%20%20%282%20%2A%202%20%3D%204%20%E2%89%A1%201%20mod%203%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=%23eval%20%282%20%3A%20Fin%203%29%20%2B%202%20%20%20--%201%20%20%20%282%20%2B%202%20%3D%204%20%E2%89%A1%201%20mod%203%29%0A%23eval%20%282%20%3A%20Fin%203%29%20%2A%202%20%20%20--%201%20%20%20%282%20%2A%202%20%3D%204%20%E2%89%A1%201%20mod%203%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

### Building `Group (Fin 3)`, `CommGroup (Fin 3)`, `Ring (Fin 3)`

Because `Fin 3` has only three elements, every one of `Group`/`Ring`'s
axioms is a **finite, decidable** statement — literally "check this
equation holds for all $3$ (or $3^2$, or $3^3$) choices of its variables."
This is exactly the kind of goal Chapter 12 recommends handing to [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) rather
than proving by hand:

<p><a href="https://live.lean-lang.org/#code=def%20fin3Group%20%3A%20Group%20%28Fin%203%29%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20decide%0A%20%20id_left%20%3A%3D%20by%20decide%0A%20%20id_right%20%3A%3D%20by%20decide%0A%20%20inv_left%20%3A%3D%20by%20decide%0A%20%20inv_right%20%3A%3D%20by%20decide%0A%0Adef%20fin3CommGroup%20%3A%20CommGroup%20%28Fin%203%29%20where%0A%20%20toGroup%20%3A%3D%20fin3Group%0A%20%20comm%20%3A%3D%20by%20decide%0A%0Adef%20fin3Ring%20%3A%20Ring%20%28Fin%203%29%20where%0A%20%20addGrp%20%3A%3D%20fin3CommGroup%0A%20%20mul%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2A%20b%0A%20%20one%20%3A%3D%201%0A%20%20mul_assoc%20%3A%3D%20by%20decide%0A%20%20one_mul%20%3A%3D%20by%20decide%0A%20%20mul_one%20%3A%3D%20by%20decide%0A%20%20left_distrib%20%3A%3D%20by%20decide%0A%20%20right_distrib%20%3A%3D%20by%20decide" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20fin3Group%20%3A%20Group%20%28Fin%203%29%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20decide%0A%20%20id_left%20%3A%3D%20by%20decide%0A%20%20id_right%20%3A%3D%20by%20decide%0A%20%20inv_left%20%3A%3D%20by%20decide%0A%20%20inv_right%20%3A%3D%20by%20decide%0A%0Adef%20fin3CommGroup%20%3A%20CommGroup%20%28Fin%203%29%20where%0A%20%20toGroup%20%3A%3D%20fin3Group%0A%20%20comm%20%3A%3D%20by%20decide%0A%0Adef%20fin3Ring%20%3A%20Ring%20%28Fin%203%29%20where%0A%20%20addGrp%20%3A%3D%20fin3CommGroup%0A%20%20mul%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2A%20b%0A%20%20one%20%3A%3D%201%0A%20%20mul_assoc%20%3A%3D%20by%20decide%0A%20%20one_mul%20%3A%3D%20by%20decide%0A%20%20mul_one%20%3A%3D%20by%20decide%0A%20%20left_distrib%20%3A%3D%20by%20decide%0A%20%20right_distrib%20%3A%3D%20by%20decide" title="Lean playground" loading="lazy" style="width:100%;height:497px;border:1px solid #ccc;border-radius:8px;">
</iframe>

**Programmer's corner (Python).** `by decide` on a goal like `assoc` for
`Fin 3` is not magic. It is exactly what one would get from

```python
domain = range(3)
all((a + b) + c == a + (b + c) for a in domain for b in domain for c in domain)
```

brute-force enumerate every combination of the (finitely many) variables
and check the equation holds for each. The difference is not the algorithm,
but *where* the check lives. `all(...)` is a runtime assertion: it only
runs if some line of code calls it. If the call is omitted (or a
later refactor deletes it), Python never notices that the property
broke. `decide` instead runs as part of *type-checking* `fin3Group` itself.
The definition does not elaborate at all unless the brute-force check
succeeds, so there is no such thing as a `fin3Group` value that quietly
skipped its axiom checks. It is the same enumeration, but promoted from "a
test one hopes someone runs" to a condition the kernel enforces before the
value can even exist.

<p><a href="https://live.lean-lang.org/#code=%23eval%20fin3Ring.addGrp.op%202%202%20%20%20%20%20%20%20%20%20%20--%201%20%20%282%20%2B%202%20%3D%201%20mod%203%29%0A%23eval%20fin3Ring.mul%202%202%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%201%20%20%282%20%2A%202%20%3D%201%20mod%203%29%0A%23eval%20fin3Ring.addGrp.toGroup.inv%201%20%20%20%20%20--%202%20%20%28-1%20%3D%202%20mod%203%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=%23eval%20fin3Ring.addGrp.op%202%202%20%20%20%20%20%20%20%20%20%20--%201%20%20%282%20%2B%202%20%3D%201%20mod%203%29%0A%23eval%20fin3Ring.mul%202%202%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%201%20%20%282%20%2A%202%20%3D%201%20mod%203%29%0A%23eval%20fin3Ring.addGrp.toGroup.inv%201%20%20%20%20%20--%202%20%20%28-1%20%3D%202%20mod%203%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Compare this construction style directly with `intRing` (previous
section) and `mat2Ring` (next section): `intRing`'s axioms needed
`Int.add_assoc`-style library citations because `Int` is infinite. There
is no way to "check all cases" of a statement about *every* integer.
`Fin 3`'s axioms are statements about only finitely many (and
concretely enumerable) elements, so they can instead be handled by exhaustive
case-checking, which is exactly what `decide` automates. Recognizing which
regime a goal is in — infinite carrier needing a real argument, versus
finite carrier where brute enumeration is enough — is itself a useful
instinct to build. See Chapter 12 for more on when `decide` is (and is not)
the right tool.

**Mathematical reading.** `fin3Ring` is $\mathbb{Z}/3\mathbb{Z}$, the
finite field with three elements. Only the `Ring` structure has been built
here, though: a `Field` would additionally require every nonzero element
to be invertible under multiplication, true for $\mathbb{Z}/3$ precisely
because $3$ is prime, but this is not part of `Ring`'s axioms and not
checked here. `fin3Ring` is the quotient $\mathbb{Z}/(3)$ by the ideal
generated by $3$, with `Fin 3`'s built-in wraparound arithmetic giving
reduction mod $3$ directly at the level of the representation, rather than
through an explicit quotient construction.

**Mathlib equivalent.** Mathlib's [`ZMod 3`](https://loogle.lean-lang.org/?q=ZMod) *is* $\mathbb{Z}/3\mathbb{Z}$,
already known to be a commutative ring (in fact a field, since $3$ is
prime). There is no `fin3Group`/`fin3CommGroup`/`fin3Ring` bundle, and no `decide`
calls needed to re-verify axioms already proved once, generically, for
every `n`:

<p><a href="https://live.lean-lang.org/#code=example%20%3A%20CommRing%20%28ZMod%203%29%20%3A%3D%20inferInstance%0A%0A%23eval%20%282%20%3A%20ZMod%203%29%20%2B%202%20%20%20--%201%0A%23eval%20%282%20%3A%20ZMod%203%29%20%2A%202%20%20%20--%201" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%3A%20CommRing%20%28ZMod%203%29%20%3A%3D%20inferInstance%0A%0A%23eval%20%282%20%3A%20ZMod%203%29%20%2B%202%20%20%20--%201%0A%23eval%20%282%20%3A%20ZMod%203%29%20%2A%202%20%20%20--%201" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

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
