## Encoding data: Church numerals and booleans

[← Untyped λ-calculus](01-untyped-lambda-calculus.md) | [Index](00-index.md) | [Next: Simply typed λ-calculus →](03-simply-typed-lambda-calculus.md)

---

The untyped calculus has no built-in booleans or numbers. Chapter 1's
promise that `Nat` is "not a primitive but a defined inductive family" has
an even more extreme ancestor here: in the raw λ-calculus, *everything*,
including the natural numbers, is a function.

### Church booleans

Define:

$$
\mathrm{true} := \lambda x.\, \lambda y.\, x
\qquad
\mathrm{false} := \lambda x.\, \lambda y.\, y
$$

Notice $\mathrm{true}$ is exactly the term $K = \lambda x.\lambda y. x$
from the previous section's worked example: "take two arguments, return
the first." A boolean, in this encoding, *is* a choice function — to use
one, apply it to the two branches of an if-expression:

$$
\mathrm{if}\; b \;\mathrm{then}\; t \;\mathrm{else}\; e \;:=\; b\, t\, e
$$

Check: $\mathrm{true}\, t\, e = (\lambda x.\lambda y. x)\, t\, e
\longrightarrow_\beta t$ (discarding $e$), and symmetrically
$\mathrm{false}\, t\, e \longrightarrow_\beta e$. "If-then-else" is not a
primitive at all — it is just *application*, once booleans are represented
this way. This is why Lean's actual `Bool` (an `inductive`
with two constructors, per Chapter 1) is a *convenience*, not a
necessity — the calculus itself never needed a booleans primitive to
express conditional behavior.

### Church numerals

Represent the natural number $n$ as "apply a function $n$ times":

$$
\underline{0} := \lambda f.\, \lambda x.\, x
\qquad
\underline{1} := \lambda f.\, \lambda x.\, f\, x
\qquad
\underline{2} := \lambda f.\, \lambda x.\, f\,(f\, x)
\qquad
\underline{n} := \lambda f.\, \lambda x.\, f^n\, x
$$

Compare directly to Chapter 1's Peano definition
$\mathtt{Nat} ::= \mathtt{zero} \mid \mathtt{succ}(n)$: a Church numeral
$\underline{n}$ *is* "apply $\mathtt{succ}$, $n$ times, to $\mathtt{zero}$."
It is the same inductive shape, represented not as data but as a
higher-order function that knows how to iterate.

**Successor.** $\mathrm{succ} := \lambda n.\, \lambda f.\, \lambda x.\,
f\,(n\, f\, x)$ — "apply $f$ one more time than $n$ does":

$$
\mathrm{succ}\;\underline{1} = \lambda f.\lambda x.\, f\,(\underline{1}\, f\, x)
\longrightarrow_\beta \lambda f.\lambda x.\, f\,(f\,x) = \underline{2}
$$

**Addition.** $\mathrm{plus} := \lambda m.\lambda n.\lambda f.\lambda x.\,
m\, f\,(n\, f\, x)$ — "apply $f$, $m$ times, starting from where $n$
already applied it $n$ times." This is a direct computational reading of
$m + n$ = "count up from $n$, $m$ more times." It is the same recursive
definition of `Nat.add` that made `0 + n` and `n + 0` behave asymmetrically
throughout Chapter 4.

**Multiplication** is even more striking: $\mathrm{mult} := \lambda m.
\lambda n.\lambda f.\, m\,(n\, f)$ — "apply *'apply $f$, $n$ times'*, $m$
times." Multiplication is literally function composition, iterated.

### The point of this section

None of this is meant to suggest that one should ever program this way. It is
meant to show, concretely, that a system with only variables,
abstraction, and application already has the expressive power to build
booleans, naturals, and (by pairing constructions along the same lines)
arbitrary tree-shaped data — *before* any type system or `inductive`
keyword enters the picture. Lean's actual `Bool` and `Nat` (Chapter 1) are
built with the `inductive` mechanism instead of Church encodings, for
efficiency and because pattern-matching (`match`, [`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)) is far more
convenient to write and to reason about than repeated application. The
*expressiveness*, however, was never in question; the untyped calculus already
had it. What Lean's type system adds, starting in the next section, is not
more computational power but *guarantees* — ruling out terms that would
otherwise reduce forever, or apply a "boolean" where a "number" was meant.

## Next

Continue to [The simply typed λ-calculus](03-simply-typed-lambda-calculus.md).

---

[← Untyped λ-calculus](01-untyped-lambda-calculus.md) | [Index](00-index.md) | [Next: Simply typed λ-calculus →](03-simply-typed-lambda-calculus.md)
