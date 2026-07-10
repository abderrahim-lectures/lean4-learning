## Worked example: proving `Nat.add` is commutative from scratch

[← More tactics](04-more-tactics.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

---

We want to show, for all `a b : Nat`, that `a + b = b + a`. Recall from
Chapter 1 that `Nat` is built from `zero` and `succ` (successor), and that
`+` is *defined* by recursion on its second argument:

$$
a + 0 = a, \qquad a + \mathrm{succ}(k) = \mathrm{succ}(a + k)
$$

We proceed by induction on `b`, one step at a time.

**Base case (`b = 0`).** The goal becomes `a + 0 = 0 + a`.

- The left side, `a + 0`, reduces to `a` directly from the definition of `+`
  above (this fact is recorded in core Lean as the lemma `Nat.add_zero`).
- The right side, `0 + a`, is *not* immediate from the definition (the
  recursion is on the second argument, not the first), so it needs its own
  small lemma, `Nat.zero_add : 0 + a = a`, proved separately by induction on
  `a`.
- Putting both together: `a + 0 = a` and `0 + a = a`, so `a + 0 = 0 + a`.

```lean
theorem my_add_comm (a b : Nat) : a + b = b + a := by
  induction b with
  | zero =>
    -- Goal: a + 0 = 0 + a
    rw [Nat.add_zero]   -- rewrites `a + 0` to `a`. Goal: a = 0 + a
    rw [Nat.zero_add]    -- rewrites `0 + a` to `a`. Goal: a = a, closed by rw automatically
  | succ k ih =>
    -- ih : a + k = k + a
    -- Goal: a + Nat.succ k = Nat.succ k + a
    rw [Nat.add_succ]     -- a + succ k  ~>  succ (a + k). Goal: succ (a + k) = succ k + a
    rw [ih]                -- use the induction hypothesis: a + k ~> k + a. Goal: succ (k + a) = succ k + a
    rw [Nat.succ_add]      -- succ k + a  ~>  succ (k + a). Goal: succ (k + a) = succ (k + a), closed
```

Walking through the inductive step slowly:

1. We are trying to prove the statement for `b = Nat.succ k`, assuming it
   already holds for `k` (that assumption is `ih : a + k = k + a`).
2. `rw [Nat.add_succ]` uses the defining equation `a + succ k = succ (a + k)`
   to rewrite the left-hand side of the goal.
3. `rw [ih]` uses the induction hypothesis to replace `a + k` with `k + a`
   inside the goal.
4. `rw [Nat.succ_add]` uses the equation `succ k + a = succ (k + a)` to
   rewrite the right-hand side, so both sides now read `succ (k + a)`,
   literally identical — `rw` closes the goal automatically once the two
   sides match syntactically.

This is the pattern — base case, inductive step, explicit `ih` — that we
will reuse, slowly and explicitly, for every proof about groups and rings.

**Mathematical reading.** This is the elementary proof that $(\mathbb{N},
+)$ is commutative, carried out by induction on the second argument from the
recursive definition $a + 0 = a$, $a + \mathrm{succ}(k) = \mathrm{succ}(a +
k)$. Writing $P(b) :\equiv (\forall a,\ a + b = b + a)$: the base case is
$P(0)$, needing the auxiliary $0 + a = a$ (proved separately since the
recursion favors the right argument), and the inductive step derives $P(k+1)$
from $P(k)$ via
$$
a + (k{+}1) = (a+k){+}1 \overset{\mathrm{ih}}{=} (k+a){+}1 = (k{+}1)+a.
$$
Each `rw` is one equational step in this chain; the whole proof is the
standard textbook lemma, with the successor/zero cases that written
mathematics usually glosses made fully explicit.

**Programmer's corner (Python).** The two cases of `induction b with |
zero => ... | succ k ih => ...` have exactly the shape of a recursive
function over the same inductively-defined structure. Compare to a
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

`add`'s `if isinstance(b, Zero)` branch is the base case; its recursive
call `add(a, b.pred)` is exactly the role `ih` plays in the `succ` branch —
"assume it already works for the smaller case, build the answer for one
`Succ` more." The proof isn't *using* an analogy to recursion — it *is* a
recursion, just one producing a proof term instead of a `Succ` value, which
is why Lean can generate `induction`'s two cases automatically straight
from `Nat`'s definition, the same way Python's `isinstance` cases fall
straight out of `Nat`'s two constructors.

---

[← More tactics](04-more-tactics.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)
