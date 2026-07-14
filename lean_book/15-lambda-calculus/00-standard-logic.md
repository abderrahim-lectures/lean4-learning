## A recap of standard logic and logical calculus

[← Index](00-index.md) | [Next: Untyped λ-calculus →](01-untyped-lambda-calculus.md)

---

Chapter 3 introduced the Curry–Howard correspondence by translating logic
directly into Lean types. It assumed that "propositional logic," "$\vdash$,"
and "natural deduction" were at least half-familiar to the reader. If they
were not, this section is the missing prerequisite. It is a self-contained
recap of standard mathematical logic — the *pre-Lean, pre-type-theory*
version, exactly as it is presented in a first logic course — so that
Chapter 3's table has something concrete on its "Logic" side to refer back
to. Nothing here mentions Lean, types, or programs; that translation is
entirely Chapter 3's job, and Appendix B §§1–4 build the calculus those
types compile down to. This section only fixes what the logic itself is.

### Propositional logic: syntax

Fix a set of **propositional variables** (atomic statements) $p, q, r,
\dots$. These stand for sentences whose internal structure is not
analyzed — "it is raining," "$n$ is prime," anything with a definite truth
value. **Formulas** are built from these using the **connectives**:

$$
\varphi ::= p \;\mid\; \top \;\mid\; \bot \;\mid\; \neg\varphi \;\mid\;
\varphi \wedge \varphi \;\mid\; \varphi \vee \varphi \;\mid\;
\varphi \Rightarrow \varphi
$$

read: a propositional variable, "true," "false," "not $\varphi$," "$\varphi$
and $\varphi$," "$\varphi$ or $\varphi$," "$\varphi$ implies $\varphi$."
This is pure syntax. A formula is just a string built by this grammar,
nothing more, exactly as "$\lambda x.\, t$" in Appendix B §1 is a string
built by *its* grammar. Whether a formula is *true*, and whether it is
*provable*, are two separate questions. We address them next.

### Semantics: truth tables and validity

A propositional variable's truth value is given by a **valuation**
$v : \{\text{variables}\} \to \{0, 1\}$ (an assignment of true or false to
each atom). Every valuation extends uniquely to all formulas by the
familiar truth tables:

| $\varphi$ | $\psi$ | $\varphi \wedge \psi$ | $\varphi \vee \psi$ | $\varphi \Rightarrow \psi$ | $\neg \varphi$ |
| --- | --- | --- | --- | --- | --- |
| 0 | 0 | 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 | 1 | 0 |

A formula is a **tautology** (valid, written $\models \varphi$) if it comes
out true under *every* valuation. For example, $p \vee \neg p$ (the **law
of excluded middle**) and $\neg\neg p \Rightarrow p$ (**double negation
elimination**) are both tautologies: check every row of their truth tables
and the result is always 1. This is the "meaning-based" side of logic.
Truth is defined by checking every possible case, with no notion of proof
or derivation involved at all.

### Proof theory: natural deduction

**Provability**, by contrast, is a purely syntactic notion. A formula
$\varphi$ is **provable from hypotheses $\Gamma$** (a set of formulas),
written $\Gamma \vdash \varphi$, if there is a finite derivation of
$\varphi$ from $\Gamma$ built out of a fixed, finite list of allowed
**inference rules**. These are mechanical, symbol-pushing steps, checkable
by an algorithm with no appeal to "meaning" at all. **Natural deduction**
(Gentzen, 1934) is the standard system of such rules. Each connective gets
an **introduction rule** (how to *prove* a formula built with that
connective) and an **elimination rule** (how to *use* one once you have
it). Chapter 3 already showed you this pattern concretely (`⟨_, _⟩`
introduces `∧`, `.left` eliminates it) without naming it. Writing
$\Gamma, \varphi$ for "$\Gamma$ together with the extra hypothesis
$\varphi$":

$$
\text{($\wedge$-intro)}\ \ \frac{\Gamma \vdash \varphi \qquad \Gamma \vdash \psi}
{\Gamma \vdash \varphi \wedge \psi}
\qquad\qquad
\text{($\wedge$-elim)}\ \ \frac{\Gamma \vdash \varphi \wedge \psi}{\Gamma \vdash \varphi}
\ \ \ \frac{\Gamma \vdash \varphi \wedge \psi}{\Gamma \vdash \psi}
$$

$$
\text{($\vee$-intro)}\ \ \frac{\Gamma \vdash \varphi}{\Gamma \vdash \varphi \vee \psi}
\ \ \ \frac{\Gamma \vdash \psi}{\Gamma \vdash \varphi \vee \psi}
\qquad\qquad
\text{($\vee$-elim)}\ \ \frac{\Gamma \vdash \varphi \vee \psi \qquad \Gamma, \varphi \vdash \chi \qquad \Gamma, \psi \vdash \chi}{\Gamma \vdash \chi}
$$

$$
\text{($\Rightarrow$-intro)}\ \ \frac{\Gamma, \varphi \vdash \psi}{\Gamma \vdash \varphi \Rightarrow \psi}
\qquad\qquad
\text{($\Rightarrow$-elim, modus ponens)}\ \ \frac{\Gamma \vdash \varphi \Rightarrow \psi \qquad \Gamma \vdash \varphi}{\Gamma \vdash \psi}
$$

$$
\text{($\neg$-intro)}\ \ \frac{\Gamma, \varphi \vdash \bot}{\Gamma \vdash \neg\varphi}
\qquad\qquad
\text{($\bot$-elim, ex falso)}\ \ \frac{\Gamma \vdash \bot}{\Gamma \vdash \varphi}
$$

$\Rightarrow$-intro reads: "if, granting $\varphi$ as an extra
hypothesis, $\psi$ can be derived, then (discharging that hypothesis) one
may conclude $\varphi \Rightarrow \psi$ outright." This is exactly the
ordinary mathematical move "assume $\varphi$; ... ; therefore $\varphi
\Rightarrow \psi$," turned into an explicit, checkable rule. It is
*exactly* what Chapter 3 identified with writing a Lean function
`fun (hp : P) => ...`. Each rule above is stated once so it can be pointed
to by name. The list need not be memorized — the point is to recognize a
"natural deduction proof" as a *tree* built by chaining these rules, with
leaves at hypotheses in $\Gamma$ and its root at the conclusion $\varphi$.

**Worked example: proving $p \Rightarrow (q \Rightarrow p)$.** Assume $p$
as a hypothesis, aiming to apply $\Rightarrow$-intro at the end. Within
that, assume $q$ too. The conclusion $p$ is now already among the
hypotheses, so it is derived for free. Discharge the $q$-hypothesis via
$\Rightarrow$-intro to get $q \Rightarrow p$, then discharge the
$p$-hypothesis via $\Rightarrow$-intro again to get
$p \Rightarrow (q \Rightarrow p)$. As a derivation tree, with hypotheses
listed to the left of $\vdash$:

$$
\dfrac{\dfrac{p, q \vdash p}{p \vdash q \Rightarrow p}\ (\Rightarrow\text{-intro})}
{\vdash p \Rightarrow (q \Rightarrow p)}\ (\Rightarrow\text{-intro})
$$

[Chapter 3 §3](../03-propositions-and-proofs/03-implication.md) names this
exact formula "implication is a function type" and
gives the corresponding Lean term directly: `fun hp => fun hq => hp`.
The two are not just similar — under Curry–Howard they are literally the
same object, described twice.

### Soundness and completeness: proof theory meets semantics

Two theorems connect the syntactic notion ($\vdash$) to the semantic one
($\models$). Together they justify treating "provable" and "true in
every case" as interchangeable for propositional logic:

- **Soundness**: if $\Gamma \vdash \varphi$ then $\Gamma \models \varphi$.
  Everything the rules can derive really is true whenever the hypotheses
  are — the rules never let you "prove" something false.
- **Completeness** (Gödel, 1929, for first-order logic; the propositional
  case is elementary): if $\Gamma \models \varphi$ then $\Gamma \vdash
  \varphi$. Every semantically valid consequence *does* have a natural
  deduction proof, so the rule list above, small as it is, is not missing
  anything.

Soundness is usually the easy direction to prove (check that each rule
preserves truth); completeness is the harder theorem. Neither is used
again in this book, but together they are the reason a working
mathematician can trust that "prove it" and "it is necessarily true"
describe the same territory for propositional (and first-order) logic.
This guarantee stops holding once expressive enough systems are reached. (Gödel's *incompleteness* theorems are a different and unrelated
pair of results, despite the similar name — they show arithmetic itself
cannot be both complete and consistent.)

### First-order logic: adding quantifiers

Propositional logic treats "$n$ is prime" as one indivisible atom.
**First-order logic** (also called predicate logic) opens that up: fix a
domain of individuals, **predicates** $P(x), Q(x, y), \dots$ ranging over
it, and add two quantifiers to the grammar:

$$
\varphi ::= \cdots \;\mid\; \forall x.\, \varphi \;\mid\; \exists x.\, \varphi
$$

with natural deduction rules that generalize $\wedge$/$\vee$'s rules in the
obvious way. $\forall$-intro requires proving $\varphi$ for an *arbitrary,
otherwise-unconstrained* $x$ (exactly "let $x$ be arbitrary; ...; therefore
$\forall x, \varphi$" from ordinary proof-writing). $\exists$-intro
requires exhibiting one specific witness $a$ and a proof of $\varphi(a)$.
And $\exists$-elim lets you reason from "some $x$ satisfies $\varphi$" by
naming an arbitrary such $x$ and deriving the goal for it. This section's
job so far has been to show that the *quantifiers themselves*, and the
rules governing them, are standard first-order logic with no Lean involved
yet. The translation into Lean is deliberately left for the next
paragraph, so that it is clear which half is "ordinary logic already
familiar to the reader" and which half is "Curry–Howard's doing."

**First-order logic and Curry–Howard.** Chapter 3's table translated the
*propositional* connectives ($\wedge, \vee, \Rightarrow, \neg$) into type
formers. Quantifiers extend the same table, and this is the one place
where the translation genuinely needs *dependent* types rather than
ordinary ones, because $P(x)$ — the very thing being quantified over — is
a different proposition for each $x$:

| Logic | Type theory | Lean notation |
| --- | --- | --- |
| $\forall x{:}\alpha,\ P(x)$ | dependent function ($\Pi$-)type | `∀ x, P x` |
| $\exists x{:}\alpha,\ P(x)$ | dependent pair ($\Sigma$-)type | `∃ x, P x` |
| $\forall$-intro (arbitrary $x$, derive $\varphi$) | `fun x => ...` | building a term of `∀ x, P x` |
| $\forall$-elim (instantiate at $a$) | function application | `(h : ∀ x, P x) a : P a` |
| $\exists$-intro (witness $a$, proof $h$) | anonymous constructor | `⟨a, h⟩ : ∃ x, P x` |
| $\exists$-elim (unpack witness + proof) | pattern match / projection | `obtain ⟨a, h⟩ := ...`, `.1`/`.2` |

Read the first row concretely: $\forall x, P(x)$ becomes a *dependent*
function type precisely because its return type, $P(x)$, depends on the
very argument $x$ being fed in. An ordinary (non-dependent) function type
`α → β` would not be expressive enough, since `β` there is one fixed type,
not one proposition per `x`. This is exactly [Chapter 1
§3](../01-basics/03-dependent-types.md)'s "dependent
types" made concrete for the special case where the family being depended
on happens to land in `Prop` instead of `Type`. $\forall$-elim is nothing
more than ordinary function application: feed the function a specific
`a`, get back a proof of `P a`. The natural-deduction rule and the
programming-language operation are, again, not just similar but
*identical* — the same fact [Chapter 3
§3](../03-propositions-and-proofs/03-implication.md) already showed for
modus ponens and plain function application.

With this table in hand, the whole of first-order natural deduction —
every rule stated in this section — is visible as a special case of one
simple idea: *proofs are programs, and the specific shape of program a
proof compiles to (pair, function, tagged choice, dependent function,
dependent pair) is read off directly from the outermost connective or
quantifier of the proposition being proved.* Appendix B §4 makes this
fully rigorous for the dependent case, by showing $\Pi$ and $\Sigma$
inside the calculus of constructions itself, rather than only stating the
correspondence informally as this table does.

### Classical vs. intuitionistic: the fork that matters for this book

Every rule listed above is accepted by **both** classical and
**intuitionistic** logic. The two differ on exactly one further principle,
the **law of excluded middle**, $\varphi \vee \neg\varphi$ (equivalently,
double negation elimination $\neg\neg\varphi \Rightarrow \varphi$).
Classical logic takes it as an extra axiom, valid for every $\varphi$
regardless of whether you can exhibit a witness or decide the matter
constructively. Intuitionistic logic — the system natural deduction *as
given above* actually is, with no extra axiom added — rejects it as a
general principle: $\varphi \vee \neg\varphi$ is not derivable from the
rules above for an arbitrary $\varphi$, only for specific $\varphi$ that
can actually be settled one way or the other. ([Chapter 3
§4](../03-propositions-and-proofs/04-and-or-not.md)'s [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) works
because `1 = 2` happens to be *decidable*, not because excluded middle is
assumed.)

This is not just a side note: it is the precise reason Curry–Howard
works as cleanly as it does. A type-theoretic proof term is a genuine,
*constructive* witness. A Lean proof of $\exists x, P\, x$ computes to an
actual pair `⟨a, h⟩` that could be inspected via `#eval`, and that only makes
sense for a logic where "true" means "constructible" — which is exactly
intuitionistic logic. (Lean's core logic is intuitionistic for
precisely this reason. Mathlib freely adds classical excluded middle as an
axiom for propositions where a witness is not needed, but the base calculus
this book's Curry–Howard table describes in Chapter 3 does not include it.)
Keep this fork in mind when reading [Chapter 3
§4](../03-propositions-and-proofs/04-and-or-not.md)'s remark that Lean has
"no built-in law of excluded middle." It is this exact distinction, not
an incidental implementation detail.

## Next

Continue to [Untyped λ-calculus: terms and reduction](01-untyped-lambda-calculus.md).
There, the *type theory* side of Curry–Howard — what a "proof as a program"
actually computes with — gets the same from-scratch treatment this section
gave the logic side.

---

[← Index](00-index.md) | [Next: Untyped λ-calculus →](01-untyped-lambda-calculus.md)
