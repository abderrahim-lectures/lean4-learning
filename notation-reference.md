# Notation reference

[Table of contents](README.md)

---

A lookup table connecting the mathematical notation used in this book's
prose to the corresponding Lean syntax used in its code. This page is a
quick reference, not something to read start to finish — every row is
built up and explained properly the first time it is needed, at the
chapter cited in the last column.

**Note:** `·` in mathematical prose maps to different Lean constructs
depending on context — see the two "Group multiplication" and "Scalar
action" rows below, which share the same math notation but translate to
different Lean operations (`Group.op` vs `SMul.smul`).

Two related pages cover notation this one deliberately leaves out: the
[tactic and library reference](tactic-and-library-reference.md) (tactics
and Mathlib declaration names) and the
[λ-calculus / type theory to Lean dictionary](lambda-calculus-dictionary.md)
(formal type-theory notation from the optional "Mathematical reading"
boxes). This page is just the ordinary logic/algebra symbols used
throughout the main text and code.

## Logic and quantifiers

| Meaning | Math notation | Lean syntax | First appears |
| --- | --- | --- | --- |
| Function type / implication | $A \to B$ | `A → B` | Chapter 1 |
| Universal quantifier ("for all") | $\forall x, P\, x$ | `∀ x, P x` | Chapter 3 |
| Existential quantifier ("there exists") | $\exists x, P\, x$ | `∃ x, P x` | Chapter 3 |
| Unique existence ("there exists a unique") | $\exists!\, x, P\, x$ | no single token — witnessed by supplying the value and a proof it is the only one | Chapter 1, Section 4 |
| Set/type membership | $x \in A$ | `x ∈ A` | Chapter 1 |
| Negation | $\neg P$ | `¬P` | Concept introduced Chapter 1 (terminology); formal use from Chapter 3 |
| Conjunction ("and") | $P \wedge Q$ | `P ∧ Q` (`And`) | Chapter 3 |
| Disjunction ("or") | $P \vee Q$ | `P ∨ Q` (`Or`) | Chapter 3 |
| Not equal | $a \neq b$ | `a ≠ b` | Chapter 3 |
| Turnstile ("the goal to prove") | $\Gamma \vdash P$ | the goal-state display (not typed by the user) | Chapter 4 |

## Algebra, structure, and diagrams

| Meaning | Math notation | Lean syntax | First appears |
| --- | --- | --- | --- |
| Definitional equality | $t \equiv t'$ | `rfl` closes the goal | Chapter 5, Section 4 |
| Reflexivity / the `rfl` tactic and term | — | `rfl` | Chapter 1 (tactic use, `#eval`/`#check`); Chapter 3 (as a proof term, e.g. `2+2=4 := rfl`) |
| Direct sum (modules) | $M \oplus N$ | `DirectSum M N` (custom structure, no `⊕` operator in code) | Chapter 10 |
| Isomorphism / equivalence | $A \simeq B$ | `A ≃ B` (`Equiv`) | Chapter 10 |
| Anonymous-constructor pairing | $\langle a, b \rangle$ | `⟨a, b⟩` | Chapter 1, Section 4 |
| Coercion (embedding) | — | `↑` (auto-coercion) | Chapter 1, Section 3 |
| Function composition | $g \circ f$ | `g ∘ f` | Chapter 1 |
| Group multiplication (a `Group`'s binary operation) | $a \cdot b$ | `op a b` (the `op` field of `Group G`) | Chapter 6 |
| Scalar/group action | $a \cdot b$ (or $r \cdot m$) | `a • b` (`SMul`) | Chapter 10 |
| Inverse | $a^{-1}$ | `a⁻¹` | Chapter 6 |
| Lambda abstraction ("sends to") | $x \mapsto e$ | `fun x => e` | Chapter 1 |
| Divisibility | $a \mid b$ | `a ∣ b` | Chapter 9 |
| Subset | $A \subseteq B$ | `A ⊆ B` | Chapter 10 |
| Cartesian product | $A \times B$ | `A × B` | Chapter 1 |
| Long/derivation arrow (diagrams) | $A \longrightarrow B$ | `⟶` (diagram labels only, not ordinary code) | Chapter 11, Sections 2–3 |
| Projections out of a product | $\pi_X, \pi_Y$ | `.1`/`.2`, or `.fst`/`.snd` | Chapter 1, Section 4 |

---

[Table of contents](README.md)
