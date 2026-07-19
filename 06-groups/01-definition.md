## The mathematical definition

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating.md)

---

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

Full citations in the [Bibliography](../bibliography.md).

- Dummit and Foote ([DummitFoote2003]) — the standard classical (non-Lean) reference for the group axioms above and their consequences.
- Aluffi ([Aluffi2009]) — a group-theory treatment using the same categorical framing (forgetful functors, universal properties) this book uses from Chapter 6 §6 onward.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003
[Aluffi2009]: ../bibliography.md#aluffi2009

---

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating.md)
