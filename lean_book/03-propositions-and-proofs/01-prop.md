## `Prop`: the type of statements

[← Index](00-index.md) | [Next: A recap of standard logic →](02-logic-recap.md)

---

Alongside `Type`, Lean has `Prop`, the type of logical propositions. A term
of type `P : Prop` is a **proof** of `P`. This is the **Curry–Howard
correspondence**: propositions are types, and proofs are programs.

### The Curry–Howard correspondence, in full

That one-line slogan is easy to state, but its importance is easy to miss
on first read. What follows is the full dictionary it stands for: a
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
type because a proof of $P \wedge Q$ is genuinely a *pair*: a proof of
$P$ together with a proof of $Q$. This is exactly the `⟨hp, hq⟩` seen
in the next section. "$P$ or $Q$" corresponds to a *sum* type because a
proof of $P \vee Q$ is a *choice*: either a proof of $P$ (tagged
`Or.inl`) or a proof of $Q$ (tagged `Or.inr`), never both, and never
neither. "Not $P$" being `P → False` says: a proof that $P$ is false is a
*procedure* that would turn any (hypothetical) proof of $P$ into a proof
of the impossible proposition `False`. In other words, it is a witness
that no such proof of $P$ could exist.

The correspondence goes deeper than just matching up connectives with
type formers, though. It also extends to *proofs themselves* behaving like
*programs*. Simplifying a proof (removing a detour, such as proving
$P \wedge Q$ and then immediately taking the left projection to recover a
proof of $P$) corresponds exactly to a program taking a computation step
(here, β-reduction eliminating a constructor immediately followed by the
matching projection). This is why Chapter 4's tactics, which *build*
proof terms, and Chapter 5's discussion of reduction and definitional
equality, are really talking about one and the same underlying process,
just seen from two angles. Proof simplification and program evaluation are
the same operation, described differently depending on whether the term
is regarded as "a proof" or "a computation."

> Read more: if "propositional logic" or "natural deduction" above are not
> already familiar, [the next section](02-logic-recap.md) recaps standard
> logic from scratch, with no Lean involved, before this correspondence
> gets applied to it. For the correspondence made fully precise — extending
> it all the way down to the untyped λ-calculus underneath both proofs and
> ordinary functions — see [Chapter 1 §4](../01-basics/05-pi-sigma-and-coc.md);
> [Chapter 5 §3](../05-rigor-check/03-typing-rules-and-safety.md)'s progress
> and preservation theorems are the formal statement of "a proof never
> reduces to something of the wrong type," i.e. "well-typed proofs do not
> go wrong."

```lean
#check (2 + 2 = 4)     -- 2 + 2 = 4 : Prop

example : 2 + 2 = 4 := rfl
```

[`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) is the proof "both sides compute to the same thing" (**refl**exivity).
`example` states a proposition and immediately supplies a proof (an
anonymous, unnamed `theorem`).

**Mathematical reading.** The Curry–Howard correspondence identifies a
proposition $P$ with the *set of its proofs*: $P$ is true exactly when
that set is nonempty, i.e. when there exists some term $p : P$ ("$P$ is
inhabited"). This is why `Prop` behaves like a truth value rather than an
ordinary type: every proposition's proof-set is either empty (false) or,
up to proof irrelevance, has exactly one element (true), with no
room for a "third" proof genuinely different from the rest. Proving $P$ is
exactly exhibiting an element $p \in P$; nothing more is meant by
"provable." The proof `rfl : 2 + 2 = 4` is the reflexivity
witness $\mathrm{refl}_4$ of the equality relation, valid precisely because
both sides reduce to the same normal form $4$. This is equality of terms
that are *definitionally* equal, the strictest notion of "$=$".

---

[← Index](00-index.md) | [Next: A recap of standard logic →](02-logic-recap.md)
