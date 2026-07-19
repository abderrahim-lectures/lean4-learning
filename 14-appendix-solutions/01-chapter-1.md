## Chapter 1: First steps

[← Index](00-index.md) | [Next: Chapter 3 →](02-chapter-3.md)

---

**1. β-reduce $(\lambda x.\lambda y.\, y\, x)\, a\, b$ and compare to $K$.**

Application associates to the left, so this is
$((\lambda x.\lambda y.\, y\, x)\, a)\, b$:
$$
(\lambda x.\lambda y.\, y\, x)\, a\, b
\;\longrightarrow_\beta\; (\lambda y.\, y\, a)\, b
\;\longrightarrow_\beta\; b\, a
$$
Step 1 substitutes $a$ for $x$ in $\lambda y.\, y\, x$, giving
$\lambda y.\, y\, a$. Step 2 substitutes $b$ for $y$ in $y\, a$, giving
$b\, a$.

The result is **not** simply one of the two inputs, the way $K$'s result
always is. $K\,a\,b \to_\beta a$ — $K$ *discards* its second argument and
returns the first, verbatim. Here, $(\lambda x.\lambda y.\, y\, x)\, a\, b
\to_\beta b\, a$ — both arguments survive, but with the *second* one
applied to the *first*. This term is sometimes called the "Thrush"
combinator ($T$, satisfying $T\, x\, y = y\, x$): it flips the order of
application rather than discarding anything, which is genuinely different
behavior from $K$, not just a relabeling of it.

**2. `Vec.toList : Vec α n → List α`**

<p><a href="https://live.lean-lang.org/#code=def%20Vec.toList%20%3A%20Vec%20%CE%B1%20n%20%E2%86%92%20List%20%CE%B1%0A%20%20%7C%20Vec.nil%20%3D%3E%20%5B%5D%0A%20%20%7C%20Vec.cons%20a%20rest%20%3D%3E%20a%20%3A%3A%20Vec.toList%20rest" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20Vec.toList%20%3A%20Vec%20%CE%B1%20n%20%E2%86%92%20List%20%CE%B1%0A%20%20%7C%20Vec.nil%20%3D%3E%20%5B%5D%0A%20%20%7C%20Vec.cons%20a%20rest%20%3D%3E%20a%20%3A%3A%20Vec.toList%20rest" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`Vec.replicate`'s type, `(n : Nat) → Vec α n`, is genuinely dependent: the
*return* type `Vec α n` mentions `n`, the value just supplied as the
argument. `Vec.toList`'s type, `Vec α n → List α`, is not — its return
type `List α` never mentions `n` at all, even though its *argument* type
happens to be dependent (`Vec α n`, one specific type per length). Taking
a dependently-typed *input* does not automatically make a function
dependent; what matters is whether the *output* type varies with the
input's *value*. `Vec.toList` throws the length away on the way out, the
same way `Vec α n`'s own length information disappears once converted to
a plain `List α`.

**3. A second `Σ n : Nat, Fin n`, and why `Σ n : Nat, n > 0` fails**

<p><a href="https://live.lean-lang.org/#code=def%20anotherSigma%20%3A%20%CE%A3%20n%20%3A%20Nat%2C%20Fin%20n%20%3A%3D%20%E2%9F%A85%2C%20%E2%9F%A80%2C%20by%20decide%E2%9F%A9%E2%9F%A9" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20anotherSigma%20%3A%20%CE%A3%20n%20%3A%20Nat%2C%20Fin%20n%20%3A%3D%20%E2%9F%A85%2C%20%E2%9F%A80%2C%20by%20decide%E2%9F%A9%E2%9F%A9" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

(`0 : Fin 5` is valid since $0 < 5$; any pair `⟨k, ⟨i, h⟩⟩` with `i < k`
works.) `Σ n : Nat, n > 0` fails to type-check because `n > 0 : Prop`
(`Sort 0`), while Lean's `Sigma` is declared as
`structure Sigma {α : Type u} (β : α → Type v)` — the second component's
*family* must land in some `Type v` (`Sort (v+1)` for `v ≥ 0`), which
`Prop` (`Sort 0`) is not. `Fin n : Type` clears that bar; `n > 0 : Prop`
does not. This is exactly why `∃` exists as `Sigma`'s `Prop`-restricted
cousin (Chapter 1 §5) rather than everyone just writing `Σ` everywhere.

**4. `Path.append`'s signature as nested Π-types**

`Path.append : {u v w : V} → Path Q u v → Path Q v w → Path Q u w`,
treating the implicit binders as outer Π's, unfolds one binder at a time:

| Level | $A$ | $B(\cdot)$ | Dependent? |
| --- | --- | --- | --- |
| 1 (binds $u$) | $V$ | $\prod_{v:V}\prod_{w:V} (\mathrm{Path}_Q\,u\,v \to \mathrm{Path}_Q\,v\,w \to \mathrm{Path}_Q\,u\,w)$ | Yes — mentions $u$ |
| 2 (binds $v$) | $V$ | $\prod_{w:V} (\mathrm{Path}_Q\,u\,v \to \mathrm{Path}_Q\,v\,w \to \mathrm{Path}_Q\,u\,w)$ | Yes — mentions $v$ |
| 3 (binds $w$) | $V$ | $\mathrm{Path}_Q\,u\,v \to \mathrm{Path}_Q\,v\,w \to \mathrm{Path}_Q\,u\,w$ | Yes — mentions $w$ |
| 4 (binds $p$) | $\mathrm{Path}_Q\,u\,v$ | $\mathrm{Path}_Q\,v\,w \to \mathrm{Path}_Q\,u\,w$ | No — constant in $p$ |
| 5 (binds $q$) | $\mathrm{Path}_Q\,v\,w$ | $\mathrm{Path}_Q\,u\,w$ | No — constant in $q$ |

The first three levels are genuinely dependent Π-types: each $B$ mentions
the vertex just bound, since it appears as an index into `Path` later in
the signature. The last two levels are Π-types that happen to collapse to
ordinary arrows: once $u, v, w$ are fixed, `Path Q u w`'s *type* no longer
depends on the specific *proof term* `p` or `q` supplied, only on the
vertices already bound — exactly the "$B(x)$ not depending on $x$"
collapse case from Chapter 1 §3/§5.

---

[← Index](00-index.md) | [Next: Chapter 3 →](02-chapter-3.md)
