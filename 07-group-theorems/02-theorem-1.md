## Theorem 1: the identity is unique

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)

---

**Claim.** If `e' : G` also satisfies `∀ a, Grp.op e' a = a`, then
`e' = Grp.id`.

**Finding the proof.** We begin by stating the goal and examining what is
available:

<p><a href="https://live.lean-lang.org/#code=theorem%20id_unique%20%28e%27%20%3A%20G%29%20%28h%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20Grp.op%20e%27%20a%20%3D%20a%29%20%3A%20e%27%20%3D%20Grp.id%20%3A%3D%20by%0A%20%20sorry" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20id_unique%20%28e%27%20%3A%20G%29%20%28h%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20Grp.op%20e%27%20a%20%3D%20a%29%20%3A%20e%27%20%3D%20Grp.id%20%3A%3D%20by%0A%20%20sorry" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

The goal is `e' = Grp.id`, an equality between two elements of `G` about
which we individually know very little: `e'` only through `h`, and `Grp.id`
only through `Grp`'s own axioms. **When a goal is "show two opaque things
are equal," the standard move is to find a *third* expression that both
sides equal on their own, then chain the two equalities.** We ask: is there
anything both `e'` and `Grp.id` can be related to?

`h` lets us compute `Grp.op e' a` for *any* `a` — in particular for
`a := Grp.id`, giving `Grp.op e' Grp.id = Grp.id`. Separately, `Grp.id_right`
(a field of `Group`, so available for free) says `Grp.op e' Grp.id = e'`
(instantiating its universal quantifier at `e'`). Both describe
`Grp.op e' Grp.id` — that is the third expression. Once this is noticed, the
proof is a matter of bookkeeping:

<p><a href="https://live.lean-lang.org/#code=theorem%20id_unique%20%28e%27%20%3A%20G%29%20%28h%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20Grp.op%20e%27%20a%20%3D%20a%29%20%3A%20e%27%20%3D%20Grp.id%20%3A%3D%20by%0A%20%20have%20step1%20%3A%20Grp.op%20e%27%20Grp.id%20%3D%20Grp.id%20%3A%3D%20h%20Grp.id%0A%20%20have%20step2%20%3A%20Grp.op%20e%27%20Grp.id%20%3D%20e%27%20%3A%3D%20Grp.id_right%20e%27%0A%20%20rw%20%5B%E2%86%90%20step2%5D%0A%20%20exact%20step1" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20id_unique%20%28e%27%20%3A%20G%29%20%28h%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20Grp.op%20e%27%20a%20%3D%20a%29%20%3A%20e%27%20%3D%20Grp.id%20%3A%3D%20by%0A%20%20have%20step1%20%3A%20Grp.op%20e%27%20Grp.id%20%3D%20Grp.id%20%3A%3D%20h%20Grp.id%0A%20%20have%20step2%20%3A%20Grp.op%20e%27%20Grp.id%20%3D%20e%27%20%3A%3D%20Grp.id_right%20e%27%0A%20%20rw%20%5B%E2%86%90%20step2%5D%0A%20%20exact%20step1" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Why `rw [← step2]` and not `rw [step2]`? The goal is `e' = Grp.id`, and
`step2 : Grp.op e' Grp.id = e'` has `e'` on its *right*. `rw [step2]` would
rewrite the goal's `Grp.op e' Grp.id`, but the goal does not yet contain
that term — it contains `e'`. `rw [← step2]` rewrites right-to-left,
replacing `e'` (which the goal *does* contain) with `Grp.op e' Grp.id`.
This right-to-left choice, "which side of the `have` actually appears in
the goal at present," is something to check every time `rw` is invoked, not
something to guess.

**Mathematical reading.** This is the classical *uniqueness of the identity*:
if $e'$ is a left identity ($e'\cdot a = a$ for all $a$) then $e' = e$. The
one-line proof is
$$
e' \overset{\text{id\_right}}{=} e' \cdot e \overset{h}{=} e,
$$
evaluating the hypothesis at $a = e$ and comparing with the axiom $e'\cdot e
= e'$: both compute $e' \cdot e$, so $e' = e$. The two `have`s are these two
equalities, and the `rw`/`exact` glue them at their common expression $e'\cdot
e$: the standard "two things equal to a common third are equal." (The
same argument in mirror shows a right identity is also unique, so a group's
identity is unique, full stop.)

**Mathlib equivalent.** Phrased against Mathlib's [`Group`](https://loogle.lean-lang.org/?q=Group) class, `Grp.op`/
`Grp.id`/`Grp.id_right` become the ordinary `*`/`1`/[`mul_one`](https://loogle.lean-lang.org/?q=mul_one), and the
whole "third expression" chain collapses into a single `.symm.trans`:

<p><a href="https://live.lean-lang.org/#code=example%20%7BG%20%3A%20Type%2A%7D%20%5BGroup%20G%5D%20%28e%27%20%3A%20G%29%20%28h%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20e%27%20%2A%20a%20%3D%20a%29%20%3A%20e%27%20%3D%201%20%3A%3D%0A%20%20%28mul_one%20e%27%29.symm.trans%20%28h%201%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%7BG%20%3A%20Type%2A%7D%20%5BGroup%20G%5D%20%28e%27%20%3A%20G%29%20%28h%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20e%27%20%2A%20a%20%3D%20a%29%20%3A%20e%27%20%3D%201%20%3A%3D%0A%20%20%28mul_one%20e%27%29.symm.trans%20%28h%201%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This is the same proof, the same two facts glued at their common value
$e'\cdot 1$: `h 1` is the book's `step1` and `mul_one e'` is `step2`. The
only difference is that `1` is written for `Grp.id`, and there is no
field-projection to spell out, since `*`/`1` already mean "whatever this
type's `Group` instance says they mean."

---

[← Setup](01-setup.md) | [Index](00-index.md) | [Next: Theorem 2 →](03-theorem-2.md)
