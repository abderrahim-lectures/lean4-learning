## The mathematical definition

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating.md)

---

### Recall

Formal definitions cited in this section, gathered here for quick
reference (full citations in the [Bibliography](../bibliography.md)):

- **Group.** A set $G$ with a binary operation, identity, and
  inverses satisfying associativity and the identity/inverse laws
  (below); consequences of these axioms, e.g. "the identity of $G$ is
  unique ... for each $a \in G$, $a^{-1}$ is uniquely determined"
  ([DummitFoote2003], §1.1 "Basic Axioms and Examples," p. 17,
  Proposition 1).

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

### References

Full citations in the [Bibliography](../bibliography.md). Formal
definitions are gathered in Recall, above.

- Dummit and Foote ([DummitFoote2003]), §1.1 "Basic Axioms and Examples," p. 17 — group axioms, uniqueness of identity/inverses.
- Aluffi ([Aluffi2009]) — **Gap:** not held in either notebook (see `NOTEBOOK-SOURCE-GAPS.md`); this recommendation is offered as further reading, not an independently verified factual claim — Aluffi's use of forgetful functors and universal properties is publicly documented in the book's own table of contents, not quoted from a verified excerpt.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003
[Aluffi2009]: ../bibliography.md#aluffi2009

---

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating.md)
