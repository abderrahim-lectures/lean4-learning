## The simply typed λ-calculus

[← Church encodings](02-church-encodings.md) | [Index](00-index.md) | [Next: Dependent types and the calculus of constructions →](04-dependent-types-coc.md)

---

The untyped calculus has a serious defect: it permits terms that
reduce forever. $\Omega := (\lambda x.\, x\,x)(\lambda x.\, x\,x)$
β-reduces to itself, endlessly, so there is no normal form. Worse, nothing
prevents applying a Church numeral where a Church boolean was
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
That extra generality is exactly what is added in the next section.

**Programmer's corner (Python), before the formal rules.** Python's own
type hints plus `mypy` are a light version of exactly this system, worth
seeing first since it runs today, without any Lean installation at all:

```python
def apply_twice(f: int, x: int) -> int:  # pretend f is Callable[[int], int]
    ...

def to_str(n: int) -> str:
    return str(n)

# mypy accepts this: to_str's declared input type (int) matches what
# it is given (an int literal).
to_str(5)

# mypy rejects this with an error, WITHOUT running anything:
# error: Argument 1 to "to_str" has incompatible type "str"; expected "int"
to_str("already a string")
```

`mypy`'s check on `to_str("already a string")` is exactly the (App) rule
below, refusing to combine a function with an argument of the wrong type,
caught by reading the code rather than running it. The difference is that
Python's hints are optional and only checked when `mypy` is run at all;
Lean's type system is not optional, is checked on every single elaboration,
and is a real part of the language's meaning rather than an add-on linter.
STLC below is what is actually going on, underneath both.

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

Each rule, read as a Lean fact already familiar from earlier chapters:

- **(Var)** — if `x`'s type is recorded in the local context, `#check x`
  reports that type; there is nothing to derive.
- **(Abs)** — to type-check `fun x => t`, extend the context with
  `x : τ1` (a fresh assumption, exactly like a hypothesis introduced by
  [`intro`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) in Chapter 4), check that `t`'s type is `τ2` under that extended
  context, and conclude the whole abstraction has type `τ1 → τ2`. This
  *is* how Lean checks every `def f (x : τ1) : τ2 := t` written
  since Chapter 1.
- **(App)** — to type-check `t1 t2`, `t1` must have a function type whose
  domain matches `t2`'s type exactly; the result has the codomain type.
  This is exactly the error Chapter 4 discussed under "reading a tactic
  failure": [`exact`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) `e` fails with a **type mismatch** precisely when this
  rule's side condition (that $\tau_1$ must match on both sides) is not met.

### Type preservation and progress: the payoff

Two theorems about STLC are the entire reason to bother with a type
system at all:

- **Progress**: a well-typed closed term (no free variables) is either
  already a **value** — an abstraction, or (if base types come with their
  own constants, as `Nat`/`Bool` effectively do) a constant of a base type
  — or it can take a β-reduction step. It never "gets stuck" partway
  through evaluation. There is no well-typed analogue of "apply `3` to
  `true`," because (App)'s side condition would already have rejected
  such a term at elaboration time, before any reduction is attempted.
- **Preservation** (subject reduction): if $\Gamma \vdash t : \tau$ and
  $t \longrightarrow_\beta t'$, then $\Gamma \vdash t' : \tau$. Reduction
  never changes a term's type. This is *exactly* why Chapter 5's
  definitional equality is trustworthy: reducing a term to normal form
  (what `#eval`/`rfl` do) can never accidentally produce something of a
  different type than the one it started with.

Together, progress and preservation are the formal content of "well-typed
programs do not go wrong," and, viewed through Curry–Howard (Chapter 3),
"well-typed proof terms do not prove something other than what they claim
to prove." The entire reliability of Lean as a proof assistant rests on
an extended version of exactly these two theorems, proved once for Lean's
kernel and then trusted for every proof checked thereafter.

### What STLC still cannot do

STLC cannot type `identity` from Chapter 1 *polymorphically*. One could
write `identity_Nat : Nat → Nat` and separately `identity_Bool : Bool → Bool`,
one arrow-type definition per base type. But there is no single term of a
single STLC type that captures "the identity function, at every type."

**Programmer's corner (Python), on the same limitation.** Plain Python
never runs into this, because it has no static types to begin with — `def
identity(x): return x` already works on anything, at runtime, with zero
declarations. But the instant type hints are added, wanting `mypy` to
check the *general* claim "this returns whatever type it was given"
requires a dedicated feature, `TypeVar`, precisely because bare hints have
the same limitation as STLC:

```python
from typing import TypeVar
T = TypeVar("T")

def identity(x: T) -> T:   # one signature, valid at every type
    return x

identity(5)        # T := int
identity("hello")  # T := str
```

Without `TypeVar`, the only option would be writing `identity_int(x: int)
-> int` and `identity_str(x: str) -> str` separately — exactly STLC's
one-arrow-type-per-base-type wall. `TypeVar` is Python typing's escape
hatch for this specific gap, and it is a useful anchor: a much lighter
version of the same extra generality Lean's `identity {α : Type} (x : α) :
α := x` uses, where `α` is filled in silently every call, the same way
`mypy` silently solves `T := int` above.

This is precisely the gap the next section closes properly: **dependent
types** let a type itself depend on a term (here, the type argument `α`).
That is exactly the extra generality `identity {α : Type} (x : α) : α := x`
uses, and it is unavailable in STLC (or in Python's `TypeVar`, which is
real but considerably less powerful — it cannot let a *return type* depend
on an ordinary *value* argument the way Chapter 1 §3's `Vec.replicate`
does) as described above.

## Next

Continue to [Dependent types and the calculus of constructions](04-dependent-types-coc.md).

---

### References

- Benjamin C. Pierce, *[Types and Programming Languages](https://www.cis.upenn.edu/~bcpierce/tapl/)*, MIT Press, 2002, Ch. 9–11 — the standard reference for STLC, including the (Var)/(Abs)/(App) rules and full proofs of progress and preservation, in the exact form used in this section.
- Robin Milner, "[A Theory of Type Polymorphism in Programming](https://doi.org/10.1016/0022-0000(78)90014-4)," *Journal of Computer and System Sciences*, 17(3), 1978, 348–375 — the theoretical background for why STLC alone cannot type polymorphic functions like `identity`, motivating the extension the next section makes.
- Python `typing` module documentation, [`TypeVar`](https://docs.python.org/3/library/typing.html#typing.TypeVar), and the [mypy documentation](https://mypy.readthedocs.io/) — for the Python-side comparison used in this section's boxes.

---

[← Church encodings](02-church-encodings.md) | [Index](00-index.md) | [Next: Dependent types and the calculus of constructions →](04-dependent-types-coc.md)
