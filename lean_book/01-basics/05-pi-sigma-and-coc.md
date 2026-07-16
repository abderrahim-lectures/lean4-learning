## Π/Σ-types and the calculus of constructions

[← Terminology encountered before it is fully explained](04-terminology.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

---

§3 built Π-types concretely, from `Fin n` and `Vec.replicate`, up to the
general pattern $\prod_{x:A} B(x)$. This section adds the second half of
the picture — **Σ-types**, the dependent pair dual to Π — and then zooms
out to name the whole formal system these pieces belong to: the
**calculus of constructions** (CoC), the core type theory underlying Lean.
(Universes get their *own* formal typing rule in
[Chapter 5 §3](../05-rigor-check/03-typing-rules-and-safety.md), once
Chapter 5 has built up the informal picture of `Type`/`Type 1` those rules
formalize — nothing here depends on having read that yet.)

### Π-types, briefly recalled

$$
\prod_{x : A} B(x)
$$

— "a function that, given $x : A$, returns a term of type $B(x)$, a type
allowed to mention $x$." §3's `Vec.replicate`, with type `(n : Nat) → Vec α
n`, literally *is* $\prod_{n:\mathtt{Nat}} \mathrm{Vec}\,\alpha\,n$; Lean's
surface syntax `(x : A) → B x` **is** $\prod_{x:A} B(x)$, and `∀` is the
same construct specialized to `B : A → Prop`. Every `∀ n : Nat, P n` since
Chapter 3 was already a Π-type.

**Programmer's corner (Python), on what is genuinely missing.** Even
Python's `TypeVar` (its own fix for generic functions like `identity`)
cannot express `Vec.replicate`'s type:

```python
from typing import TypeVar
T = TypeVar("T")

def identity(x: T) -> T:      # generic over a TYPE — fine, this is TypeVar's job
    return x

# There is no Python type-hint equivalent of:
#   def replicate(a: T, n: <this specific Nat>) -> Vec[T, <that same Nat>]
# because "the type mentions n's VALUE" is not expressible by any
# combination of ordinary hints or TypeVar.
```

This is the honest answer to why Lean needs a whole extra concept here: it
is not that Python's type hints are missing a minor convenience, it is
that *no* mainstream static type system — Python's, Java's, C#'s,
TypeScript's — has a construct for "the type mentions a specific runtime
value," because none of them needed a proof assistant's level of
precision. Π-types are precisely that missing construct, made rigorous.

### `Prop` as a special, proof-irrelevant universe

Lean's `Prop` (Chapter 3) sits alongside `Type` as its own universe, with
one extra rule: **proof irrelevance**. Any two terms of the same type
`P : Prop` are considered definitionally equal, since a proof carries no
computational content beyond the bare fact that *a* proof exists:

```lean
theorem two_proofs (h1 h2 : 2 + 2 = 4) : h1 = h2 := rfl
```

`rfl` succeeds no matter *how* `h1` and `h2` were each proved — by `rfl`
directly, by a long tactic block, by an entirely different chain of
lemmas — because Lean does not distinguish between different proofs of
the same `Prop`. This is what makes Curry–Howard's slogan "propositions
are types, proofs are terms" more than a slogan: `P : Prop` really is a
type, `h : P` really is an ordinary term of that type built by ordinary
$\lambda$/application/Π machinery, and the *only* difference from an
ordinary `Type` is that Lean does not care *which* term of `P` was
produced — only that one was produced.

### Σ-types: the dependent pair, dual to Π

Where Π generalizes $\to$, a **Σ-type** (dependent pair / dependent sum)
generalizes $\times$ (the ordinary product):

$$
\sum_{x:A} B(x)
$$

a pair $\langle a, b\rangle$ with $a : A$ and $b : B(a)$ — the *second*
component's type is allowed to depend on the *first* component's *value*.

**Why "sum," if it generalizes ×?** The name is not a mismatch between
Σ and the product — it names the more fundamental view underneath both.
$\sum_{x:A} B(x)$ is, categorically, a disjoint union (coproduct) of the
family $B$ *indexed by* $A$: one tagged copy of $B(x)$ for every $x \in A$,
glued together as separate parts that never overlap. [Chapter 3
§1](../03-propositions-and-proofs/01-prop.md)'s Curry–Howard table already
lists `∧` as a **product type** and `∨` as a **sum (coproduct) type**,
side by side with `∃` as a **Σ-type** — as though all three were unrelated
rows. They are not: `∧` and `∨` are both shadows of this one Σ-type
construction, cast along two different axes of "what is allowed to vary":

- **Constant family, varying index** — if $B(x)$ is the *same* type $B$
  for every $x$, the disjoint union of $|A|$ tagged copies of $B$
  coincides with the ordinary product $A \times B$ (a value of $A$,
  tagging *which* copy, paired with a value of $B$). This is the
  "dependent pair" reading used throughout this section, and it is
  exactly Chapter 3's `∧` (`P ∧ Q` is `Σ`-like with the index type
  restricted to two unlabeled slots, both of type `Prop`).
- **Two-point index, varying family** — if $A$ is a two-element type
  (Lean's `Bool`, or "which side" of an `Or`) and $B(\mathrm{true}) = P$,
  $B(\mathrm{false}) = Q$ for two unrelated propositions, the *same*
  construction $\sum_{x:\mathrm{Bool}} B(x)$ collapses instead to
  $P \sqcup Q$ — the ordinary sum/coproduct type, exactly Chapter 3's
  `P ∨ Q`, built from `Or.inl`/`Or.inr`.

Σ is called a *sum* because it always literally is one — an indexed
disjoint union — and the product reading (`×`, and `∧` as its `Prop`
special case) is the constant-family special case, not the general
construction. `∀`/Π sits on the dual side of exactly the same coin:
$\prod_{x:A} B(x)$ is an indexed *product*, which for a constant family
collapses to the ordinary function type $A \to B$ (an exponential, $B^A$)
rather than to $A \times B$ — which is also why Π is never confused with
`×` the way Σ is with `∨`, and no equivalent puzzle arises on that side.

This shape has already appeared, without the name: §3's `Fin n` is, under
the hood, exactly this pair —

```lean
#print Fin
-- structure Fin (n : Nat) : Type
-- fields:
--   Fin.val  : Nat
--   Fin.isLt : val < n
```

a `Nat` value `val`, paired with a proof `isLt` whose *statement*
(`val < n`) mentions `val` itself. That is $\Sigma$, concretely: the
second field's type depends on the value of the first. Here is the
general construct, spelled out with Lean's actual `Sigma`, pairing a
bound with an actual number below it:

```lean
def mySigma : Σ n : Nat, Fin n := ⟨3, ⟨2, by decide⟩⟩
#eval mySigma.fst        -- 3
#eval mySigma.snd.val    -- 2
```

`mySigma.fst` extracts the first component with no fuss at all — it is
ordinary data, just like extracting `.1` from an ordinary pair. This
extractability matters, because it is exactly what `∃` (next) does *not*
allow, and the reason why is the most subtle point in this section.

This dependent-pair shape is also the "structure bundling data + proofs"
pattern that recurs throughout this book: `Group G`'s `⟨op, id, inv, assoc,
...⟩` is, underneath Lean's `structure` sugar, an iterated Σ-type — a
witness `op`, paired with a witness `id`, paired with `assoc`, whose
*type* depends on the values of `op` and `id` supplied earlier in the same
structure. Chapter 2's "structures can bundle proofs alongside data" was
already, silently, an appeal to Σ.

**A caveat about `∃`, worth being precise about.** Chapter 3 reads
`∃ x : α, P x` as "a structure: a witness value plus a proof that the
witness satisfies `P`" — in effect a Σ-type, with `P : α → Prop` playing
the role of `B`. Lean's actual `Exists` is, however, *not literally* the
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
with no error at all — same pair-shape, different universe, and that
difference is exactly why one extracts and the other does not. If `∃`
*did* allow extracting a witness, two different (but both equally valid)
choices of witness could produce different results from a
"proof-irrelevant" input, contradicting proof irrelevance itself. `Sigma`
(the actual, `Type`-valued dependent pair, matching a `structure`'s
bundled data) *does* support projecting out its first component,
precisely because it does not carry `Exists`'s irrelevance guarantee. So:
`∃` has the same shape as Σ but lives in a universe where the witness is
unobservable. That is what makes it a *restricted* cousin of Σ rather than
literally Σ. The `structure`-based bundling this book uses throughout for
`Group`/`Ring`/`Module` genuinely is `Sigma`-like (extractable), while an
`∃`-statement genuinely is not.

### The calculus of constructions, named

Putting the pieces together, the **calculus of constructions** (CoC,
Coquand–Huet) — the core type theory underlying Lean, Coq, and similar
systems — is a small formal system built from a variable, a function
abstraction, and function application, plus:

1. an infinite hierarchy of type universes $\mathtt{Type}\,0,
   \mathtt{Type}\,1, \ldots$, formalized in
   [Chapter 5 §3](../05-rigor-check/03-typing-rules-and-safety.md),
2. Π-types generalizing $\to$, allowing types to depend on terms (this
   chapter's §3 and the top of this page),
3. (in Lean's specific extension, the **Calculus of Inductive
   Constructions**, CIC) `inductive` type declarations — `Nat`, `Bool`,
   `Vec`/`Fin` (§3), `Path` (Chapter 11), and every `structure` written
   throughout — giving Σ-types and much more (arbitrary recursive data)
   beyond what bare CoC provides,
4. `Prop` as a distinguished, proof-irrelevant universe (Chapter 3, and
   above), making Curry–Howard a precise correspondence rather than an
   analogy.

Every single Lean construct used in this book — `def`, `structure`,
`theorem`, `∀`, `∃`, tactics (which merely *build* CIC terms, one piece at
a time, without the terms being written by hand) — compiles down to a
term in exactly this system, checked by Lean's kernel using nothing more
than typing rules like the ones sketched here and in Chapter 5, applied
mechanically. [Chapter 5 §3](../05-rigor-check/03-typing-rules-and-safety.md)
completes the picture with the simply typed λ-calculus's typing judgments
and its progress/preservation theorems — the formal reason "well-typed
proofs do not go wrong" — plus the universe-formation rule only sketched
by name above.

---

### References

- Thierry Coquand and Gérard Huet, "[The Calculus of Constructions](https://doi.org/10.1016/0890-5401(88)90005-3)," *Information and Computation*, 76(2–3), 1988, 95–120 — the original paper defining CoC, the system this section formalizes.
- The Univalent Foundations Program, *Homotopy Type Theory: Univalent Foundations of Mathematics*, 2013, free online at [homotopytypetheory.org/book](https://homotopytypetheory.org/book/) — Ch. 1 gives a careful, from-scratch treatment of Π-types, Σ-types, and universes, in notation closely matching this section's.
- Per Martin-Löf, *Intuitionistic Type Theory*, Bibliopolis, 1984 — the foundational source for dependent Π/Σ types and universes predating CoC, for readers wanting the idea in its original, non-CoC-specific form.
- *Theorem Proving in Lean 4*, ["Dependent Types"](https://leanprover.github.io/theorem_proving_in_lean4/dependent_type_theory.html) and ["Propositions and Proofs"](https://leanprover.github.io/theorem_proving_in_lean4/propositions_and_proofs.html) — Lean's own documentation on `Prop`, proof irrelevance, and universes, matching the presentation here.
- All Lean code in this section was checked directly against the toolchain pinned in this repository's `lean_project/lean-toolchain` rather than only described; the `#print Fin` output and both error messages shown are copied from real `lake env lean` runs.

---

[← Terminology encountered before it is fully explained](04-terminology.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)
