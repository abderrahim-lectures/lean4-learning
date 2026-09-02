## The mathematical definition

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating.md)

---

A `Monoid` (Chapter 6) has an associative operation and a two-sided
identity, nothing more; an element need not be undoable. What is the
weakest extra requirement that makes every element undoable? Not "some
element cancels it", since that already holds vacuously for the identity
itself paired with $e \cdot e = e$. The requirement has to hold for
*every* element, and it has to be witnessed, not merely asserted: for
each $a$ there must exist $a^{-1}$ with $a \cdot a^{-1} = a^{-1} \cdot a =
e$. Adding exactly this to the data of a monoid is the entire content of
this section, and it is what turns "a set with an associative operation"
into a structure with cancellation.

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

No further axiom is required; commutativity is not assumed (a group where
$a \cdot b = b \cdot a$ always holds is **abelian**, a strictly stronger
condition defined separately). The identity and inverse laws are each
stated in both a left and a right direction, and the two directions are
kept as separate axioms rather than collapsed into one. In an abelian
group the directions are logically equivalent, but with commutativity not
assumed each must be supplied on its own. [Section 4](04-permutations-example.md)
builds a non-abelian group, $S_3$, where this split is put to work.

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
