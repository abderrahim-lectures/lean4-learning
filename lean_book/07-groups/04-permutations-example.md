## A non-abelian example: permutations of three elements

[← Integers example](03-integers-example.md) | [Index](00-index.md) | [Next: Accessing the fields →](05-accessing-fields.md)

---

`intGroup` is abelian, so `id_left` never differs from `id_right`, nor
`inv_left` from `inv_right`, since in a commutative group these coincide. Does
that mean the left/right split in the definition of `Group` is mere
caution, with nothing forcing it? Settling this needs a group where `op`
genuinely fails to commute, built the same way `intGroup` was, field by
field, with both directions checked honestly.

### The carrier: bijections of a 3-element set

The symmetric group $S_3$ is all bijections of a 3-element set, under
composition. Represent a permutation of `Fin 3 := {0, 1, 2}` as a
bijective function bundled with its inverse and the proofs that they
cancel, since an arbitrary `Fin 3 → Fin 3` need not be a bijection at all.

```lean
structure Perm3 where
  toFun : Fin 3 → Fin 3
  invFun : Fin 3 → Fin 3
  left_inv : ∀ x, invFun (toFun x) = x
  right_inv : ∀ x, toFun (invFun x) = x
```

### The group operation: composition

```lean
def Perm3.comp (f g : Perm3) : Perm3 where
  toFun := f.toFun ∘ g.toFun
  invFun := g.invFun ∘ f.invFun
  left_inv := by
    intro x
    show g.invFun (f.invFun (f.toFun (g.toFun x))) = x
    rw [f.left_inv]
    exact g.left_inv x
  right_inv := by
    intro x
    show f.toFun (g.toFun (g.invFun (f.invFun x))) = x
    rw [g.right_inv]
    exact f.right_inv x
```

`Perm3.comp f g` applies `g` first, then `f`, the standard convention.
Its inverse composes the two inverses in the opposite order
(`g.invFun ∘ f.invFun`): to undo "first $g$, then $f$," first undo $f$,
then undo $g$. This is $(fg)^{-1} = g^{-1}f^{-1}$, the fact Theorem 3 of
Chapter 8 (`inv_op`) proves abstractly for every group; here it is
visible in the construction itself.

```lean
def Perm3.identity : Perm3 where
  toFun := fun x => x
  invFun := fun x => x
  left_inv := fun _ => rfl
  right_inv := fun _ => rfl
```

```lean
def Perm3.inv (f : Perm3) : Perm3 where
  toFun := f.invFun
  invFun := f.toFun
  left_inv := f.right_inv
  right_inv := f.left_inv
```

`Perm3.inv` swaps `toFun` with `invFun`, and correspondingly swaps which
proof field plays which role: inverting a bijection swaps which
direction counts as forward.

### Two concrete permutations, and a computed proof they do not commute

```lean
-- Swap 0 and 1, leave 2 fixed.
def swap01 : Perm3 where
  toFun := fun x => match x with
    | 0 => 1 | 1 => 0 | 2 => 2
  invFun := fun x => match x with
    | 0 => 1 | 1 => 0 | 2 => 2
  left_inv := by intro x; match x with | 0 => rfl | 1 => rfl | 2 => rfl
  right_inv := by intro x; match x with | 0 => rfl | 1 => rfl | 2 => rfl
```

```lean
-- The 3-cycle 0 → 1 → 2 → 0.
def cycle012 : Perm3 where
  toFun := fun x => match x with
    | 0 => 1 | 1 => 2 | 2 => 0
  invFun := fun x => match x with
    | 0 => 2 | 1 => 0 | 2 => 1
  left_inv := by intro x; match x with | 0 => rfl | 1 => rfl | 2 => rfl
  right_inv := by intro x; match x with | 0 => rfl | 1 => rfl | 2 => rfl
```

```lean
#eval (Perm3.comp swap01 cycle012).toFun 0   -- 0
#eval (Perm3.comp cycle012 swap01).toFun 0   -- 2
```

Applying `cycle012` then `swap01` sends $0 \to 1 \to 0$; applying
`swap01` then `cycle012` sends $0 \to 1 \to 2$. `#eval` computes `0` and
`2`. This is a computed proof, not suggestive evidence, that
`Perm3.comp swap01 cycle012 ≠ Perm3.comp cycle012 swap01`: the group is
non-abelian. Chapter 9, Section 7 uses the same compute-a-counterexample
move for matrices.

### Assembling `Group Perm3`

```lean
theorem Perm3.ext {f g : Perm3} (h : ∀ x, f.toFun x = g.toFun x)
    (h' : ∀ x, f.invFun x = g.invFun x) : f = g := by
  cases f
  cases g
  simp only [mk.injEq]
  constructor
  · funext x; exact h x
  · funext x; exact h' x

def perm3Group : Group Perm3 where
  op := Perm3.comp
  id := Perm3.identity
  inv := Perm3.inv
  assoc := by
    intro f g h
    apply Perm3.ext
    · intro x; rfl
    · intro x; rfl
  id_left := by
    intro f
    apply Perm3.ext
    · intro x; rfl
    · intro x; rfl
  id_right := by
    intro f
    apply Perm3.ext
    · intro x; rfl
    · intro x; rfl
  inv_left := by
    intro f
    apply Perm3.ext
    · intro x; exact f.left_inv x
    · intro x; exact f.left_inv x
  inv_right := by
    intro f
    apply Perm3.ext
    · intro x; exact f.right_inv x
    · intro x; exact f.right_inv x
```

`Perm3.ext` is an extensionality lemma: two `Perm3`s are equal exactly
when their `toFun`s and `invFun`s each agree everywhere, the only two
fields that matter (proof fields do not, by proof irrelevance, Chapter
6). Each `Group` field reduces to this check; most cases are `rfl`
directly, and `inv_left`/`inv_right` cite exactly the proof obligations
already bundled into `Perm3`.

**Mathematical reading.** `Perm3` with composition is $S_3$, the
symmetric group on three letters, order $6$, the smallest non-abelian
group. `swap01` and `cycle012` are a transposition and a 3-cycle; together
they generate all of $S_3$, as in the standard presentation
$S_3 = \langle r, s \mid r^3 = s^2 = e,\ srs = r^{-1} \rangle$, with $r$ =
`cycle012` and $s$ = `swap01`.

**Mathlib equivalent.** All of `Perm3`/`Perm3.comp`/`Perm3.ext`/
`perm3Group` builds one thing: the group of bijections of a 3-element
set. [`Equiv.Perm`](https://loogle.lean-lang.org/?q=Equiv.Perm) is that model, ready-made, a [`Group`](https://loogle.lean-lang.org/?q=Group) instance for any type.

```lean
example : Group (Equiv.Perm (Fin 3)) := inferInstance

-- Swap 0 and 1, leave 2 fixed — the Mathlib analogue of `swap01`.
def swap01' : Equiv.Perm (Fin 3) := Equiv.swap 0 1

-- The 3-cycle 0 → 1 → 2 → 0 — the Mathlib analogue of `cycle012`.
def cycle012' : Equiv.Perm (Fin 3) := finRotate 3

#eval (swap01' * cycle012') 0   -- 0
#eval (cycle012' * swap01') 0    -- 2
```

No `Perm3` bundle, no hand-written extensionality lemma. `Equiv.Perm
(Fin 3)`, the type of bijections `Fin 3 ≃ Fin 3`, is already a group;
[`Equiv.swap`](https://loogle.lean-lang.org/?q=Equiv.swap) and [`finRotate`](https://loogle.lean-lang.org/?q=finRotate) construct a transposition and a rotation, `*` is
the registered operation matching `Perm3.comp`'s convention. The two
`#eval`s are the same non-commutativity witness, now on the library's
$S_3$.

## Next

Continue to [Accessing the fields](05-accessing-fields.md).

---

[← Integers example](03-integers-example.md) | [Index](00-index.md) | [Next: Accessing the fields →](05-accessing-fields.md)
