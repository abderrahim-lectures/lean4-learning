# Notation reference

[Table of contents](README.md)

---

A lookup table connecting the mathematical notation used in the prose of
this book to the corresponding Lean syntax used in its code. This page is a
quick reference, not something to read start to finish. Every row is
*earned*, not just introduced, at the chapter cited in the last column
(see [Pedagogical approach](README.md#pedagogical-approach)): the symbol
appears here only as a shorthand for reasoning already carried out in
full there.

**Note:** `·` in mathematical prose maps to different Lean constructs
depending on context. See the two "Group multiplication" and "Module
scalar action" rows below. They share the same math notation but
translate to different Lean operations, `Group.op` versus `SMul.smul`.

Two related pages cover notation this one deliberately leaves out, the
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
| Universal quantifier ("for all") | $\forall x, P\, x$ | `∀ x, P x` | Chapter 4 |
| Existential quantifier ("there exists") | $\exists x, P\, x$ | `∃ x, P x` | Chapter 4 |
| Unique existence ("there exists a unique") | $\exists!\, x, P\, x$ | no single token, witnessed by supplying the value and a proof it is the only one | Chapter 2, Section 1 |
| Set/type membership | $x \in A$ | `x ∈ A` | Chapter 11, Section 4 (Chapter 1 only contrasts $\in$ against Lean's `:` for term-has-type, never uses the `∈` operator itself) |
| Negation | $\neg P$ | `¬P` | Concept introduced Chapter 1 (terminology); formal use from Chapter 4 |
| Conjunction ("and") | $P \wedge Q$ | `P ∧ Q` (`And`) | Chapter 4 |
| Disjunction ("or") | $P \vee Q$ | `P ∨ Q` (`Or`) | Chapter 4 |
| Not equal | $a \neq b$ | `a ≠ b` | Chapter 4 |
| Turnstile ("the goal to prove") | $\Gamma \vdash P$ | the goal-state display (not typed by the user) | Chapter 5 |

## Algebra, structure, and diagrams

| Meaning | Math notation | Lean syntax | First appears |
| --- | --- | --- | --- |
| Definitional equality | $t \equiv t'$ | `rfl` closes the goal | Chapter 6, Section 4 |
| Reflexivity / the `rfl` tactic and term | — | `rfl` | Chapter 1 (tactic use, `#eval`/`#check`); Chapter 4 (as a proof term, e.g. `2+2=4 := rfl`) |
| Direct sum (modules) | $M \oplus N$ | `DirectSum M N` (custom structure, no `⊕` operator in code) | Chapter 11 |
| Isomorphism / equivalence | $A \simeq B$ | `A ≃ B` (`Equiv`) | Chapter 7 (`Equiv.Perm`, Mathlib equivalent box) |
| Anonymous-constructor pairing | $\langle a, b \rangle$ | `⟨a, b⟩` | Chapter 2, Section 1 |
| Coercion (embedding) | — | `↑` (auto-coercion) | Chapter 1, Section 3 |
| Function composition | $g \circ f$ | `g ∘ f` | Chapter 1 |
| Group multiplication (the binary operation of a `Group`) | $a \cdot b$ | `op a b` (the `op` field of `Group G`) | Chapter 7 |
| Module scalar action (a ring element acting on a module element) | $r \cdot m$ | `r • m` (`SMul`) | Chapter 11 |
| Inverse | $a^{-1}$ | `a⁻¹` | Chapter 7 |
| Lambda abstraction ("sends to") | $x \mapsto e$ | `fun x => e` | Chapter 1 |
| Divisibility | $a \mid b$ | `a ∣ b` | Chapter 10 |
| Subset (subobject inclusion) | $A \subseteq B$ | no infix operator; expressed via `extends` (`CommGroup` includes `Group`) or a `carrier : M → Prop` membership predicate (submodules) — the book never uses a literal `⊆`/`≤` Lean token | Chapter 2, Section 1 (categorical use); Chapter 11, Section 4 (submodule use) |
| Cartesian product | $A \times B$ | `A × B` | Chapter 1 |
| Long/derivation arrow (diagrams) | $A \longrightarrow B$ | `⟶` (diagram labels only, not ordinary code) | Chapter 12, Sections 2–3 |
| Projections out of a product | $\pi_X, \pi_Y$ | `.1`/`.2`, or `.fst`/`.snd` | Chapter 2, Section 1 |

---

[Table of contents](README.md)
