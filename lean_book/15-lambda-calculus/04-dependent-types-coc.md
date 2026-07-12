## Dependent types and the calculus of constructions

[← Simply typed λ-calculus](03-simply-typed-lambda-calculus.md) | [Index](00-index.md) | [Next: From λ-calculus to Lean, term by term →](05-lambda-to-lean.md)

---

This section makes precise the system previewed informally in Chapter 1's
"Dependent types, categorically" section. Here we take the type-theory
side, building up the exact rules rather than the categorical analogy.

### Types depending on terms: Π-types

STLC's function type $\tau_1 \to \tau_2$ has a *fixed* codomain $\tau_2$,
independent of which argument you supply. A **dependent function type**
(a **Π-type**, "Pi-type") lets the codomain depend on the argument's
*value*:

$$
\prod_{x : A} B(x)
$$

read: "a function that, given $x : A$, returns a term of type $B(x)$ —
a type allowed to mention $x$." When $B(x)$ doesn't actually depend on
$x$, $\prod_{x:A} B$ collapses exactly to the ordinary $A \to B$. So
Π-types **strictly generalize** function types rather than replacing them.
This is exactly Chapter 1's `Path Q : V → V → Type` discussion: `Path Q`
is a family of types indexed by a pair of vertices, and a function whose
return type is `Path Q u w` for varying `u, w` is a genuine dependent
function.

Lean's surface syntax `(x : A) → B x` **is** $\prod_{x:A} B(x)$, and `∀`
is the exact same construct specialized to `B : A → Prop`. So every
`∀ n : Nat, P n` you wrote starting in Chapter 3 was already a Π-type. You
were doing dependent type theory from the very first `theorem` in this
book, whether or not you had the vocabulary for it yet.

### Universes, revisited as a typing rule

Chapter 5 introduced the hierarchy $\mathtt{Type} : \mathtt{Type}\,1 :
\mathtt{Type}\,2 : \cdots$ to avoid a Russell-style paradox. In the
calculus of constructions, this is stated as a typing rule for the
universes themselves:

$$
\dfrac{}{\mathtt{Type}\,i : \mathtt{Type}\,(i+1)}
$$

together with a rule saying Π-types stay inside a suitable universe:

$$
\dfrac{\Gamma \vdash A : \mathtt{Type}\,i \quad \Gamma, x:A \vdash B : \mathtt{Type}\,j}
      {\Gamma \vdash \big(\textstyle\prod_{x:A} B\big) : \mathtt{Type}\,(\max(i,j))}
$$

This is exactly the fact from Chapter 5 that `Group : Type → Type`
(a function *out of* `Type`) had to live in `Type 1`, one level above
`Type` itself, rather than back inside `Type 0`.

### `Prop` as a special, proof-irrelevant universe

Lean's `Prop` (Chapter 3) is a universe with one extra rule beyond the
ordinary hierarchy: **proof irrelevance** (also mentioned in Chapter 5).
Any two terms of the same type `P : Prop` are considered definitionally
equal, since a proof carries no computational content beyond the bare fact
that *a* proof exists. This is what makes Curry–Howard's slogan
"propositions are types, proofs are terms" more than a slogan:
`P : Prop` really is a type, `h : P` really is an ordinary term of that
type built by ordinary $\lambda$/application/Π machinery, and the *only*
difference from an ordinary `Type` is that Lean doesn't care *which* term
of `P` you produced — only that you produced one.

### Σ-types: the dependent pair, dual to Π

Where Π generalizes $\to$, a **Σ-type** (dependent pair / dependent sum)
generalizes $\times$ (the ordinary product):

$$
\sum_{x:A} B(x)
$$

a pair $\langle a, b\rangle$ with $a : A$ and $b : B(a)$ — the *second*
component's type is allowed to depend on the *first* component's *value*.
This is exactly the "structure bundling data + proofs" pattern that
recurs throughout this book: `Group G`'s `⟨op, id, inv, assoc, ...⟩` is,
underneath Lean's `structure` sugar, an iterated Σ-type. It's a witness
`op`, paired with a witness `id` (whose type doesn't depend on `op` here),
paired with `assoc`, whose *type* depends on the values of `op` and `id`
supplied earlier in the same structure. Chapter 2's "structures can bundle
proofs alongside data" was already, silently, an appeal to Σ.

**A caveat about `∃`, worth being precise about.** Chapter 3 reads
`∃ x : α, P x` as "a structure: a witness value plus a proof that the
witness satisfies `P`" — in effect a Σ-type, with `P : α → Prop` playing
the role of `B`. But Lean's actual `Exists` is *not literally* the
Σ-type `Sigma`. `Exists` is specifically built to land in `Prop`, and by
proof irrelevance (above), that means you cannot *extract* the witness
from an `∃`-proof computationally. There is no function
`Exists.witness : (∃ x, P x) → α`, because doing so would let two
different (but both valid) choices of witness produce different
results from a "proof-irrelevant" input, contradicting proof
irrelevance itself. `Sigma` (the actual, `Type`-valued dependent pair,
matching a `structure`'s bundled data) *does* support projecting out its
first component, precisely because it does not carry `Exists`'s
irrelevance guarantee. So: `∃` has the same shape as Σ but lives in a
universe where the witness is unobservable. That is what makes it a
*restricted* cousin of Σ rather than literally Σ. The
`structure`-based bundling this book uses throughout for
`Group`/`Ring`/`Module` genuinely is `Sigma`-like (extractable), while an
`∃`-statement genuinely is not.

### The calculus of constructions, assembled

Putting the pieces together, the **calculus of constructions** (CoC,
Coquand–Huet) — the core type theory underlying Lean, Coq, and similar
systems — is the untyped λ-calculus's three term-formers (variable,
abstraction, application), plus:

1. an infinite hierarchy of type universes $\mathtt{Type}\,0,
   \mathtt{Type}\,1, \ldots$ (Chapter 5),
2. Π-types generalizing $\to$, allowing types to depend on terms (Chapter 1,
   and the top of this page),
3. (in Lean's specific extension, the **Calculus of Inductive
   Constructions**, CIC) `inductive` type declarations — `Nat`, `Bool`,
   `Path` (Chapter 11), and every `structure` you've written — giving you
   Σ-types and much more (arbitrary recursive data) beyond what bare CoC
   provides,
4. `Prop` as a distinguished, proof-irrelevant universe (Chapter 3),
   making Curry–Howard a precise correspondence rather than an analogy.

Every single Lean construct used in this entire book — `def`, `structure`,
`theorem`, `∀`, `∃`, tactics (which merely *build* CIC terms, one piece at
a time, without you writing them by hand) — compiles down to a term in
exactly this system, checked by Lean's kernel using nothing more than the
typing rules sketched on this page, applied mechanically. There is no
extra magic between the code in Chapters 1–13 and this appendix's
formal system; this *is* what was running the whole time.

## Next

Continue to [From λ-calculus to Lean, term by term](05-lambda-to-lean.md), a
direct dictionary connecting every construct in this appendix back to its
exact appearance earlier in the book.

---

[← Simply typed λ-calculus](03-simply-typed-lambda-calculus.md) | [Index](00-index.md) | [Next: From λ-calculus to Lean, term by term →](05-lambda-to-lean.md)
