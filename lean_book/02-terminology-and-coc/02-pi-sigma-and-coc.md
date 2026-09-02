## Π/Σ-types and the calculus of constructions

[← Terminology encountered before it is fully explained](01-terminology.md) | [Index](00-index.md) | [Next: Exercises →](03-exercises.md)

---

Section 3 built Π-types concretely, from `Fin n` and `Vec.replicate`, up to the
general pattern $\prod_{x:A} B(x)$. This section adds the second half of
the picture, **Σ-types**, the dependent pair dual to the Π-type. It then
zooms out to name the whole formal system these pieces belong to, the
**calculus of constructions** (CoC), the core type theory underlying Lean.
Universes get their *own* formal typing rule in
[Chapter 6, Section 3](../06-rigor-check/03-typing-rules-and-safety.md), once
Chapter 6 has built up the informal picture of `Type`/`Type 1` those rules
formalize. Nothing here depends on having read that yet.

### Π-types, briefly recalled

$$
\prod_{x : A} B(x)
$$

This reads as "a function that, given $x : A$, returns a term of type
$B(x)$, a type allowed to mention $x$." The `Vec.replicate` from Section 3, with
type `(n : Nat) → Vec α n`, literally *is* $\prod_{n:\mathtt{Nat}}
\mathrm{Vec}\,\alpha\,n$. The surface syntax `(x : A) → B x` in Lean **is**
$\prod_{x:A} B(x)$, and `∀` is the same construct specialized to
`B : A → Prop`, as Chapter 4 makes precise. Every `∀ n : Nat, P n` written
from that point on is already a Π-type in exactly this sense.

**Programmer note (Python), on what is genuinely missing.** Even
the `TypeVar` construct in Python (its own fix for generic functions like `identity`)
cannot express the type of `Vec.replicate`:

```python
from typing import TypeVar
T = TypeVar("T")

def identity(x: T) -> T:      # generic over a TYPE — fine, this is what TypeVar is for
    return x

# There is no Python type-hint equivalent of:
#   def replicate(a: T, n: <this specific Nat>) -> Vec[T, <that same Nat>]
# because "the type mentions the VALUE of n" is not expressible by any
# combination of ordinary hints or TypeVar.
```

This is the honest answer to why Lean needs a whole extra concept here. It
is not that the type hints in Python are missing a minor convenience. It is
that *no* mainstream static type system, not in Python, Java, C#, nor
TypeScript, has a construct for "the type mentions a specific runtime
value," because none of them needed the level of precision a proof assistant requires. Π-types are precisely that missing construct, made rigorous.

**A second worked example, where the codomain is a genuinely different
type, not just a differently-sized version of the same type.**
`Vec.replicate` always returns *some* `Vec`. The following function
returns a `Nat` or a `Bool` depending on which was asked for, an even
sharper case of "the type mentions the value of the argument":

```lean
def pick (b : Bool) : (if b then Nat else Bool) :=
  match b with
  | true => (42 : Nat)
  | false => (true : Bool)

#check @pick   -- pick : (b : Bool) → if b = true then Nat else Bool
#eval pick true   -- 42
#eval pick false  -- true
```

**A counterexample.** Forcing the result of `pick` to a single fixed type
(dropping the dependency) is rejected outright, because the two branches
genuinely disagree on type. There is no ordinary, non-dependent function
type that could describe `pick`:

```lean
def badPick (b : Bool) : Nat :=
  match b with
  | true => 42
  | false => true
```

```
error: Type mismatch
  true
has type
  Bool
but is expected to have type
  Nat
```

### `Prop` as a special, proof-irrelevant universe

The `Prop` type in Lean (Chapter 4) sits alongside `Type` as its own universe, with
one extra rule, **proof irrelevance**. Any two terms of the same type
`P : Prop` are considered definitionally equal, since a proof carries no
computational content beyond the bare fact that *a* proof exists:

```lean
theorem two_proofs (h1 h2 : 2 + 2 = 4) : h1 = h2 := rfl
```

`rfl` succeeds no matter *how* `h1` and `h2` were each proved, whether by
`rfl` directly, by a long tactic block, or by an entirely different chain
of lemmas, because Lean does not distinguish between different proofs of
the same `Prop`. This is what makes the slogan of Curry–Howard, "propositions
are types, proofs are terms" more than a slogan. `P : Prop` really is a
type, `h : P` really is an ordinary term of that type built by ordinary
$\lambda$/application/Π-type machinery, and the *only* difference from an
ordinary `Type` is that Lean does not care *which* term of `P` was
produced, only that one was produced.

### Σ-types, the dependent pair, dual to the Π-type

Where the Π-type generalizes the ordinary function type $\to$, a **Σ-type**
(dependent pair / dependent sum) generalizes $\times$ (the ordinary
product):

$$
\sum_{x:A} B(x)
$$

This is a pair $\langle a, b\rangle$ with $a : A$ and $b : B(a)$, where the
type of the *second* component is allowed to depend on the *value* of the *first*
component.

**Why "sum," if it generalizes ×?** The name is not a mismatch between
the Σ-type and the product. It names the more fundamental view underneath
both. $\sum_{x:A} B(x)$ is, categorically, a disjoint union (coproduct) of
the family $B$ *indexed by* $A$, one tagged copy of $B(x)$ for every
$x \in A$, glued together as separate parts that never overlap. The Curry–Howard table in [Chapter 4,
Section 1](../04-propositions-and-proofs/01-prop.md) will
list `∧` as a **product type** and `∨` as a **sum (coproduct) type**,
side by side with `∃` as a **Σ-type**, as though all three were unrelated
rows. They are not. `∧` and `∨` are both special cases of this same
Σ-type construction. Which connective you get depends on which of the
two ingredients, the index type $A$ or the family $B$, is held fixed
and which is allowed to vary.

- **Constant family, varying index.** If $B(x)$ is the *same* type $B$
  for every $x$, the disjoint union of $|A|$ tagged copies of $B$
  coincides with the ordinary product $A \times B$ (a value of $A$,
  tagging *which* copy, paired with a value of $B$). This is the
  "dependent pair" reading used throughout this section, and it is
  exactly what `∧` in Chapter 4 will turn out to be. $P \wedge Q$ is
  $\sum_{\_ : P} Q$, an index type $P$ with a family constantly $Q$, so
  the "which copy" tag is itself a *proof* rather than a value.
- **Two-point index, varying family.** If $A$ is a two-element type
  (the `Bool` type in Lean, or "which side" of an `Or`) and $B(\mathrm{true}) = P$,
  $B(\mathrm{false}) = Q$ for two unrelated propositions, the *same*
  construction $\sum_{x:\mathrm{Bool}} B(x)$ collapses instead to
  $P \sqcup Q$, the ordinary sum/coproduct type that `P ∨ Q` in Chapter 4
  will turn out to be, built from `Or.inl`/`Or.inr`.

The Σ-type is called a *sum* because it always literally is an indexed
disjoint union. The product reading (`×`, and `∧` as its `Prop` special
case) is just the constant-family special case of that same
construction, not a second, unrelated thing.

The same split applies to the Π-type, the other way round.
$\prod_{x:A} B(x)$ is always literally an indexed *product*. For a
constant family, this collapses to the ordinary function type
$A \to B$ (an exponential, written $B^A$), not to $A \times B$. This is
why the Π-type is never confused with `×` the way the Σ-type is with `∨`,
and no equivalent puzzle arises on that side.

This shape has already appeared, without the name. The `Fin n` from Section 3 is,
under the hood, exactly this pair:

```lean
#print Fin
-- structure Fin (n : Nat) : Type
-- fields:
--   Fin.val  : Nat
--   Fin.isLt : ↑self < n
```

It is a `Nat` value `val`, paired with a proof `isLt` whose *statement*
(`↑self < n`) mentions the first field itself (`self.val`, printed with
the `↑` coercion arrow). That is $\Sigma$, concretely. The
type of the second field depends on the value of the first. Here is the
general construct, spelled out with the actual `Sigma` type in Lean, pairing a
bound with an actual number below it:

```lean
def mySigma : Σ n : Nat, Fin n := ⟨3, ⟨2, by decide⟩⟩
#eval mySigma.fst        -- 3
#eval mySigma.snd.val    -- 2
```

`mySigma.fst` extracts the first component with no fuss at all. It is
ordinary data, just like extracting `.1` from an ordinary pair. This
extractability matters, because it is exactly what `∃` (next) does *not*
allow, and the reason why is the most subtle point in this section.

**A second worked example, mirroring the Π-type one above.** Just as the
codomain of a Π-type can be a genuinely different type per argument, the
second component of a Σ-type can be a genuinely different type per first
component, not just a differently-sized version of one fixed type:

```lean
def mySigma2 : Σ b : Bool, if b then Nat else String :=
  ⟨true, (42 : Nat)⟩
def mySigma3 : Σ b : Bool, if b then Nat else String :=
  ⟨false, "hi"⟩

#eval mySigma2.fst  -- true
#eval mySigma2.snd  -- 42
#eval mySigma3.fst  -- false
#eval mySigma3.snd  -- "hi"
```

**A counterexample.** The type of the second component is dictated by the
*specific value* supplied as the first component, not freely choosable
alongside it. Supplying a `String` alongside `true` (whose dependent type
here is `Nat`) is rejected:

```lean
def badSigma : Σ b : Bool, if b then Nat else String :=
  ⟨true, "oops"⟩
```

```
error: Application type mismatch: The argument
  "oops"
has type
  String
but is expected to have type
  if true = true then Nat else String
in the application
  ⟨true, "oops"⟩
```

This dependent-pair shape is also the "structure bundling data + proofs"
pattern that recurs throughout this book. The `⟨op, id, inv, assoc,
...⟩` of `Group G` is, underneath the `structure` sugar in Lean, an iterated Σ-type, a
witness `op`, paired with a witness `id`, paired with `assoc`, whose
*type* depends on the values of `op` and `id` supplied earlier in the same
structure. This dependent-pair shape is exactly what lets Chapter 3 say
that structures can bundle proofs alongside data. Every such structure
is, underneath, silently an appeal to the Σ-type.

**A caveat about `∃`, worth being precise about.** Chapter 4 will read
`∃ x : α, P x` as "a structure, a witness value plus a proof that the
witness satisfies `P`," in effect a Σ-type, with `P : α → Prop` playing
the role of `B`. The actual `Exists` type in Lean is, however, *not literally* the
Σ-type `Sigma`. `Exists` is specifically built to land in `Prop`, and by
proof irrelevance (above), that means the witness cannot be *extracted*
from an `∃`-proof computationally:

```lean
def bad (h : ∃ n : Nat, n > 0) : Nat := h.1
```

```
error(lean.projNonPropFromProp): Invalid projection: Cannot project a
value of non-propositional type
  Nat
from the expression
  h
which has propositional type
  ∃ n, n > 0
```

Compare this directly to `mySigma.fst` two paragraphs up, which worked
with no error at all. Same pair-shape, different universe, and that
difference is exactly why one extracts and the other does not. If `∃`
*did* allow extracting a witness, two different (but both equally valid)
choices of witness could produce different results from a
"proof-irrelevant" input, contradicting proof irrelevance itself. `Sigma`
(the actual, `Type`-valued dependent pair, matching the
bundled data of a `structure`) *does* support projecting out its first component,
precisely because it does not carry the irrelevance guarantee of `Exists`. In
short, `∃` has the same shape as the Σ-type but lives in a universe where
the witness is unobservable. That is what makes it a *restricted* cousin
of the Σ-type rather than literally the Σ-type. The `structure`-based
bundling this book uses throughout for
`Group`/`Ring`/`Module` genuinely is `Sigma`-like (extractable), while an
`∃`-statement genuinely is not.

### Π-types and Σ-types, side by side

Everything above in one table, gathering the two constructs' notation,
readings, and special cases for direct comparison.

| Aspect | Π-type $\prod_{x:A} B(x)$ | Σ-type $\sum_{x:A} B(x)$ |
| --- | --- | --- |
| Read as | "for every $x:A$, a term of $B(x)$" | "some $x:A$, together with a term of $B(x)$" |
| Generalizes | $A \to B$ (function type) | $A \times B$ (product type) |
| Constant-family collapse ($B$ ignores $x$) | ordinary function type $A \to B$ | ordinary product $A \times B$ |
| Categorical reading | indexed **product** | indexed **coproduct** (disjoint union) |
| Lean surface syntax | `(x : A) → B x` | `Σ x : A, B x`, built with `⟨_, _⟩` |
| Logic special case ($B : A \to \mathrm{Prop}$) | `∀ x, P x` | `∃ x, P x` |
| Witness/value extraction | always. Applying a Π-typed function to an argument is ordinary evaluation | allowed for `Sigma` (`Type`-valued, `.fst`/`.snd`); **not** allowed for `Exists` (`Prop`-valued, proof irrelevance forbids it) |
| First example this book gave | `Vec.replicate : (n : Nat) → Vec α n` (Section 3 above) | the fields of `Fin n` itself, `val : Nat` paired with `isLt : val < n` (above) |

The one asymmetry worth remembering from the row above is that the
logic special case (`∀`) of the Π-type and that of the Σ-type (`∃`) both extract
cleanly as *propositions*, but only the *data* special case
(`Sigma`) of the Σ-type supports extracting its witness back out. `∃` looks like a
Σ-type and reads like one, but proof irrelevance makes it a strictly
weaker, non-extractable cousin. The "caveat about `∃`" above is the one
place the two columns of this table are not simply mirror images of each
other.

### Recursors and eliminators, named

[Chapter 2, Section 1](01-terminology.md) promised a formal treatment of the **recursor**
(also called an **eliminator**) once Π/Σ-types were available. Here it is.
For an inductive type like `Nat`, with constructors `zero : Nat` and
`succ : Nat → Nat`, the **recursor** `Nat.rec` is the single term that
makes "define a function, or prove a statement, by giving one case per
constructor" precise:

```lean
#check @Nat.rec
-- {motive : Nat → Sort u}
--   → motive Nat.zero
--   → ((n : Nat) → motive n → motive n.succ)
--   → (t : Nat) → motive t
```

Read the type of `Nat.rec` itself as a Π-type over a **motive**
`motive : Nat → Sort u` (the "motive" of Section 4, spelled out in full). Supply
a "zero case" (a term of `motive Nat.zero`), a "succ case" (a function
turning a value/proof for `n` into one for `n.succ`), and `Nat.rec`
produces a term of `motive t` for *any* `t : Nat`. This is structural
induction/recursion stated as one Π-typed term rather than as a separate
principle bolted onto the language. Proving something for `zero` and
showing it is preserved by `succ` is *literally* supplying the two
remaining arguments of `Nat.rec`.

**A first worked example.** The simplest motive is a *constant* one. The
result type does not actually depend on which `Nat` was supplied, only its
value does. Doubling a number, written directly as an application of
`Nat.rec` instead of via `+`:

```lean
def double (n : Nat) : Nat :=
  Nat.rec 0 (fun _ ih => ih + 2) n

#eval double 5   -- 10
```

Here `motive := fun _ => Nat` (inferred, since the zero case `0` and the
result of the succ case both have type `Nat`). The zero case supplies `0` for
`double 0`, and the succ case says "given the doubled value `ih` for `n`,
the doubled value for `n.succ` is `ih + 2`," exactly the recursive
definition of doubling, with no separate "recursion" mechanism beyond
`Nat.rec` itself. A `dbg_trace` inside the succ case makes each of the
five hidden recursive steps visible:

```lean
def double' (n : Nat) : Nat :=
  Nat.rec 0 (fun _ ih => dbg_trace s!"double: succ case, ih={ih}, adding 2"; ih + 2) n

#eval double' 5
-- double: succ case, ih=0, adding 2
-- double: succ case, ih=2, adding 2
-- double: succ case, ih=4, adding 2
-- double: succ case, ih=6, adding 2
-- double: succ case, ih=8, adding 2
-- 10
```

Five lines print, one per `succ` layer `Nat.rec` peels off `5 =
succ(succ(succ(succ(succ zero))))`, each showing the running total *before*
the final `+ 2`. That total is `0`, then `2`, then `4`, then `6`, then `8`,
then the returned `10`. Nothing about `Nat.rec` was changed to make this
possible. The trace prints from inside the ordinary succ-case function
supplied as the second argument of `Nat.rec`, the same function already
described above.

**A second worked example, over a different inductive type.** The same
pattern generalizes to any inductive type, not just `Nat`. Computing the
length of a list via `List.rec` directly, rather than via the built-in
`List.length`:

```lean
noncomputable def myLength {α : Type} (l : List α) : Nat :=
  List.rec (motive := fun _ => Nat) 0 (fun _ _ tailLen => tailLen + 1) l

#reduce myLength [1, 2, 3]        -- 3
#reduce myLength ([] : List Nat)  -- 0
```

`noncomputable` and `#reduce` in place of `#eval` here are a Lean
implementation detail. The code generator that backs `#eval` does not yet
support compiling `List.rec` directly, so this definition is checked and
reduced by the kernel via `#reduce` instead. The mathematical content is
identical to `double` above, just for `List` in place of `Nat`. The motive
is again constant (`fun _ => Nat`), the "nil case" is `0`, and the "cons
case" says "given the length of the tail, `tailLen`, the length with one more
element prepended is `tailLen + 1`."

Unlike `double` above, the recursion of `myLength` cannot be watched with
`dbg_trace`. A `dbg_trace` call placed inside the cons case prints nothing
at all under `#reduce`, verified directly. The definitional
reduction performed by the kernel (what `#reduce` invokes) is a pure, side-effect-free rewriting
process, not a compiled/interpreted evaluation the way `#eval` is, so
the print action of `dbg_trace` never fires. This is the same `noncomputable`
boundary from one paragraph up, seen from a second angle. Whatever cannot
be compiled also cannot be traced by any mechanism that relies on running
compiled code.

**A counterexample, getting the case order wrong.** The two case
arguments of `Nat.rec` are positional, not named. Supplying them in the wrong order is
a genuine, easy mistake, and Lean rejects it as a type error rather than
silently doing the wrong thing:

```lean
def doubleBad (n : Nat) : Nat :=
  Nat.rec (fun _ ih => ih + 2) 0 n
```

```
error: Type mismatch
  fun x ih => ih + 2
has type
  (x : ?m.4) → (ih : ?m.13 x) → ?m.15 x ih
but is expected to have type
  Nat
```

The succ-case function was placed where the zero case belongs. Since
the first explicit argument of `Nat.rec` must have type `motive Nat.zero`
(here, plainly `Nat`), a function is rejected on the spot. This is the same
class of error underlying "motive is not type correct" messages elsewhere
in this book. The argument positions of `Nat.rec` encode real structure (which
case is which), and getting that structure wrong is caught before anything
runs, not discovered later at `#eval` time.

An **eliminator** is the general name for this same pattern applied to
*any* inductive type. It is the single term that "uses" a value of that
type by case-splitting on which constructor built it, with a motive
tracking what is being proved or built in each case. `Nat.rec` above is
the eliminator for `Nat`. The
`Or.elim {P Q R : Prop} (h : P ∨ Q) (hpr : P →
R) (hqr : Q → R) : R` shown in [Chapter 4, Section 5](../04-propositions-and-proofs/05-and-or-not.md) is the eliminator for `Or`, a case for `Or.inl` and a case for
`Or.inr`, with the (non-dependent, here) motive fixed to the constant type
`R`. Every `match`/`cases`/`induction` used from here on compiles down to
exactly this, an application of the eliminator for the relevant inductive type,
built automatically rather than written out by hand.

### The calculus of constructions, named

Putting the pieces together, the **calculus of constructions** (CoC,
Coquand–Huet), the core type theory underlying Lean, Coq, and similar
systems, is a small formal system built from a variable, a function
abstraction, and function application, plus the following.

1. An infinite hierarchy of type universes $\mathtt{Type}\,0,
   \mathtt{Type}\,1, \ldots$, formalized in
   [Chapter 6, Section 3](../06-rigor-check/03-typing-rules-and-safety.md).
2. Π-types generalizing $\to$, allowing types to depend on terms (Section 3
   of this chapter and the top of this page).
3. `inductive` type declarations, in the specific extension used by Lean, the
   **Calculus of Inductive Constructions** (CIC), such as `Nat`, `Bool`,
   `Vec`/`Fin` (Section 3), `Path` (Chapter 12), and every `structure`
   written throughout, giving Σ-types and much more (arbitrary recursive
   data) beyond what bare CoC provides.
4. `Prop` as a distinguished, proof-irrelevant universe (Chapter 4, and
   above), making Curry–Howard a precise correspondence rather than an
   analogy.

Every single Lean construct used in this book, `def`, `structure`,
`theorem`, `∀`, `∃`, and tactics (which merely *build* CIC terms, one
piece at a time, without the terms being written by hand), compiles down
to a term in exactly this system, checked by the Lean kernel using nothing
more than typing rules like the ones sketched here and in Chapter 6,
applied mechanically. [Chapter 6, Section 3](../06-rigor-check/03-typing-rules-and-safety.md)
completes the picture with the typing judgments of the simply typed λ-calculus
and its progress/preservation theorems, the formal reason "well-typed
proofs do not go wrong," plus the universe-formation rule only sketched
by name above.

---

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Σ-type.** "Given a type $A : U$ and a family $B : A \to U$, the
  dependent pair type is written as $\sum_{(x:A)} B(x) : U$ ... If $B$
  is constant, then the dependent pair type is the ordinary Cartesian
  product type" ([HoTT2013], §1.6 "Dependent pair types (Σ-types)").
  Picture it like this. A labeled suitcase where the label decides what
  kind of compartment to expect inside, a "shoes" tag pairs with a
  shoe-shaped compartment, an "electronics" tag with a different one.
  When every tag happens to pair with the *same* compartment shape
  regardless of the label, that's just an ordinary suitcase-and-item
  pair, the constant-family special case, which is the ordinary
  product $A \times B$.
- **`Prop`.** "The type `Prop` is syntactic sugar for `Sort 0`, the
  very bottom of the type hierarchy" ([TPIL4], §3.1 "Propositions as
  Types").
- **Proof irrelevance.** "If `p : Prop` is any proposition, the Lean
  kernel treats any two elements `t1 t2 : p` as being definitionally
  equal ... This is known as proof irrelevance" ([TPIL4], §3.1). Picture
  it like this. A "verified" stamp on a passport. Customs doesn't
  care which officer stamped it or how the check was carried out, only
  that a valid stamp exists. Any two proofs of the same `P : Prop` are
  just as interchangeable. For the metatheory underneath this working
  description, normalisation and decidable conversion for a universe
  hierarchy with a proof-irrelevant type of propositions "close to the
  type system used in the proof assistant Lean" is established directly
  in [Coquand2021].
- **Recursor / eliminator.** The working statement used by this book, built on
  the calculus of constructions ([CoquandHuet1988]), is the single
  Π-typed term (`Nat.rec` and its analogues) that makes "one case per
  constructor" precise. Every `match`/`cases`/`induction` compiles
  down to one.
- **Calculus of constructions (CoC).** The working statement used by this book,
  after Coquand and Huet ([CoquandHuet1988], §1 "The Abstract Syntax
  of Terms," §2.1 "The Inference System of Constructions"), is a small
  formal system built from a variable, a function abstraction, and
  function application, plus an infinite hierarchy of universes and
  Π-types. The specific extension of Lean with `inductive` type
  declarations (giving Σ-types and general recursive data) is the
  Calculus of Inductive Constructions (CIC), due to a later paper,
  Thierry Coquand and Christine **Paulin-Mohring**, "Inductively Defined
  Types," in *COLOG-88*, Lecture Notes in Computer Science 417,
  Springer, 1990, not the 1988 paper itself. Note that this is a
  *different* paper from the one by Pfenning & Paulin-Mohring, "Inductively Defined
  Types in the Calculus of Constructions" (1989), with which it is easily
  conflated. The surname is hyphenated in both.
- Pierce ([Pierce2002]) is cited here only by analogy. *Types and
  Programming Languages* is explicitly *not* a dependently-typed
  textbook (the preface by Pierce himself says dependent types are "mentioned
  only in passing," developed no further than the one-paragraph
  sketch in §30.5 of "families of types indexed by terms"), so it does not cover
  eliminators/recursors for inductive types in a dependent setting. What
  it does cover, relevant here only by analogy, is non-dependent `case`
  analysis on sum/variant types (§11.9–11.10) and on `µ`-recursive types
  like `NatList = μX.⟨nil:Unit, cons:{Nat,X}⟩` (Ch. 21), plus Church
  encodings of algebraic datatypes (Ch. 6 untyped, §23.4 typed/System F).
- Martin-Löf ([MartinLof1984]) is the foundational source for dependent
  Π/Σ types and universes predating CoC, for readers wanting the idea in
  its original, non-CoC-specific form.
- All Lean code in this section was checked directly against the toolchain pinned in `lean_project/lean-toolchain` in this repository rather than only described; the `#print Fin` output and both error messages shown are copied from real `lake env lean` runs.

[CoquandHuet1988]: ../bibliography.md#coquandhuet1988
[Pierce2002]: ../bibliography.md#pierce2002
[HoTT2013]: ../bibliography.md#hott2013
[MartinLof1984]: ../bibliography.md#martinlof1984
[TPIL4]: ../bibliography.md#tpil4
[Coquand2021]: ../bibliography.md#coquand2021

---

[← Terminology encountered before it is fully explained](01-terminology.md) | [Index](00-index.md) | [Next: Exercises →](03-exercises.md)
