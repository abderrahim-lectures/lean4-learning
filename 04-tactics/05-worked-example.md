## Worked example: proving `Nat.add` is commutative from scratch

[← More tactics](04-more-tactics.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

---

The goal is to show, for all `a b : Nat`, that `a + b = b + a`. Recall from
Chapter 1 that `Nat` is built from `zero` and `succ` (successor), and that
`+` is *defined* by recursion on its second argument:

$$
a + 0 = a, \qquad a + \mathrm{succ}(k) = \mathrm{succ}(a + k)
$$

The proof proceeds by induction on `b`, one step at a time.

**Base case (`b = 0`).** The goal becomes `a + 0 = 0 + a`.

- The left side, `a + 0`, reduces to `a` directly from the definition of `+`
  above (this fact is recorded in core Lean as the lemma `Nat.add_zero`).
- The right side, `0 + a`, is *not* immediate from the definition, since the
  recursion is on the second argument, not the first. It therefore needs its own
  small lemma, `Nat.zero_add : 0 + a = a`, proved separately by induction on
  `a`.
- Combining both: `a + 0 = a` and `0 + a = a`, hence `a + 0 = 0 + a`.

<p><a href="https://live.lean-lang.org/#code=theorem%20my_add_comm%20%28a%20b%20%3A%20Nat%29%20%3A%20a%20%2B%20b%20%3D%20b%20%2B%20a%20%3A%3D%20by%0A%20%20induction%20b%20with%0A%20%20%7C%20zero%20%3D%3E%0A%20%20%20%20--%20Goal%3A%20a%20%2B%200%20%3D%200%20%2B%20a%0A%20%20%20%20rw%20%5BNat.add_zero%5D%20%20%20--%20rewrites%20%60a%20%2B%200%60%20to%20%60a%60.%20Goal%3A%20a%20%3D%200%20%2B%20a%0A%20%20%20%20rw%20%5BNat.zero_add%5D%20%20%20%20--%20rewrites%20%600%20%2B%20a%60%20to%20%60a%60.%20Goal%3A%20a%20%3D%20a%2C%20closed%20by%20rw%20automatically%0A%20%20%7C%20succ%20k%20ih%20%3D%3E%0A%20%20%20%20--%20ih%20%3A%20a%20%2B%20k%20%3D%20k%20%2B%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%20Nat.succ%20k%20%3D%20Nat.succ%20k%20%2B%20a%0A%20%20%20%20rw%20%5BNat.add_succ%5D%20%20%20%20%20--%20a%20%2B%20succ%20k%20%20~%3E%20%20succ%20%28a%20%2B%20k%29.%20Goal%3A%20succ%20%28a%20%2B%20k%29%20%3D%20succ%20k%20%2B%20a%0A%20%20%20%20rw%20%5Bih%5D%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%20use%20the%20induction%20hypothesis%3A%20a%20%2B%20k%20~%3E%20k%20%2B%20a.%20Goal%3A%20succ%20%28k%20%2B%20a%29%20%3D%20succ%20k%20%2B%20a%0A%20%20%20%20rw%20%5BNat.succ_add%5D%20%20%20%20%20%20--%20succ%20k%20%2B%20a%20%20~%3E%20%20succ%20%28k%20%2B%20a%29.%20Goal%3A%20succ%20%28k%20%2B%20a%29%20%3D%20succ%20%28k%20%2B%20a%29%2C%20closed" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20my_add_comm%20%28a%20b%20%3A%20Nat%29%20%3A%20a%20%2B%20b%20%3D%20b%20%2B%20a%20%3A%3D%20by%0A%20%20induction%20b%20with%0A%20%20%7C%20zero%20%3D%3E%0A%20%20%20%20--%20Goal%3A%20a%20%2B%200%20%3D%200%20%2B%20a%0A%20%20%20%20rw%20%5BNat.add_zero%5D%20%20%20--%20rewrites%20%60a%20%2B%200%60%20to%20%60a%60.%20Goal%3A%20a%20%3D%200%20%2B%20a%0A%20%20%20%20rw%20%5BNat.zero_add%5D%20%20%20%20--%20rewrites%20%600%20%2B%20a%60%20to%20%60a%60.%20Goal%3A%20a%20%3D%20a%2C%20closed%20by%20rw%20automatically%0A%20%20%7C%20succ%20k%20ih%20%3D%3E%0A%20%20%20%20--%20ih%20%3A%20a%20%2B%20k%20%3D%20k%20%2B%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%20Nat.succ%20k%20%3D%20Nat.succ%20k%20%2B%20a%0A%20%20%20%20rw%20%5BNat.add_succ%5D%20%20%20%20%20--%20a%20%2B%20succ%20k%20%20~%3E%20%20succ%20%28a%20%2B%20k%29.%20Goal%3A%20succ%20%28a%20%2B%20k%29%20%3D%20succ%20k%20%2B%20a%0A%20%20%20%20rw%20%5Bih%5D%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%20use%20the%20induction%20hypothesis%3A%20a%20%2B%20k%20~%3E%20k%20%2B%20a.%20Goal%3A%20succ%20%28k%20%2B%20a%29%20%3D%20succ%20k%20%2B%20a%0A%20%20%20%20rw%20%5BNat.succ_add%5D%20%20%20%20%20%20--%20succ%20k%20%2B%20a%20%20~%3E%20%20succ%20%28k%20%2B%20a%29.%20Goal%3A%20succ%20%28k%20%2B%20a%29%20%3D%20succ%20%28k%20%2B%20a%29%2C%20closed" title="Lean playground" loading="lazy" style="width:100%;height:288px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Walking through the inductive step slowly:

1. The statement is to be proved for `b = Nat.succ k`, assuming it
   already holds for `k` (that assumption is `ih : a + k = k + a`).
2. [`rw [Nat.add_succ]`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) uses the defining equation `a + succ k = succ (a + k)`
   to rewrite the left-hand side of the goal.
3. `rw [ih]` uses the induction hypothesis to replace `a + k` with `k + a`
   inside the goal.
4. `rw [Nat.succ_add]` uses the equation `succ k + a = succ (k + a)` to
   rewrite the right-hand side, so both sides now read `succ (k + a)`,
   which are literally identical. `rw` closes the goal automatically once the two
   sides match syntactically.

This is the pattern — base case, inductive step, explicit `ih` — that
recurs, slowly and explicitly, for every proof about groups and rings.

**Mathematical reading.** This is the elementary proof that $(\mathbb{N},
+)$ is commutative, carried out by induction on the second argument from the
recursive definition $a + 0 = a$, $a + \mathrm{succ}(k) = \mathrm{succ}(a +
k)$. Writing $P(b) :\equiv (\forall a,\ a + b = b + a)$: the base case is
$P(0)$, which needs the auxiliary fact $0 + a = a$ (proved separately since the
recursion favors the right argument). The inductive step derives $P(k+1)$
from $P(k)$ via
$$
a + (k{+}1) = (a+k){+}1 \overset{\mathrm{ih}}{=} (k+a){+}1 = (k{+}1)+a.
$$
Each `rw` is one equational step in this chain. The whole proof is the
standard textbook lemma, with the successor/zero cases spelled out in full,
where written mathematics usually skips over them.

**Programmer's corner (Python).** The two cases of [`induction b with |
zero => ... | succ k ih => ...`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) have exactly the shape of a recursive
function over the same inductively-defined structure. Compare it to a
hand-rolled Peano type in Python:

```python
class Zero: pass
class Succ:
    def __init__(self, pred): self.pred = pred

def add(a, b):
    if isinstance(b, Zero):
        return a                          # base case, like `| zero =>`
    return Succ(add(a, b.pred))            # recursive call, like `| succ k ih =>`
```

`add`'s `if isinstance(b, Zero)` branch is the base case. Its recursive
call `add(a, b.pred)` plays exactly the role `ih` plays in the `succ` branch:
"assume it already works for the smaller case, build the answer for one
`Succ` more." The proof is not merely *analogous* to recursion, it *is* a
recursion, one producing a proof term instead of a `Succ` value. This is
why Lean can generate `induction`'s two cases automatically straight
from `Nat`'s definition, the same way Python's `isinstance` cases fall
straight out of `Nat`'s two constructors.

---

[← More tactics](04-more-tactics.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)
