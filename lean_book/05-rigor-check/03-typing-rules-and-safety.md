## Typing rules and safety

[← Universes](02-universes.md) | [Index](00-index.md) | [Next: Definitional vs propositional equality →](04-defeq-vs-propeq.md)

---

Chapters 1–4 have relied on Lean's type checking constantly without ever
seeing its rules written down. This section makes two things precise:
the actual rules Lean's kernel checks a term against (using a small,
representative fragment, the **simply typed λ-calculus**, STLC), and the
specific rule governing the universe hierarchy §2 just introduced
informally.

An untyped calculus has a serious defect: it permits terms that reduce
forever (Chapter 1 §4 mentioned β-reduction; nothing there stopped a term
from β-reducing to itself, endlessly), and nothing prevents applying one
kind of value where a completely different kind was intended. STLC fixes
this by attaching a **type** to every term and requiring application to
respect types — the direct ancestor of Chapter 1's "every expression has
a type."

### Types

$$
\tau ::= \iota \;\mid\; \tau \to \tau
$$

where $\iota$ ranges over some fixed collection of **base types** (think
`Nat`, `Bool`) and $\tau_1 \to \tau_2$ is the type of functions from
$\tau_1$ to $\tau_2$ — exactly Lean's `→`. Every type is built from base
types and arrows. There is not yet any way to quantify over *all* types
the way Chapter 1's `identity {α : Type} (x : α) : α := x` did — that
extra generality is exactly Chapter 1 §5's Π-types, already covered.

**Programmer's corner (Python), before the formal rules.** Python's own
type hints plus `mypy` are a light version of exactly this system, worth
seeing first since this Python tooling runs today, without any Lean
installation at all:

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
  never changes a term's type. This is *exactly* why this chapter's own
  definitional equality (§4, next) is trustworthy: reducing a term to
  normal form (what `#eval`/`rfl` do) can never accidentally produce
  something of a different type than the one it started with.

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

This is precisely the gap [Chapter 1 §5](../01-basics/05-pi-sigma-and-coc.md)
already closed: **dependent types** let a type itself depend on a term
(here, the type argument `α`). That is exactly the extra generality
`identity {α : Type} (x : α) : α := x` uses, and it is unavailable in STLC
(or in Python's `TypeVar`, which is real but considerably less powerful —
it cannot let a *return type* depend on an ordinary *value* argument the
way Chapter 1 §3's `Vec.replicate` does).

### Universes, as a typing rule

§2 introduced the hierarchy $\mathtt{Type} : \mathtt{Type}\,1 :
\mathtt{Type}\,2 : \cdots$ to avoid a Russell-style paradox (a "type of all
types" that contains itself leads to the same contradiction as "the set of
all sets that do not contain themselves"), and showed `Group : Type →
Type` had to live in `Type 1`. In the calculus of constructions — the
formal system CoC/CIC that Chapter 1 §5 named, extending STLC above with
Π-types and universes — this is stated as a typing rule for the universes
themselves:

$$
\dfrac{}{\mathtt{Type}\,i : \mathtt{Type}\,(i+1)}
$$

together with a rule saying Π-types (function types, including ordinary
`→`) stay inside a suitable universe:

$$
\dfrac{\Gamma \vdash A : \mathtt{Type}\,i \quad \Gamma, x:A \vdash B : \mathtt{Type}\,j}
      {\Gamma \vdash \big(\textstyle\prod_{x:A} B\big) : \mathtt{Type}\,(\max(i,j))}
$$

This is exactly §2's `Group : Type → Type` computation spelled out as a
general rule: with $A = \mathtt{Type}$ (itself living in `Type 1`) and
$B = \mathtt{Type}$ again, the rule gives $\max(1, 1) = 1$, so `Type →
Type` lands in `Type 1`, one level above `Type` itself.

**Programmer's corner (Python), on why this is genuinely a type-theory
concern and not a Python one.** In Python, `type(3)` is `int`, and
`type(int)` is `type` — and, unlike Lean's stratified hierarchy,
`type(type)` is *also* `type`:

```python
>>> type(3)
<class 'int'>
>>> type(int)
<class 'type'>
>>> type(type)
<class 'type'>
```

Python allows `type` to be its own type, with no stratification at all,
because Python's type system is not being used as a proof system — there
is no soundness property at stake that a Russell-style paradox could
break. Lean's `Type` cannot self-apply this way (`Type : Type` is
*inconsistent* — it allows encoding Girard's paradox and proving `False`),
which is exactly why the infinite, strictly increasing hierarchy above is
load-bearing rather than pedantry. This is one of the few places where the
Python comparison genuinely runs out: it is not that Python does the same
thing more simply, it is that Python does not need to solve this problem
at all, because nothing checks proofs against it.

---

### References

Full citations in the [Bibliography](../bibliography.md).

- Pierce ([Pierce2002]), Ch. 9–11 — the standard reference for STLC, including the (Var)/(Abs)/(App) rules and full proofs of progress and preservation, in the exact form used in this section.
- Milner ([Milner1978]) — the theoretical background for why STLC alone cannot type polymorphic functions like `identity`.
- Python `typing` module documentation and mypy documentation ([PythonTyping], [MypyDocs]) — for the Python-side comparison used in this section's boxes.
- Coquand and Huet ([CoquandHuet1988]) — the original paper defining CoC, whose universe-formation rule is stated above.
- Girard ([Girard1971]) — the source of "Girard's paradox," the inconsistency `Type : Type` would introduce.
- *Theorem Proving in Lean 4* ([TPIL4]), "Dependent Types" — Lean's own documentation on universes, matching the presentation here.

[Pierce2002]: ../bibliography.md#pierce2002
[Milner1978]: ../bibliography.md#milner1978
[PythonTyping]: ../bibliography.md#pythontyping
[MypyDocs]: ../bibliography.md#mypydocs
[CoquandHuet1988]: ../bibliography.md#coquandhuet1988
[Girard1971]: ../bibliography.md#girard1971
[TPIL4]: ../bibliography.md#tpil4

---

[← Universes](02-universes.md) | [Index](00-index.md) | [Next: Definitional vs propositional equality →](04-defeq-vs-propeq.md)
