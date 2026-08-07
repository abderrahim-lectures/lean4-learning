## `Prop`: the type of statements

[← Index](00-index.md) | [Next: A recap of standard logic →](02-logic-recap.md)

---

Chapter 3 closed with structures bundling data and proofs side by side,
without yet saying what a "proof," as a piece of Lean data, actually is.
That gap closes here. Chapters 1 and 3 built terms and types for
ordinary mathematical objects, numbers, points, groups-to-be, and this
chapter turns the same machinery on *statements* and their proofs.
Alongside `Type`, Lean has `Prop`, the type of logical propositions. A term
of type `P : Prop` is a **proof** of `P`. This is the **Curry–Howard
correspondence**. Propositions are types, and
proofs are programs.

### The Curry–Howard correspondence, in full

That one-line slogan is easy to state, but its importance is easy to miss
on first read. What follows is the full dictionary it stands for, a
two-way correspondence between logical connectives and type formers. This
book uses each row repeatedly, starting in the next few
sections.

| Logic | Type theory | Lean notation |
| --- | --- | --- |
| proposition $P$ | type $P$ | `P : Prop` |
| proof of $P$ | term of type $P$ | `p : P` |
| $P$ implies $Q$ | function type | `P → Q` |
| $P$ and $Q$ | product type | `P ∧ Q` |
| $P$ or $Q$ | sum (coproduct) type | `P ∨ Q` |
| false | empty type (no constructors) | `False` |
| not $P$ | function type to the empty type | `¬P` (:= `P → False`) |
| for all $x$, $P(x)$ | dependent function (Π-) type | `∀ x, P x` |
| there exists $x$ with $P(x)$ | dependent pair (Σ-)type | `∃ x, P x` |
| proof by cases on a disjunction | pattern match / [`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) | `Or.elim`, `cases h with ...` |
| a direct proof (construction) | a term built from constructors | `⟨_, _⟩`, `Or.inl _`, `fun x => _` |

Consider a few rows concretely. "$P$ and $Q$" corresponds to a *product*
type because a proof of $P \wedge Q$ is genuinely a *pair*, a proof of
$P$ together with a proof of $Q$. This is exactly the `⟨hp, hq⟩` seen
in the next section. "$P$ or $Q$" corresponds to a *sum* type because a
proof of $P \vee Q$ is a *choice*, either a proof of $P$ (tagged
`Or.inl`) or a proof of $Q$ (tagged `Or.inr`), never both, and never
neither. "Not $P$" being `P → False` says that a proof that $P$ is false is a
*procedure* that would turn any (hypothetical) proof of $P$ into a proof
of the impossible proposition `False`. In other words, it is a witness
that no such proof of $P$ could exist.

The correspondence goes deeper than just matching up connectives with
type formers, though. It also extends to *proofs themselves* behaving like
*programs*. Simplifying a proof (removing a detour, such as proving
$P \wedge Q$ and then immediately taking the left projection to recover a
proof of $P$) corresponds exactly to a program taking a computation step
(here, β-reduction eliminating a constructor immediately followed by the
matching projection). This is why the tactics of Chapter 5, which *build*
proof terms, and the discussion of reduction and definitional
equality in Chapter 6, are really talking about one and the same underlying process,
just seen from two angles. Proof simplification and program evaluation are
the same operation, described differently depending on whether the term
is regarded as "a proof" or "a computation."

> Read more. If "propositional logic" or "natural deduction" above are not
> already familiar, [the next section](02-logic-recap.md) recaps standard
> logic from scratch, with no Lean involved, before this correspondence
> gets applied to it. [Chapter 2, Section 2](../02-terminology-and-coc/02-pi-sigma-and-coc.md)
> makes the correspondence fully precise, extending it down to the untyped
> λ-calculus underneath both proofs and ordinary functions.
> The progress
> and preservation theorems of [Chapter 6, Section 3](../06-rigor-check/03-typing-rules-and-safety.md) are the formal statement of "a proof never
> reduces to something of the wrong type," i.e. "well-typed proofs do not
> go wrong."

```lean
#check (2 + 2 = 4)     -- 2 + 2 = 4 : Prop

example : 2 + 2 = 4 := rfl
```

[`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) is the proof "both sides compute to the same thing" (**refl**exivity).
`example` states a proposition and immediately supplies a proof (an
anonymous, unnamed `theorem`).

**Programmer's corner (Python).** A Python function that needs a
precondition to hold usually states it with `assert`.

```python
def divide(a: int, b: int) -> int:
    assert b != 0, "b must not be zero"
    return a // b
```

That `assert` is a promise, not a proof. It says "this had better be
true," and finds out whether it actually was only at the moment
`divide` runs, on whichever inputs happen to reach it in production. A
caller three modules away that forgot to check for zero first gets a
crash discovered by a user, not by a type checker. In Lean, the
corresponding function does not assert `b ≠ 0`. It *requires* a proof
of `b ≠ 0` as an ordinary argument, and Curry-Howard is exactly what
makes that possible, since `b ≠ 0` is a type and a proof of it is a
term of that type, checkable the same way any other argument is
checked.

```lean
def safeDivide (a b : Nat) (h : b ≠ 0) : Nat := a / b
```

Calling `safeDivide 10 0 proof` for some `proof : (0 : Nat) ≠ 0` cannot
type-check, because no such proof exists to supply, `0 ≠ 0` being
false. The precondition is not documentation and not a runtime check
racing against whatever inputs show up first. It is part of the type of
`safeDivide` itself, verified once, for every call site, before the
program runs at all.

**Mathematical reading.** The Curry–Howard correspondence identifies a
proposition $P$ with the *set of its proofs*. $P$ is true exactly when
that set is nonempty, i.e. when there exists some term $p : P$ ("$P$ is
inhabited"). This is why `Prop` behaves like a truth value rather than an
ordinary type. Every proof-set of a proposition is either empty (false) or,
up to proof irrelevance, has exactly one element (true), with no
room for a "third" proof genuinely different from the rest. Proving $P$ is
exactly exhibiting an element $p \in P$; nothing more is meant by
"provable." The proof `rfl : 2 + 2 = 4` is the reflexivity
witness $\mathrm{refl}_4$ of the equality relation, valid precisely because
both sides reduce to the same normal form $4$. This is equality of terms
that are *definitionally* equal, the strictest notion of "$=$".

---

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Curry–Howard correspondence.** "The fact that the rules for
  implication in a proof system for natural deduction correspond
  exactly to the rules governing abstraction and application for
  functions is an instance of the Curry-Howard isomorphism, sometimes
  known as the propositions-as-types paradigm" ([TPIL4], "Propositions
  and Proofs"; the correspondence traces to a 1969 manuscript by Howard, circulated privately and formally published as [Howard1980]). The name
  carries two people because the observation is older than the paper by Howard.
  Curry noticed the correspondence between implicational formulas and
  combinator types in 1934, and Howard extended and sharpened it in 1969
  (Wadler, "Propositions as Types," *CACM* 58(12), 2015: "a correspondence
  observed by Curry in 1934 and refined by Howard in 1969"). Picture
  it like this. A mathematical claim is a blueprint, and a valid proof
  is an actual working machine built to that blueprint. There is no
  separate "proof of correctness" apart from having successfully built
  the machine, which is exactly why, in Lean, propositions are types
  and proofs are the terms (the "machines") that inhabit them.
- Howard ([Howard1980]) is the original source of the correspondence this section is named for. Per Sørensen & Urzyczyn, *Lectures on the Curry-Howard Isomorphism*, Studies in Logic and the Foundations of Mathematics vol. 149, Elsevier, 2006 (a secondary source corroborating this history, not the paper by Howard itself), the manuscript by Howard was "privately circulated" from 1969 and not formally published until 1980, in a Festschrift for Curry. It develops the proofs-as-terms correspondence for implicational logic, extends it to the other propositional connectives, then to a term language for Heyting Arithmetic.

[Howard1980]: ../bibliography.md#howard1980
[TPIL4]: ../bibliography.md#tpil4

---

[← Index](00-index.md) | [Next: A recap of standard logic →](02-logic-recap.md)
