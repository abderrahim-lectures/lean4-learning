## The mathematical definition

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating.md)

---

The checkpoint project of Chapter 5 asked for a `Monoid`, a set with an
associative operation and a two-sided identity, built entirely from the
bundling techniques of Chapters 1–5, with no inverses required. A group is
the natural next question a monoid forces: what happens once every
element is also required to be *undoable*? Adding that one further axiom
is the entire content of the opening definition of this chapter, and it is
what turns "a set with an associative operation" into the richer
structure, with cancellation, and eventually genuine theorems reusable
across every group at once, that the rest of Part II builds on.

A **group** is a set $G$ together with:

- a binary operation $\cdot : G \times G \to G$,
- a distinguished element $e \in G$ (the identity),
- an inverse function $(-)^{-1} : G \to G$,

satisfying three axioms, for all $a, b, c \in G$:

$$
\begin{aligned}
\text{(associativity)} &\quad (a \cdot b) \cdot c = a \cdot (b \cdot c) \\
\text{(identity)} &\quad e \cdot a = a \quad\text{and}\quad a \cdot e = a \\
\text{(inverse)} &\quad a^{-1} \cdot a = e \quad\text{and}\quad a \cdot a^{-1} = e
\end{aligned}
$$

No further axiom is required; in particular, commutativity is not assumed in general (a group where
$a \cdot b = b \cdot a$ always holds is called **abelian** or
**commutative**, defined separately below).

---

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Group.** A set $G$ with a binary operation, identity, and
  inverses satisfying associativity and the identity/inverse laws
  (below); consequences of these axioms, e.g. "the identity of $G$ is
  unique ... for each $a \in G$, $a^{-1}$ is uniquely determined"
  ([DummitFoote2003], §1.1 "Basic Axioms and Examples," p. 17,
  Proposition 1).
- Aluffi ([Aluffi2009]) is offered as further reading, not an independently verified factual claim. The use of forgetful functors and universal properties by Aluffi is publicly documented in the table of contents of the book itself, not quoted from a verified excerpt.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003
[Aluffi2009]: ../bibliography.md#aluffi2009

---

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating.md)
