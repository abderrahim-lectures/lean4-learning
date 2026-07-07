## Accessing nested fields

[← Integers example](04-integers-example.md) | [Index](00-index.md) | [Next: Matrices →](06-matrices.md)

---

```lean
#eval intRing.addGrp.op 3 4     -- 7  (addition, via the nested CommGroup)
#eval intRing.mul 3 4            -- 12 (multiplication)
#eval intRing.one                 -- 1
#eval intRing.addGrp.toGroup.inv 5   -- -5  (additive inverse, via Group inside CommGroup)
```

**Mathematical reading.** The chained projections walk down the tower of
forgetful functors $\mathbf{Ring} \to \mathbf{Ab} \to \mathbf{Grp}$:
`intRing.addGrp` applies $\mathbf{Ring}\to\mathbf{Ab}$ (recover $(\mathbb{Z},
+)$), and `.toGroup` applies $\mathbf{Ab}\to\mathbf{Grp}$, so
`intRing.addGrp.toGroup.inv 5` computes the additive inverse $-5$ in the
underlying group, while `intRing.mul`/`intRing.one` read off the
multiplicative data $\times$ and $1$. Nested dot-access is just evaluation of
these structure-forgetting maps.

---

[← Integers example](04-integers-example.md) | [Index](00-index.md) | [Next: Matrices →](06-matrices.md)
