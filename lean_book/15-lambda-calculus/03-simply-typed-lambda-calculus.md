## The simply typed λ-calculus

[← Church encodings](02-church-encodings.md) | [Index](00-index.md) | [Next: Dependent types and the calculus of constructions →](04-dependent-types-coc.md)

---

The untyped calculus has a serious defect: it lets you write terms that
reduce forever. $\Omega := (\lambda x.\, x\,x)(\lambda x.\, x\,x)$
β-reduces to itself, endlessly, so there is no normal form. Worse, nothing
stops you from applying a Church numeral where a Church boolean was
intended. The calculus has no notion of "well-formed" beyond the bare
grammar. The **simply typed λ-calculus** (STLC) fixes this by attaching a
**type** to every term and requiring application to respect types. This
is the direct ancestor of Chapter 1's "every expression has a type."

### Types

$$
\tau ::= \iota \;\mid\; \tau \to \tau
$$

where $\iota$ ranges over some fixed collection of **base types** (think
`Nat`, `Bool` from Chapter 1) and $\tau_1 \to \tau_2$ is the type of
functions from $\tau_1$ to $\tau_2$ — exactly Lean's `→`. Every type is
built from base types and arrows. There is not yet any way to quantify over
*all* types the way Chapter 1's `identity {α : Type} (x : α) : α := x` did.
That extra generality is exactly what's added in the next section.

### Typing judgments and rules

A **typing judgment** $\Gamma \vdash t : \tau$ reads "in context $\Gamma$
(a list of variable-type assignments $x_1:\tau_1, \ldots, x_n:\tau_n$), the
term $t$ has type $\tau$." This is precisely what Lean's `#check` reports,
and precisely the "context" that appears above the line in every tactic
goal state since Chapter 4. The rules that generate valid judgments:

$$
\dfrac{x : \tau \in \Gamma}{\Gamma \vdash x : \tau} \;\text{(Var)}
\qquad
\dfrac{\Gamma, x:\tau_1 \vdash t : \tau_2}{\Gamma \vdash \lambda x.\, t : \tau_1 \to \tau_2} \;\text{(Abs)}
\qquad
\dfrac{\Gamma \vdash t_1 : \tau_1 \to \tau_2 \quad \Gamma \vdash t_2 : \tau_1}{\Gamma \vdash t_1\, t_2 : \tau_2} \;\text{(App)}
$$

Reading each rule as a Lean fact you already know:

- **(Var)** — if `x`'s type is recorded in the local context, `#check x`
  reports that type. There's nothing to derive.
- **(Abs)** — to type-check `fun x => t`, extend the context with
  `x : τ1` (a fresh assumption, exactly like a hypothesis introduced by
  `intro` in Chapter 4), check that `t`'s type is `τ2` under that extended
  context, and conclude the whole abstraction has type `τ1 → τ2`. This
  *is* how Lean checks every `def f (x : τ1) : τ2 := t` you've written
  since Chapter 1.
- **(App)** — to type-check `t1 t2`, `t1` must have a function type whose
  domain matches `t2`'s type exactly; the result has the codomain type.
  This is exactly the error Chapter 4 discussed under "reading a tactic
  failure": `exact e` fails with a **type mismatch** precisely when this
  rule's side condition (that $\tau_1$ must match on both sides) isn't met.

### Type preservation and progress: the payoff

Two theorems about STLC are the entire reason to bother with a type
system at all:

- **Progress**: a well-typed closed term (no free variables) is either
  already a **value** — an abstraction, or (if base types come with their
  own constants, as `Nat`/`Bool` effectively do) a constant of a base type
  — or it can take a β-reduction step. It never "gets stuck" partway
  through evaluation. There's no well-typed analogue of "apply `3` to
  `true`," because (App)'s side condition would already have rejected
  such a term at elaboration time, before any reduction is attempted.
- **Preservation** (subject reduction): if $\Gamma \vdash t : \tau$ and
  $t \longrightarrow_\beta t'$, then $\Gamma \vdash t' : \tau$. Reduction
  never changes a term's type. This is *exactly* why Chapter 5's
  definitional equality is trustworthy: reducing a term to normal form
  (what `#eval`/`rfl` do) can never accidentally produce something of a
  different type than you started with.

Together, progress and preservation are the formal content of "well-typed
programs don't go wrong," and, viewed through Curry–Howard (Chapter 3),
"well-typed proof terms don't prove something other than what they claim
to prove." The entire reliability of Lean as a proof assistant rests on
an extended version of exactly these two theorems, proved once for Lean's
kernel and then trusted for every proof you ever check.

### What STLC still can't do

STLC cannot type `identity` from Chapter 1 *polymorphically*. You could
write `identity_Nat : Nat → Nat` and separately `identity_Bool : Bool → Bool`,
one arrow-type definition per base type. But there is no single term of a
single STLC type that captures "the identity function, at every type."
This is precisely the gap the next section closes: **dependent types** let
a type itself depend on a term (here, the type argument `α`). That is
exactly the extra generality `identity {α : Type} (x : α) : α := x` uses,
and it is unavailable in STLC as described above.

## Next

Continue to [Dependent types and the calculus of constructions](04-dependent-types-coc.md).

---

[← Church encodings](02-church-encodings.md) | [Index](00-index.md) | [Next: Dependent types and the calculus of constructions →](04-dependent-types-coc.md)
