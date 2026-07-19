## Theorem 2: $(-1) \cdot a = -a$

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Exercises →](04-exercises.md)

---

**Claim.**
`Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a = Rg.addGrp.toGroup.inv a`.

**Finding the proof.** This employs the same reduction move as Theorem 3
of Chapter 7: "show $x = -a$" is exactly the shape of
`left_inverse_unique`'s conclusion. Thus, instead of computing $(-1)\cdot a$
directly, we reduce the goal to verifying that $x$ is a left
additive-inverse of $a$, i.e. $((-1)\cdot a) + a = 0$. That target is now
purely about combining two products with a common right factor $a$, which
is what `right_distrib` (read backwards) is for:
$((-1)\cdot a) + (1 \cdot a) = ((-1) + 1)\cdot a$. Since $(-1) + 1 = 0$ (an
additive-group fact, `inv_left`) and $0 \cdot a = 0$ (the mirror of
Theorem 1 — see the exercises), the whole expression collapses.

Stated generally, the pattern to notice is this: **a goal of the form
`p * a + q * a = ...` is a `right_distrib` target waiting to happen, read
right-to-left**. Any additive expression of two products sharing a factor
should be scanned for this pattern before anything else is attempted.

The proof below requires $0\cdot a = 0$, the mirror image of Theorem 1
($a\cdot 0 = 0$), with `right_distrib` in place of `left_distrib`. We
therefore prove that first, mechanically mirroring Theorem 1's proof line
by line:

<p><a href="https://live.lean-lang.org/#code=theorem%20mul_zero_left%20%28a%20%3A%20R%29%20%3A%20Rg.mul%20Rg.addGrp.id%20a%20%3D%20Rg.addGrp.id%20%3A%3D%20by%0A%20%20have%20h0%20%3A%20Rg.addGrp.op%20Rg.addGrp.id%20Rg.addGrp.id%20%3D%20Rg.addGrp.id%20%3A%3D%0A%20%20%20%20Rg.addGrp.toGroup.id_left%20Rg.addGrp.id%0A%20%20have%20h1%20%3A%20Rg.mul%20%28Rg.addGrp.op%20Rg.addGrp.id%20Rg.addGrp.id%29%20a%20%3D%0A%20%20%20%20%20%20Rg.addGrp.op%20%28Rg.mul%20Rg.addGrp.id%20a%29%20%28Rg.mul%20Rg.addGrp.id%20a%29%20%3A%3D%0A%20%20%20%20Rg.right_distrib%20Rg.addGrp.id%20Rg.addGrp.id%20a%0A%20%20rw%20%5Bh0%5D%20at%20h1%0A%20%20have%20h2%20%3A%0A%20%20%20%20%20%20Rg.addGrp.op%20%28Rg.addGrp.toGroup.inv%20%28Rg.mul%20Rg.addGrp.id%20a%29%29%20%28Rg.mul%20Rg.addGrp.id%20a%29%20%3D%0A%20%20%20%20%20%20Rg.addGrp.op%20%28Rg.addGrp.toGroup.inv%20%28Rg.mul%20Rg.addGrp.id%20a%29%29%0A%20%20%20%20%20%20%20%20%28Rg.addGrp.op%20%28Rg.mul%20Rg.addGrp.id%20a%29%20%28Rg.mul%20Rg.addGrp.id%20a%29%29%20%3A%3D%0A%20%20%20%20congrArg%20%28Rg.addGrp.op%20%28Rg.addGrp.toGroup.inv%20%28Rg.mul%20Rg.addGrp.id%20a%29%29%29%20h1%0A%20%20rw%20%5BRg.addGrp.toGroup.inv_left%5D%20at%20h2%0A%20%20rw%20%5B%E2%86%90%20Rg.addGrp.toGroup.assoc%5D%20at%20h2%0A%20%20rw%20%5BRg.addGrp.toGroup.inv_left%5D%20at%20h2%0A%20%20rw%20%5BRg.addGrp.toGroup.id_left%5D%20at%20h2%0A%20%20exact%20h2.symm" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20mul_zero_left%20%28a%20%3A%20R%29%20%3A%20Rg.mul%20Rg.addGrp.id%20a%20%3D%20Rg.addGrp.id%20%3A%3D%20by%0A%20%20have%20h0%20%3A%20Rg.addGrp.op%20Rg.addGrp.id%20Rg.addGrp.id%20%3D%20Rg.addGrp.id%20%3A%3D%0A%20%20%20%20Rg.addGrp.toGroup.id_left%20Rg.addGrp.id%0A%20%20have%20h1%20%3A%20Rg.mul%20%28Rg.addGrp.op%20Rg.addGrp.id%20Rg.addGrp.id%29%20a%20%3D%0A%20%20%20%20%20%20Rg.addGrp.op%20%28Rg.mul%20Rg.addGrp.id%20a%29%20%28Rg.mul%20Rg.addGrp.id%20a%29%20%3A%3D%0A%20%20%20%20Rg.right_distrib%20Rg.addGrp.id%20Rg.addGrp.id%20a%0A%20%20rw%20%5Bh0%5D%20at%20h1%0A%20%20have%20h2%20%3A%0A%20%20%20%20%20%20Rg.addGrp.op%20%28Rg.addGrp.toGroup.inv%20%28Rg.mul%20Rg.addGrp.id%20a%29%29%20%28Rg.mul%20Rg.addGrp.id%20a%29%20%3D%0A%20%20%20%20%20%20Rg.addGrp.op%20%28Rg.addGrp.toGroup.inv%20%28Rg.mul%20Rg.addGrp.id%20a%29%29%0A%20%20%20%20%20%20%20%20%28Rg.addGrp.op%20%28Rg.mul%20Rg.addGrp.id%20a%29%20%28Rg.mul%20Rg.addGrp.id%20a%29%29%20%3A%3D%0A%20%20%20%20congrArg%20%28Rg.addGrp.op%20%28Rg.addGrp.toGroup.inv%20%28Rg.mul%20Rg.addGrp.id%20a%29%29%29%20h1%0A%20%20rw%20%5BRg.addGrp.toGroup.inv_left%5D%20at%20h2%0A%20%20rw%20%5B%E2%86%90%20Rg.addGrp.toGroup.assoc%5D%20at%20h2%0A%20%20rw%20%5BRg.addGrp.toGroup.inv_left%5D%20at%20h2%0A%20%20rw%20%5BRg.addGrp.toGroup.id_left%5D%20at%20h2%0A%20%20exact%20h2.symm" title="Lean playground" loading="lazy" style="width:100%;height:383px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Observe that this is Theorem 1's proof with every `left_distrib`/`a`
swapped for `right_distrib`/(argument order reversed). This confirms that
the "mirror image" claim is not merely a figure of speech, but a literal,
symmetrical match between the two proofs. The main theorem follows:

<p><a href="https://live.lean-lang.org/#code=theorem%20neg_one_mul%20%28a%20%3A%20R%29%20%3A%0A%20%20%20%20Rg.mul%20%28Rg.addGrp.toGroup.inv%20Rg.one%29%20a%20%3D%20Rg.addGrp.toGroup.inv%20a%20%3A%3D%20by%0A%20%20apply%20left_inverse_unique%20Rg.addGrp.toGroup%0A%20%20--%20Goal%3A%20op%20%28mul%20%28inv%20one%29%20a%29%20a%20%3D%20id%0A%20%20have%20step%20%3A%20Rg.addGrp.op%20%28Rg.mul%20%28Rg.addGrp.toGroup.inv%20Rg.one%29%20a%29%20a%20%3D%0A%20%20%20%20%20%20Rg.addGrp.op%20%28Rg.mul%20%28Rg.addGrp.toGroup.inv%20Rg.one%29%20a%29%20%28Rg.mul%20Rg.one%20a%29%20%3A%3D%0A%20%20%20%20congrArg%20%28Rg.addGrp.op%20%28Rg.mul%20%28Rg.addGrp.toGroup.inv%20Rg.one%29%20a%29%29%0A%20%20%20%20%20%20%28show%20a%20%3D%20Rg.mul%20Rg.one%20a%20from%20%28Rg.one_mul%20a%29.symm%29%0A%20%20rw%20%5Bstep%5D%0A%20%20--%20Goal%3A%20op%20%28mul%20%28inv%20one%29%20a%29%20%28mul%20one%20a%29%20%3D%20id%0A%20%20rw%20%5B%E2%86%90%20Rg.right_distrib%5D%0A%20%20--%20Goal%3A%20mul%20%28op%20%28inv%20one%29%20one%29%20a%20%3D%20id%0A%20%20rw%20%5BRg.addGrp.toGroup.inv_left%5D%0A%20%20--%20Goal%3A%20mul%20Rg.addGrp.id%20a%20%3D%20id%2C%20i.e.%200%20%2A%20a%20%3D%200%0A%20%20exact%20mul_zero_left%20Rg%20a" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20neg_one_mul%20%28a%20%3A%20R%29%20%3A%0A%20%20%20%20Rg.mul%20%28Rg.addGrp.toGroup.inv%20Rg.one%29%20a%20%3D%20Rg.addGrp.toGroup.inv%20a%20%3A%3D%20by%0A%20%20apply%20left_inverse_unique%20Rg.addGrp.toGroup%0A%20%20--%20Goal%3A%20op%20%28mul%20%28inv%20one%29%20a%29%20a%20%3D%20id%0A%20%20have%20step%20%3A%20Rg.addGrp.op%20%28Rg.mul%20%28Rg.addGrp.toGroup.inv%20Rg.one%29%20a%29%20a%20%3D%0A%20%20%20%20%20%20Rg.addGrp.op%20%28Rg.mul%20%28Rg.addGrp.toGroup.inv%20Rg.one%29%20a%29%20%28Rg.mul%20Rg.one%20a%29%20%3A%3D%0A%20%20%20%20congrArg%20%28Rg.addGrp.op%20%28Rg.mul%20%28Rg.addGrp.toGroup.inv%20Rg.one%29%20a%29%29%0A%20%20%20%20%20%20%28show%20a%20%3D%20Rg.mul%20Rg.one%20a%20from%20%28Rg.one_mul%20a%29.symm%29%0A%20%20rw%20%5Bstep%5D%0A%20%20--%20Goal%3A%20op%20%28mul%20%28inv%20one%29%20a%29%20%28mul%20one%20a%29%20%3D%20id%0A%20%20rw%20%5B%E2%86%90%20Rg.right_distrib%5D%0A%20%20--%20Goal%3A%20mul%20%28op%20%28inv%20one%29%20one%29%20a%20%3D%20id%0A%20%20rw%20%5BRg.addGrp.toGroup.inv_left%5D%0A%20%20--%20Goal%3A%20mul%20Rg.addGrp.id%20a%20%3D%20id%2C%20i.e.%200%20%2A%20a%20%3D%200%0A%20%20exact%20mul_zero_left%20Rg%20a" title="Lean playground" loading="lazy" style="width:100%;height:345px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Two features of the proof's shape are worth noting, both discovered by
actually compiling it:

- **No `apply Eq.symm` at the start.** The goal
  `Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a = Rg.addGrp.toGroup.inv a`
  already has the exact shape `left_inverse_unique` concludes
  (`b = Grp.inv a`, with `b` unifying to
  `Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a`). Flipping it with `Eq.symm`
  first produces the *wrong* shape, and `apply left_inverse_unique` then
  fails to unify. When `apply`ing a lemma whose conclusion is an equality,
  one should check which side is which *before* reaching for `Eq.symm`,
  rather than adding it automatically.
- **`congrArg`, not `conv_lhs => rw [...]`.** Plain `rw [h]` here would
  rewrite *every* occurrence of `a` in the goal, including the one inside
  `mul (inv one) a` that must stay put. This is exactly the same kind of
  problem as Theorem 1's `h2` on the previous page. `congrArg f h` avoids
  it by directly constructing "apply `f` to both sides of `h`" as its own
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
almost the same names:

<p><a href="https://live.lean-lang.org/#code=example%20%7BR%20%3A%20Type%2A%7D%20%5BRing%20R%5D%20%28a%20%3A%20R%29%20%3A%200%20%2A%20a%20%3D%200%20%3A%3D%20zero_mul%20a%0Aexample%20%7BR%20%3A%20Type%2A%7D%20%5BRing%20R%5D%20%28a%20%3A%20R%29%20%3A%20%28-1%20%3A%20R%29%20%2A%20a%20%3D%20-a%20%3A%3D%20neg_one_mul%20a" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%7BR%20%3A%20Type%2A%7D%20%5BRing%20R%5D%20%28a%20%3A%20R%29%20%3A%200%20%2A%20a%20%3D%200%20%3A%3D%20zero_mul%20a%0Aexample%20%7BR%20%3A%20Type%2A%7D%20%5BRing%20R%5D%20%28a%20%3A%20R%29%20%3A%20%28-1%20%3A%20R%29%20%2A%20a%20%3D%20-a%20%3A%3D%20neg_one_mul%20a" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

[`zero_mul`](https://loogle.lean-lang.org/?q=zero_mul) is `mul_zero_left`'s Mathlib name, and [`neg_one_mul`](https://loogle.lean-lang.org/?q=neg_one_mul) is exactly
Theorem 2. A multi-step derivation in the book (needing `mul_zero_left`,
`right_distrib`, and `left_inverse_unique` all at once) reduces to citing
one already-proved lemma.

---

[← Theorem 1](02-theorem-1.md) | [Index](00-index.md) | [Next: Exercises →](04-exercises.md)
