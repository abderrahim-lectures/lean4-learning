## Typing rules and safety

[← Universes](02-universes.md) | [Index](00-index.md) | [Next: Definitional vs propositional equality →](04-defeq-vs-propeq.md)

---

Section 2 showed *informally* why `Group : Type → Type` has to live one
universe level up, by walking through that one specific case in prose.
That argument leaned on a typing rule it never actually stated, and
Chapters 1–5 have relied on the type checking of Lean constantly the same
way, without ever seeing its rules written down. This section makes two things precise.
the actual rules the kernel of Lean checks a term against (using a small,
representative fragment, the **simply typed λ-calculus**, STLC), and the
specific rule governing the universe hierarchy Section 2 just introduced
informally.

An untyped calculus has a serious defect. It permits terms that reduce
forever (Chapter 2, Section 1 mentioned β-reduction; nothing there stopped a term
from β-reducing to itself, endlessly), and nothing prevents applying one
kind of value where a completely different kind was intended. STLC fixes
this by attaching a **type** to every term and requiring application to
respect types. This is the direct ancestor of "every expression has
a type" from Chapter 1.

### Types

$$
\tau ::= \iota \;\mid\; \tau \to \tau
$$

Here $\iota$ ranges over some fixed collection of **base types** (think
`Nat`, `Bool`) and $\tau_1 \to \tau_2$ is the type of functions from
$\tau_1$ to $\tau_2$, exactly the `→` of Lean. Every type is built from base
types and arrows. There is not yet any way to quantify over *all* types
the way `identity {α : Type} (x : α) : α := x` did in Chapter 1. That
extra generality is exactly the Π-types of Chapter 2, Section 2, already covered.

**Programmer's corner (Python), before the formal rules.** The
type hints of Python plus `mypy` are a light version of exactly this system, worth
seeing first since this Python tooling runs today, without any Lean
installation at all.

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

The check `mypy` runs on `to_str("already a string")` is exactly the (App) rule
below, refusing to combine a function with an argument of the wrong type,
caught by reading the code rather than running it. The difference is that
the hints in Python are optional and only checked when `mypy` is run at all.
The type system in Lean is not optional, is checked on every single elaboration,
and is a real part of the meaning of the language rather than an add-on linter.
STLC below is what is actually going on, underneath both.

### Typing judgments and rules

A **typing judgment** $\Gamma \vdash t : \tau$ reads "in context $\Gamma$
(a list of variable-type assignments $x_1:\tau_1, \ldots, x_n:\tau_n$), the
term $t$ has type $\tau$." This is precisely what `#check` reports in Lean,
and precisely the "context" that appears above the line in every tactic
goal state since Chapter 5. The rules that generate valid judgments are as follows.

$$
\dfrac{x : \tau \in \Gamma}{\Gamma \vdash x : \tau} \;\text{(Var)}
\qquad
\dfrac{\Gamma, x:\tau_1 \vdash t : \tau_2}{\Gamma \vdash \lambda x.\, t : \tau_1 \to \tau_2} \;\text{(Abs)}
\qquad
\dfrac{\Gamma \vdash t_1 : \tau_1 \to \tau_2 \quad \Gamma \vdash t_2 : \tau_1}{\Gamma \vdash t_1\, t_2 : \tau_2} \;\text{(App)}
$$

Each rule, read as a Lean fact already familiar from earlier chapters.

- **(Var)**: if the type of `x` is recorded in the local context, `#check x`
  reports that type; there is nothing to derive.
- **(Abs)**: to type-check `fun x => t`, extend the context with
  `x : τ1` (a fresh assumption, exactly like a hypothesis introduced by
  [`intro`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) in Chapter 5), check that the type of `t` is `τ2` under that extended
  context, and conclude the whole abstraction has type `τ1 → τ2`. This
  *is* how Lean checks every `def f (x : τ1) : τ2 := t` written
  since Chapter 1.
- **(App)**: to type-check `t1 t2`, `t1` must have a function type whose
  domain matches the type of `t2` exactly; the result has the codomain type.
  This is exactly the error discussed in Chapter 5 under "reading a tactic
  failure." [`exact`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) `e` fails with a **type mismatch** precisely when the
  side condition of this rule (that $\tau_1$ must match on both sides) is not met.

### Type preservation and progress: the payoff

Two theorems about STLC are the entire reason to bother with a type
system at all.

- **Progress**: a well-typed closed term (no free variables) is either
  already a **value**, an abstraction, or (if base types come with their
  own constants, as `Nat`/`Bool` effectively do) a constant of a base type,
  or it can take a β-reduction step. It never "gets stuck" partway
  through evaluation. There is no well-typed analogue of "apply `3` to
  `true`," because the side condition of (App) would already have rejected
  such a term at elaboration time, before any reduction is attempted.
- **Preservation** (subject reduction): if $\Gamma \vdash t : \tau$ and
  $t \longrightarrow_\beta t'$, then $\Gamma \vdash t' : \tau$. Reduction
  never changes the type of a term. This is *exactly* why the definitional
  equality of this chapter (Section 4, next) is trustworthy. Reducing a term to
  normal form (what `#eval`/`rfl` do) can never accidentally produce
  something of a different type than the one it started with.

Together, progress and preservation are the formal content of "well-typed
programs do not go wrong," and, viewed through Curry–Howard (Chapter 4),
"well-typed proof terms do not prove something other than what they claim
to prove." The entire reliability of Lean as a proof assistant rests on
an extended version of exactly these two theorems, proved once for the
kernel of Lean and then trusted for every proof checked thereafter.

### What STLC still cannot do

STLC cannot type `identity` from Chapter 1 *polymorphically*. One could
write `identity_Nat : Nat → Nat` and separately `identity_Bool : Bool → Bool`,
one arrow-type definition per base type. But there is no single term of a
single STLC type that captures "the identity function, at every type."

**Programmer's corner (Python), on the same limitation.** Plain Python
never runs into this, because it has no static types to begin with. `def
identity(x): return x` already works on anything, at runtime, with zero
declarations. But the instant type hints are added, wanting `mypy` to
check the *general* claim "this returns whatever type it was given"
requires a dedicated feature, `TypeVar`, precisely because bare hints have
the same limitation as STLC.

```python
from typing import TypeVar
T = TypeVar("T")

def identity(x: T) -> T:   # one signature, valid at every type
    return x

identity(5)        # T := int
identity("hello")  # T := str
```

Without `TypeVar`, the only option would be writing `identity_int(x: int)
-> int` and `identity_str(x: str) -> str` separately, exactly the
one-arrow-type-per-base-type wall of STLC. `TypeVar` is the escape
hatch in Python typing for this specific gap, and it is a useful anchor. It is a much lighter
version of the same extra generality that `identity {α : Type} (x : α) :
α := x` uses in Lean, where `α` is filled in silently every call, the same way
`mypy` silently solves `T := int` above.

This is precisely the gap already closed by [Chapter 2, Section 2](../02-terminology-and-coc/02-pi-sigma-and-coc.md).
**Dependent types** let a type itself depend on a term
(here, the type argument `α`). That is exactly the extra generality
`identity {α : Type} (x : α) : α := x` uses, and it is unavailable in STLC
(or in the `TypeVar` of Python, which is real but considerably less powerful.
It cannot let a *return type* depend on an ordinary *value* argument the
way `Vec.replicate` does in Chapter 1, Section 3).

### Universes, as a typing rule

Section 2 introduced the hierarchy $\mathtt{Type} : \mathtt{Type}\,1 :
\mathtt{Type}\,2 : \cdots$ to avoid a Russell-style paradox (a "type of all
types" that contains itself leads to the same contradiction as "the set of
all sets that do not contain themselves"), and showed `Group : Type →
Type` had to live in `Type 1`. In the calculus of constructions, the
formal system CoC/CIC named by Chapter 2, Section 2, extending STLC above with
Π-types and universes, this is stated as a typing rule for the universes
themselves.

$$
\dfrac{}{\mathtt{Type}\,i : \mathtt{Type}\,(i+1)}
$$

together with a rule saying Π-types (function types, including ordinary
`→`) stay inside a suitable universe.

$$
\dfrac{\Gamma \vdash A : \mathtt{Sort}\,i \quad \Gamma, x:A \vdash B : \mathtt{Sort}\,j}
      {\Gamma \vdash \big(\textstyle\prod_{x:A} B\big) : \mathtt{Sort}\,(\mathrm{imax}(i,j))}
$$

Here $\mathrm{imax}(i, j) = j$ when $j = 0$, and $\max(i, j)$ otherwise, and
`Sort 0` is `Prop` and `Sort (k+1)` is `Type k` (Chapter 2, Section 2).

For $j > 0$, the case where $B$ is genuinely a type rather than a
proposition, $\mathrm{imax}$ *is* $\max$, and the rule is exactly the
`Group : Type → Type` computation of Section 2 spelled out generally: with
$A = \mathtt{Type}$ (itself living in `Type 1`) and $B = \mathtt{Type}$ again,
the rule gives $\max(1, 1) = 1$, so `Type → Type` lands in `Type 1`, one level
above `Type` itself.

The $j = 0$ case is not a footnote. It is what makes `∀` usable at all. When
$B$ lands in `Prop`, the whole Π-type is a `Prop` *regardless of how large $A$
is*. This is the **impredicativity of `Prop`**, and it is why
`∀ n : Nat, n ≥ 0` is a proposition you can prove rather than an inhabitant of
`Type 1`.

```lean
#check (∀ n : Nat, n ≥ 0)   -- ∀ (n : Nat), n ≥ 0 : Prop
#check (Type → Type)        -- Type → Type : Type 1
```

Had the rule been $\max$ throughout, the first of these would have landed in
`Type 1` (since $\mathtt{Nat} : \mathtt{Type}\,0 = \mathtt{Sort}\,1$ and
$n \ge 0 : \mathtt{Sort}\,0$ give $\max(1,0) = 1$), and every `∀`-statement in
Chapters 3 through 11 would be a type rather than a theorem.

**Programmer's corner (Python), on why this is genuinely a type-theory
concern and not a Python one.** In Python, `type(3)` is `int`, and
`type(int)` is `type`, and, unlike the stratified hierarchy in Lean,
`type(type)` is *also* `type`.

```python
>>> type(3)
<class 'int'>
>>> type(int)
<class 'type'>
>>> type(type)
<class 'type'>
```

Python allows `type` to be its own type, with no stratification at all,
because the type system of Python is not being used as a proof system. There
is no soundness property at stake that a Russell-style paradox could
break. `Type` in Lean cannot self-apply this way (`Type : Type` is
*inconsistent*. It allows encoding Girard's paradox and proving `False`),
which is exactly why the infinite, strictly increasing hierarchy above is
load-bearing rather than pedantry. This is one of the few places where the
Python comparison genuinely runs out. It is not that Python does the same
thing more simply, it is that Python does not need to solve this problem
at all, because nothing checks proofs against it.

---

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Progress (Theorem 9.3.5).** "Suppose $t$ is a closed, well-typed
  term (that is, $\vdash t : T$ for some $T$). Then either $t$ is a
  value or else there is some $t'$ with $t \to t'$" ([Pierce2002],
  §9.3 "Properties of Typing").
- **Preservation (Theorem 9.3.9).** "If $\Gamma \vdash t : T$ and
  $t \to t'$, then $\Gamma \vdash t' : T$" ([Pierce2002], §9.3).
- **Universe-formation rule.** The working statement used by this book, after
  the calculus of constructions ([CoquandHuet1988]):
  $\mathtt{Type}\,i : \mathtt{Type}\,(i+1)$, and a Π-type built from
  $A : \mathtt{Sort}\,i$, $B : \mathtt{Sort}\,j$ lands in
  $\mathtt{Sort}\,(\mathrm{imax}(i,j))$. The $j = 0$ clause is the
  impredicativity of `Prop`, which the calculus of constructions is
  characterized by and which [TPIL4] §2.2 documents for Lean specifically.
- Pierce ([Pierce2002]), Ch. 9 "Typed Arithmetic Expressions" §8.3 "Safety = Progress + Preservation" (Theorems 8.3.2/8.3.3, first proved there for a smaller language) and Ch. 10 "Simply Typed Lambda-Calculus" §9.2 "The Typing Relation" (the (T-Var)/(T-Abs)/(T-App) rules) and §9.3 "Properties of Typing" (Theorems 9.3.5/9.3.9, progress/preservation restated for STLC), verified verbatim. An earlier draft of this section cited Ch. 10–11; Ch. 12 "Simple Extensions" actually covers pairs/tuples/records/sums, unrelated to the content of this section.
- Milner ([Milner1978]) covers the theoretical background for why STLC alone cannot type polymorphic functions like `identity`.
- Python `typing` module documentation and mypy documentation ([PythonTyping], [MypyDocs]) cover the Python-side comparison used in the boxes of this section.
- Girard: see [the references of Chapter 6, Section 2](02-universes.md) for the full citation. "Girard's paradox" (the inconsistency of `Type : Type`) is due to the 1972 thesis of Girard, a different, later paper than [Girard1971] cited elsewhere in this book.
- *Theorem Proving in Lean 4* ([TPIL4]), §2.2 "Types as objects" is the Lean documentation on universes, matching the presentation here.

[Pierce2002]: ../bibliography.md#pierce2002
[Milner1978]: ../bibliography.md#milner1978
[PythonTyping]: ../bibliography.md#pythontyping
[MypyDocs]: ../bibliography.md#mypydocs
[CoquandHuet1988]: ../bibliography.md#coquandhuet1988
[Girard1971]: ../bibliography.md#girard1971
[TPIL4]: ../bibliography.md#tpil4

---

[← Universes](02-universes.md) | [Index](00-index.md) | [Next: Definitional vs propositional equality →](04-defeq-vs-propeq.md)
