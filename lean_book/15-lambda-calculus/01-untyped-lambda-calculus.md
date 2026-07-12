## Untyped λ-calculus: terms and reduction

[← Standard logic recap](00-standard-logic.md) | [Index](00-index.md) | [Next: Church encodings →](02-church-encodings.md)

---

### The grammar

The **untyped λ-calculus** has exactly three ways to build a term:

$$
t ::= x \;\mid\; \lambda x.\, t \;\mid\; t\, t
$$

- $x$ — a **variable**.
- $\lambda x.\, t$ — an **abstraction**: a function of one argument $x$,
  with body $t$. This is *exactly* Lean's `fun x => t`.
- $t_1\, t_2$ — an **application**: applying $t_1$ to the argument $t_2$.
  This is exactly Lean's `t1 t2` (juxtaposition, no special syntax needed —
  you've been writing applications since Chapter 1's `double 5`).

That's the entire grammar. No numbers, no booleans, no `if`, no
recursion. As you'll see in the next section, every one of those is
*encoded* as a term built from only these three constructs. This is why
the λ-calculus is a genuine foundational calculus, not just "a programming
language with functions in it": functions are the *only* primitive, and
everything else is built from them.

### Free and bound variables

In $\lambda x.\, t$, occurrences of $x$ inside $t$ are **bound** by the
$\lambda$. Any other variable appearing in $t$ is **free**. For instance in
$\lambda x.\, x\, y$, the $x$ is bound and $y$ is free. This is exactly
Lean's ordinary lexical scoping: `fun x => x + y` binds `x` in its body
and leaves `y` referring to whatever `y` means in the surrounding context
(a `variable`, an outer `fun`, etc.), precisely as in Chapter 1.

### α-conversion: bound names don't matter

$\lambda x.\, x$ and $\lambda y.\, y$ are considered **the same term**.
Renaming a bound variable (consistently, avoiding capture) changes nothing.
This is called **α-conversion** (alpha-conversion). It is why, in Lean, you
never need to worry that someone else's proof used `fun a => a` while
yours uses `fun x => x`: they're the identical term, α-equivalent, and
Lean's elaborator treats them as interchangeable without comment.

### β-reduction: the one computation rule

The single computational rule of the λ-calculus is **β-reduction**
(beta-reduction): applying an abstraction to an argument substitutes the
argument for the bound variable.

$$
(\lambda x.\, t)\, s \;\longrightarrow_\beta\; t[x := s]
$$

read "$t$ with $s$ substituted for (every free occurrence of) $x$." This
is *precisely* what Chapter 5 called **definitional equality** driven by
"beta-reduction." The term `(fun x => x * 2) 5` reduces, by exactly this
rule, to `5 * 2`, and Lean's `rfl` succeeds whenever both sides of an
equation reduce (via zero or more β-steps, plus unfolding `def`s) to the
same term. A term with no more β-reductions available is in **normal
form**. `#eval`, from Chapter 1, is precisely "reduce this term to normal
form and print it."

**Programmer's corner (Python).** Python has its own `lambda` keyword, and
on simple examples it really does β-reduce exactly like the calculus above:
`(lambda x: x + 1)(5)` reduces to `5 + 1` to `6`, the same substitution step
as $(\lambda x.\, x + 1)\, 5 \to_\beta 5 + 1$. But Python's `lambda` is a
deliberately limited subset of $\lambda x.\, t$: the body `t` must be a
single *expression* — no `if` statements, no `for` loops, no multiple
statements, no `return`. Anything with real control flow needs `def`
instead, and that is not the same kind of thing at all (`def` binds a name
via a statement; `lambda` produces a value). The actual untyped λ-calculus
has no such restriction, because it doesn't need one: `if`, loops, and
recursion are, as the next section shows, just more terms built from
$\lambda$ and application, not separate language features bolted on top.
So where Python drew a line — "expressions get a terse `lambda`, everything
else needs `def`" — the λ-calculus (and Lean's `fun`, which imposes no such
restriction either) never needed to. In the calculus, functions already
are the entire language.

**Worked example.** Reduce $(\lambda x.\, \lambda y.\, x)\, a\, b$
(application associates to the left, so this is
$((\lambda x.\, \lambda y.\, x)\, a)\, b$):

$$
(\lambda x.\, \lambda y.\, x)\, a\, b
\;\longrightarrow_\beta\; (\lambda y.\, a)\, b
\;\longrightarrow_\beta\; a
$$

The first step substitutes $a$ for $x$ in $\lambda y.\, x$, giving
$\lambda y.\, a$. Note that $a$ is now a *free* variable inside this
abstraction — it doesn't depend on $y$ at all, since the original body was
just $x$, renamed nothing. The second step substitutes $b$ for $y$ in a
body that doesn't mention $y$, so it just discards $b$ and leaves $a$.
This particular term — $\lambda x.\, \lambda y.\, x$, "take two arguments,
return the first, discard the second" — is important enough to have its
own name, `K`, and it becomes `Bool.true`'s implementation, coming up in
the next section.

### Curried, always

Every abstraction takes exactly *one* argument. A "two-argument function"
$\lambda x.\, \lambda y.\, t$ is a function returning a function. This is
exactly the **currying** you've relied on silently since Chapter 1:
`Nat → Nat → Nat` is genuinely `Nat → (Nat → Nat)`, one argument at a time,
because the underlying calculus has no other option. There is no extra
feature making multi-argument functions work in Lean; it is currying, all
the way down, exactly as in the untyped calculus.

### Church–Rosser: reduction order doesn't matter (for the final answer)

If a term has more than one β-redex (a reducible sub-term
$(\lambda x. t)\, s$), which one you reduce first is a genuine choice.
But the **Church–Rosser theorem** guarantees that if a term reduces to a
normal form at all, that normal form is unique, no matter what order the
reductions were taken in to reach it. This is the theoretical bedrock
under a fact you rely on constantly without noticing: Lean never has to
worry that elaborating an expression "the wrong order" would produce a
different answer than elaborating it "the right order." Confluence
guarantees there isn't a wrong order, only faster or slower ones.

## Next

Continue to [Church encodings](02-church-encodings.md), where we build
booleans, naturals, and pairs — the same ideas as Lean's actual
`Bool`/`Nat`/`Pair` (Chapters 1–2) — using nothing but $\lambda$,
application, and variables.

---

[← Index](00-index.md) | [Next: Church encodings →](02-church-encodings.md)
