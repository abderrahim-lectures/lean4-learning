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

(Some textbooks don't require a multiplicative identity. That's called a
*rng* (missing the "i"). We include it, since that's the most common convention.)

Note that (R1) requires **commutative** addition, unlike our general `Group` from
Chapter 6. So before defining `Ring`, we first define what "commutative"
means as an extension of `Group`.

---

[← Index](00-index.md) | [Next: CommGroup →](02-comm-group.md)
