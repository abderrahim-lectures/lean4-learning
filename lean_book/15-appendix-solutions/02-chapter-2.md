## Chapter 2: Terminology and the calculus of constructions

[← Chapter 1](01-chapter-1.md) | [Index](00-index.md) | [Next: Chapter 3 →](03-chapter-3.md)

---

**1. β-reduce $(\lambda x.\lambda y.\, y\, x)\, a\, b$ and compare to $K$.**

Application associates to the left, so this is
$((\lambda x.\lambda y.\, y\, x)\, a)\, b$.
$$
(\lambda x.\lambda y.\, y\, x)\, a\, b
\;\longrightarrow_\beta\; (\lambda y.\, y\, a)\, b
\;\longrightarrow_\beta\; b\, a
$$
Step 1 substitutes $a$ for $x$ in $\lambda y.\, y\, x$, giving
$\lambda y.\, y\, a$. Step 2 substitutes $b$ for $y$ in $y\, a$, giving
$b\, a$.

The result is **not** simply one of the two inputs, the way the result of $K$
always is. $K\,a\,b \to_\beta a$. $K$ *discards* its second argument and
returns the first, verbatim. Here, $(\lambda x.\lambda y.\, y\, x)\, a\, b
\to_\beta b\, a$. Both arguments survive, but with the *second* one
applied to the *first*. This term is sometimes called the "Thrush"
combinator ($T$, satisfying $T\, x\, y = y\, x$), it flips the order of
application rather than discarding anything, which is genuinely different
behavior from $K$, not just a relabeling of it.

**2. A second `Σ n : Nat, Fin n`, and why `Σ n : Nat, n > 0` fails**

```lean
def anotherSigma : Σ n : Nat, Fin n := ⟨5, ⟨0, by decide⟩⟩
```

(`0 : Fin 5` is valid since $0 < 5$; any pair `⟨k, ⟨i, h⟩⟩` with `i < k`
works.) `Σ n : Nat, n > 0` fails to type-check because `n > 0 : Prop`
(`Sort 0`), while `Sigma` in Lean is declared as
`structure Sigma {α : Type u} (β : α → Type v)`. The *family* of the second component must land in some `Type v` (`Sort (v+1)` for `v ≥ 0`), which
`Prop` (`Sort 0`) is not. `Fin n : Type` clears that bar; `n > 0 : Prop`
does not. This is exactly why `∃` exists as the `Prop`-restricted
cousin of `Sigma` (Chapter 2, Section 2) rather than everyone just writing `Σ` everywhere.

**3. The signature of `Path.append` as nested Π-types**

`Path.append : {u v w : V} → Path Q u v → Path Q v w → Path Q u w`,
treating the implicit binders as outer Π's, unfolds one binder at a time.

| Level | $A$ | $B(\cdot)$ | Dependent? |
| --- | --- | --- | --- |
| 1 (binds $u$) | $V$ | $\prod_{v:V}\prod_{w:V} (\mathrm{Path}_Q\,u\,v \to \mathrm{Path}_Q\,v\,w \to \mathrm{Path}_Q\,u\,w)$ | Yes, mentions $u$ |
| 2 (binds $v$) | $V$ | $\prod_{w:V} (\mathrm{Path}_Q\,u\,v \to \mathrm{Path}_Q\,v\,w \to \mathrm{Path}_Q\,u\,w)$ | Yes, mentions $v$ |
| 3 (binds $w$) | $V$ | $\mathrm{Path}_Q\,u\,v \to \mathrm{Path}_Q\,v\,w \to \mathrm{Path}_Q\,u\,w$ | Yes, mentions $w$ |
| 4 (binds $p$) | $\mathrm{Path}_Q\,u\,v$ | $\mathrm{Path}_Q\,v\,w \to \mathrm{Path}_Q\,u\,w$ | No, constant in $p$ |
| 5 (binds $q$) | $\mathrm{Path}_Q\,v\,w$ | $\mathrm{Path}_Q\,u\,w$ | No, constant in $q$ |

The first three levels are genuinely dependent Π-types, each $B$ mentions
the vertex just bound, since it appears as an index into `Path` later in
the signature. The last two levels are Π-types that happen to collapse to
ordinary arrows, once $u, v, w$ are fixed, the *type* of `Path Q u w` no longer
depends on the specific *proof term* `p` or `q` supplied, only on the
vertices already bound, exactly the "$B(x)$ not depending on $x$"
collapse case from Chapter 2, Sections 1/2.

---

[← Chapter 1](01-chapter-1.md) | [Index](00-index.md) | [Next: Chapter 3 →](03-chapter-3.md)
