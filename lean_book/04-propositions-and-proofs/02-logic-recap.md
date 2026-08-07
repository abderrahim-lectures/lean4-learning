## A recap of standard logic and logical calculus

[← `Prop`: the type of statements](01-prop.md) | [Index](00-index.md) | [Next: `theorem` and `lemma` →](03-theorem-lemma.md)

---

The previous section introduced the Curry–Howard correspondence by
translating logic directly into Lean types. It assumed that "propositional
logic," "$\vdash$," and "natural deduction" were at least half-familiar to
the reader. If they were not, this section is the missing prerequisite.
Skip ahead to [Chapter 4, Section 3](03-theorem-lemma.md) if propositional/first-order logic
is already comfortable territory. It is a self-contained recap of standard
mathematical logic, the *pre-Lean, pre-type-theory* version, exactly as it
is presented in a first logic course, so that the table in Section 1 has something
concrete on its "Logic" side to refer back to. Nothing here mentions Lean,
types, or programs; that translation was entirely the job of Section 1, and
[Chapter 2, Section 2](../02-terminology-and-coc/02-pi-sigma-and-coc.md) and
[Chapter 6, Section 3](../06-rigor-check/03-typing-rules-and-safety.md) build the
calculus those types compile down to. This section only fixes what the
logic itself is.

### Propositional logic: syntax

Fix a set of **propositional variables** (atomic statements) $p, q, r,
\dots$. These stand for sentences whose internal structure is not
analyzed, "it is raining," "$n$ is prime," anything with a definite truth
value. **Formulas** are built from these using the **connectives**.

$$
\varphi ::= p \;\mid\; \top \;\mid\; \bot \;\mid\; \neg\varphi \;\mid\;
\varphi \wedge \psi \;\mid\; \varphi \vee \psi \;\mid\;
\varphi \Rightarrow \psi
$$

Here $\varphi$ and $\psi$ are **metavariables**. Each stands for "some
already-built formula," not for one fixed formula repeated twice, so
$\varphi \wedge \psi$ permits any two formulas as its two sides (including,
as one case among many, the same formula on both sides). Read the grammar
as a propositional variable, "true," "false," "not $\varphi$," "$\varphi$
and $\psi$," "$\varphi$ or $\psi$," "$\varphi$ implies $\psi$." This is pure
syntax. A formula is just a string built by this grammar, nothing more.
Whether a formula is *true*, and whether it is *provable*, are two separate
questions, addressed next.

### Semantics: truth tables and validity

The truth value of a propositional variable is given by a **valuation**
$v : \{\text{variables}\} \to \{0, 1\}$ (an assignment of true or false to
each atom). Every valuation extends uniquely to all formulas by the
familiar truth tables.

| $\varphi$ | $\psi$ | $\varphi \wedge \psi$ | $\varphi \vee \psi$ | $\varphi \Rightarrow \psi$ | $\neg \varphi$ |
| --- | --- | --- | --- | --- | --- |
| 0 | 0 | 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 | 1 | 0 |

A formula is a **tautology** (valid, written $\models \varphi$) if it comes
out true under *every* valuation. For example, $p \vee \neg p$ (the **law
of excluded middle**) and $\neg\neg p \Rightarrow p$ (**double negation
elimination**) are both tautologies. Check every row of their truth tables
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
(Gentzen, 1935; independently, and in a different notation, Jaśkowski 1934)
is the standard system of such rules. Each connective gets
an **introduction rule** (how to *prove* a formula built with that
connective) and an **elimination rule** (how to *use* one once you have
it). Section 1 already showed this pattern concretely (`⟨_, _⟩` introduces `∧`,
`.left` eliminates it) without naming it. Writing $\Gamma, \varphi$ for
"$\Gamma$ together with the extra hypothesis $\varphi$," the rules are as follows.

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

$\Rightarrow$-intro reads as follows. If, granting $\varphi$ as an extra
hypothesis, $\psi$ can be derived, then (discharging that hypothesis) one
may conclude $\varphi \Rightarrow \psi$ outright. This is exactly the
ordinary mathematical move "assume $\varphi$; ... ; therefore $\varphi
\Rightarrow \psi$," turned into an explicit, checkable rule. It is
*exactly* what Section 1 identified with writing a Lean function
`fun (hp : P) => ...`. Each rule above is stated once so it can be pointed
to by name. The list need not be memorized. The point is to recognize a
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

[Chapter 4, Section 4 (Implication)](04-implication.md) names this exact formula
"implication is a function type" and gives the corresponding Lean term
directly: `fun hp => fun hq => hp`. The two are not just similar. Under
Curry–Howard they are literally the same object, described twice.

### Soundness and completeness: proof theory meets semantics

Two theorems connect the syntactic notion ($\vdash$) to the semantic one
($\models$). Together they justify treating "provable" and "true in
every case" as interchangeable for propositional logic.

- **Soundness**: if $\Gamma \vdash \varphi$ then $\Gamma \models \varphi$.
  Everything the rules can derive really is true whenever the hypotheses
  are. The rules never let you "prove" something false.
- **Completeness** (Gödel, 1929/1930, for first-order logic; the propositional
  case is elementary): if $\Gamma \models \varphi$ then $\Gamma \vdash
  \varphi$. Every semantically valid consequence *does* have a natural
  deduction proof, so the rule list above, small as it is, is not missing
  anything.

Soundness is usually the easy direction to prove (check that each rule
preserves truth). Completeness is the harder theorem. Neither is used
again in this book, but together they are the reason a working
mathematician can trust that "prove it" and "it is necessarily true"
describe the same territory for propositional (and first-order) logic.
This guarantee stops holding once expressive enough systems are reached.
(The *incompleteness* theorems of Gödel are a different and unrelated pair of
results, despite the similar name. They show arithmetic itself cannot be
both complete and consistent.)

### First-order logic: adding quantifiers

Propositional logic treats "$n$ is prime" as one indivisible atom.
**First-order logic** (also called predicate logic) opens that up. Fix a
domain of individuals, **predicates** $P(x), Q(x, y), \dots$ ranging over
it, and add two quantifiers to the grammar.

$$
\varphi ::= \cdots \;\mid\; \forall x.\, \varphi \;\mid\; \exists x.\, \varphi
$$

The natural deduction rules generalize the rules for $\wedge$/$\vee$ in the
obvious way. $\forall$-intro requires proving $\varphi$ for an *arbitrary,
otherwise-unconstrained* $x$ (exactly "let $x$ be arbitrary; ...; therefore
$\forall x, \varphi$" from ordinary proof-writing). $\exists$-intro
requires exhibiting one specific witness $a$ and a proof of $\varphi(a)$.
And $\exists$-elim lets you reason from "some $x$ satisfies $\varphi$" by
naming an arbitrary such $x$ and deriving the goal for it. The job of this section
so far has been to show that the *quantifiers themselves*, and the
rules governing them, are standard first-order logic with no Lean involved
yet. The translation into Lean is deliberately left for the next
paragraph, so that it is clear which half is "ordinary logic already
familiar to the reader" and which half is the doing of Curry–Howard.

**First-order logic and Curry–Howard.** The table in Section 1 translated the
*propositional* connectives ($\wedge, \vee, \Rightarrow, \neg$) into type
formers. Quantifiers extend the same table, and this is the one place
where the translation genuinely needs *dependent* types rather than
ordinary ones, because $P(x)$, the very thing being quantified over, is
a different proposition for each $x$.

| Logic | Type theory | Lean notation |
| --- | --- | --- |
| $\forall x{:}\alpha,\ P(x)$ | dependent function ($\Pi$-)type | `∀ x, P x` |
| $\exists x{:}\alpha,\ P(x)$ | dependent pair ($\Sigma$-)type | `∃ x, P x` |
| $\forall$-intro (arbitrary $x$, derive $\varphi$) | `fun x => ...` | building a term of `∀ x, P x` |
| $\forall$-elim (instantiate at $a$) | function application | `(h : ∀ x, P x) a : P a` |
| $\exists$-intro (witness $a$, proof $h$) | anonymous constructor | `⟨a, h⟩ : ∃ x, P x` |
| $\exists$-elim (unpack witness + proof) | pattern match / projection | `obtain ⟨a, h⟩ := ...`, `.1`/`.2` |

Read the first row concretely. $\forall x, P(x)$ becomes a *dependent*
function type precisely because its return type, $P(x)$, depends on the
very argument $x$ being fed in. An ordinary (non-dependent) function type
`α → β` would not be expressive enough, since `β` there is one fixed type,
not one proposition per `x`. This is exactly the "dependent
types" of [Chapter 1,
Section 3](../01-basics/03-dependent-types.md), made concrete for the special case where the family being depended
on happens to land in `Prop` instead of `Type`. $\forall$-elim is nothing
more than ordinary function application: feed the function a specific
`a`, get back a proof of `P a`. The natural-deduction rule and the
programming-language operation are, again, not just similar but
*identical*, the same fact already shown for modus ponens and plain function application by
[Chapter 4, Section 4 (Implication)](04-implication.md).

With this table in hand, the whole of first-order natural deduction,
every rule stated in this section, is visible as a special case of one
simple idea. Proofs are programs, and the specific shape of program a
proof compiles to (pair, function, tagged choice, dependent function,
dependent pair) is read off directly from the outermost connective or
quantifier of the proposition being proved. [Chapter 1,
Section 5](../02-terminology-and-coc/02-pi-sigma-and-coc.md) makes this fully rigorous for the
dependent case, by showing $\Pi$ and $\Sigma$ inside the calculus of
constructions itself, rather than only stating the correspondence
informally as this table does.

### Classical vs. intuitionistic: the fork that matters for this book

Every rule listed above is accepted by **both** classical and
**intuitionistic** logic. The two differ on exactly one further principle,
the **law of excluded middle**, $\varphi \vee \neg\varphi$ (equivalently,
double negation elimination $\neg\neg\varphi \Rightarrow \varphi$).
Classical logic takes it as an extra axiom, valid for every $\varphi$
regardless of whether you can exhibit a witness or decide the matter
constructively. Intuitionistic logic, the system natural deduction *as
given above* actually is, with no extra axiom added, rejects it as a
general principle. $\varphi \vee \neg\varphi$ is not derivable from the
rules above for an arbitrary $\varphi$, only for specific $\varphi$ that
can actually be settled one way or the other. (The [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)
tactic in [Section 4 (And, Or, Not)](05-and-or-not.md)
works because `1 = 2` happens to be *decidable*, not because excluded
middle is assumed.)

This is not just a side note. It is the precise reason Curry–Howard
works as cleanly as it does. A type-theoretic proof term is a genuine,
*constructive* witness. A Lean proof of $\exists x, P\, x$ computes to an
actual pair `⟨a, h⟩` that could be inspected via `#eval`, and that only
makes sense for a logic where "true" means "constructible," which is
exactly intuitionistic logic. (The core logic of Lean is intuitionistic for
precisely this reason. Mathlib freely adds classical excluded middle as an
axiom for propositions where a witness is not needed, but the base
calculus described by the Curry–Howard table of this book in Section 1 does not include
it.) Keep this fork in mind when reading the remark in [Section 4 (And, Or,
Not)](05-and-or-not.md) that Lean has "no built-in law of excluded
middle." It is this exact distinction, not an incidental implementation
detail.

---

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Natural deduction.** "À chacun des signes logiques &, ∨, ∀, ∃, ⊃,
  ¬, appartient exactement une figure de déduction qui « introduit » ce
  signe — comme signe terminal d'une formule — et une figure qui
  l'« élimine »... Les introductions représentent pour ainsi dire les
  « définitions » des signes qu'elles concernent, et les éli[minations
  ...]" (quote breaks at a page boundary in the source excerpt)
  ([FeysLadriere1955], §II "Le calcul de la déduction naturelle," p.
  27; a French translation of Gentzen ([Gentzen1935])). Picture it
  like this. A Lego instruction booklet where every piece type gets
  exactly two entries, one showing how to snap it onto the model
  (introduction), one showing what you're allowed to do once it's
  there (elimination). Introduction rules act as the "definition" of the connective,
  elimination rules as its consequence.
- **Soundness.** "$\Gamma \vdash \varphi \Rightarrow \Gamma \models
  \varphi$" ([VanDalen2013], §2.5, Lemma 2.5.1). Picture it like this.
  A factory whose quality-control process is airtight. If a product
  passes inspection, it is guaranteed to actually work. Nothing merely
  "provable" turns out to be false.
- **Completeness.** "$\Gamma \vdash \varphi \Leftrightarrow \Gamma
  \models \varphi$" ([VanDalen2013], §2.5 Theorem 2.5.13 for
  propositional logic; §4.1 Theorem 4.1.3 for first-order logic;
  first-order completeness is originally due to Gödel, 1929/1930,
  not independently verified against the original paper by Gödel, see
  [VanDalen2013] for the identical statement independently verified
  here). Picture it like this. The converse guarantee. The same
  factory inspection process is thorough enough that every product
  which genuinely works *can* be certified by it. Nothing true slips
  through as "uncertifiable."
- van Dalen ([VanDalen2013]), §2.4 "Natural Deduction" (Definition 2.4.1, propositional rules), §3.8 "Natural Deduction" (first-order ∀-rules, Lemma 3.8.2) covers the propositional and first-order natural-deduction rules underlying the quotes above.
- Gödel: the original 1930 completeness paper was not independently verified against a held source. Theorem 4.1.3 of van Dalen above states the same result and is independently verified.
- Pierce et al. ([PierceSF]). **Note:** only the *Software Foundations* series homepage is available in the notebook, not chapter content, so the specific natural-deduction/classical-vs-intuitionistic treatment claimed here could not be verified verbatim.

[Gentzen1935]: ../bibliography.md#gentzen1935
[FeysLadriere1955]: ../bibliography.md#feysladriere1955
[VanDalen2013]: ../bibliography.md#vandalen2013
[Godel1930]: ../bibliography.md#godel1930
[PierceSF]: ../bibliography.md#piercesf

---

[← `Prop`: the type of statements](01-prop.md) | [Index](00-index.md) | [Next: `theorem` and `lemma` →](03-theorem-lemma.md)
