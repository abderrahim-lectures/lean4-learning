## Example: every abelian group is a $\mathbb{Z}$-module

[← Translating into Lean](02-translating-into-lean.md) | [Index](00-index.md) | [Next: Submodules →](04-submodules.md)

---

This is the standard first example, and a good one to build by hand,
because the scalar action isn't given as data. It has to be *defined*, by
repeated addition, from the group structure alone.

```lean
-- n • m for n : Nat, by iterating `op`.
def natSmul {M : Type} (Grp : Group M) (n : Nat) (m : M) : M :=
  match n with
  | Nat.zero => Grp.id
  | Nat.succ k => Grp.op m (natSmul Grp k m)

-- extend to n : Int by using `inv` on negative n.
def intSmul {M : Type} (CG : CommGroup M) (n : Int) (m : M) : M :=
  match n with
  | Int.ofNat k => natSmul CG.toGroup k m
  | Int.negSucc k => CG.toGroup.inv (natSmul CG.toGroup (k + 1) m)
```

`natSmul Grp n m` is literally $m + m + \cdots + m$ ($n$ times). It's
defined by recursion on `n`, in exactly the way `Nat.add` itself was
defined (Chapter 4). `intSmul` extends it to negative integers using the
group inverse. Given any `CG : CommGroup M`, you can then check that
`intSmul CG` satisfies (M1)–(M4) against `intRing` (Chapter 8). This is a
genuine, if somewhat long, proof by induction on the integer scalar, in the
same spirit as Chapter 4's `my_add_comm`. We leave the full verification as
an extended exercise, since doing it yourself is the best way to see *why*
modules over $\mathbb{Z}$ are forced, not chosen: `intSmul` is the *unique*
action that turns any abelian group into a $\mathbb{Z}$-module, because
(M4) plus (M1)/(M2) pin down $n \cdot m$ for every integer $n$ by
induction, leaving no freedom.

**Mathematical reading.** This constructs the canonical $\mathbb{Z}$-action
on any abelian group. `natSmul` is the
$\mathbb{N}$-action $n\cdot m = \underbrace{m + \cdots + m}_{n}$ (the
$n$-fold sum, with $0\cdot m = 0$), and `intSmul` extends it to $\mathbb{Z}$
by $(-n)\cdot m = -(n\cdot m)$. This is forced: since $\mathbb{Z}$ is the
[initial](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
ring, there is a unique ring map $\mathbb{Z} \to
\mathrm{End}(M)$ for any abelian group $M$ (it must send $1 \mapsto
\mathrm{id}_M$, hence $n \mapsto n\cdot\mathrm{id}_M$). So the $\mathbb{Z}$-
module structure is unique. "Abelian group" and "$\mathbb{Z}$-module" are
literally the same notion. The recursion mirrors the definition of
multiplication-as-iterated-addition.

**Mathlib equivalent.** Mathlib does not leave "every abelian group is
(uniquely) a $\mathbb{Z}$-module" as an exercise. It's registered as an
instance, available for *any* `AddCommGroup` at all, with no
`natSmul`/`intSmul` to define or verify by hand:

```lean
example {M : Type*} [AddCommGroup M] : Module Int M := inferInstance
```

The book builds the action from nothing (`natSmul` by recursion, then
`intSmul` by extending to negative integers via `inv`) and leaves the
four-axiom verification as an extended exercise. Mathlib's instance already
carries that proof. This follows from exactly the uniqueness argument in
the mathematical reading above, done once in the library instead of once
per abelian group encountered.

---

[← Translating into Lean](02-translating-into-lean.md) | [Index](00-index.md) | [Next: Submodules →](04-submodules.md)
