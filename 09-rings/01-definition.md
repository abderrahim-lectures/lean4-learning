## The mathematical definition

[← Index](00-index.md) | [Next: CommGroup →](02-comm-group.md)

---

A **ring** is a set $R$ with *two* binary operations, addition and
multiplication, such that:

$$
\begin{aligned}
\text{(R1)}&\quad (R, +, 0, -(-)) \text{ is a commutative group} \\
\text{(R2)}&\quad (a \cdot b) \cdot c = a \cdot (b \cdot c) \quad \text{(multiplication is associative)} \\
\text{(R3)}&\quad \exists\, 1 \in R,\ 1 \cdot a = a \text{ and } a \cdot 1 = a \quad \text{(multiplicative identity)} \\
\text{(R4)}&\quad a \cdot (b + c) = a \cdot b + a \cdot c, \quad (a + b) \cdot c = a \cdot c + b \cdot c \quad \text{(distributivity)}
\end{aligned}
$$

Some textbooks do not require a multiplicative identity. Such a structure
is called a *rng*. The missing "i" stands for the missing identity. This
book includes the identity, since that is the more common convention.

Note that (R1) requires **commutative** addition, unlike the general `Group` of
Chapter 7. Hence, before defining `Ring`, we first define what "commutative"
means as an extension of `Group`.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Ring.** A set with two binary operations, addition and
  multiplication, such that the set is an abelian group under addition,
  multiplication is associative and distributes over addition, and
  (in the convention this book follows) a multiplicative identity exists
  ([DummitFoote2003], Ch. 7 "Introduction to Rings," §7.1 "Basic
  Definitions and Examples"). Dummit and Foote's own base definition
  does *not* require a multiplicative identity, calling that weaker
  structure a ring "not necessarily with 1" and reserving "ring" by
  default for the identity-including case in most of the book's later
  chapters, the same choice (R3) above makes explicit. This is a
  structural citation to the section and its numbered axioms, not a
  verified word-for-word excerpt.

---

[← Index](00-index.md) | [Next: CommGroup →](02-comm-group.md)
