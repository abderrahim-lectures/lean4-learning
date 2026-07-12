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

That's all — there's no need for commutativity in general (a group where
$a \cdot b = b \cdot a$ always holds is called **abelian** or
**commutative**; we'll define that separately).

---

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating.md)
