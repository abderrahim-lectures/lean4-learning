## A non-abelian example: permutations of three elements

[← Integers example](03-integers-example.md) | [Index](00-index.md) | [Next: Accessing the fields →](05-accessing-fields.md)

---

`intGroup` is abelian ($a + b = b + a$), so it never tests the
distinction between `id_left`/`id_right` or `inv_left`/`inv_right`. In a
commutative group these coincide, so a reader could wrongly think that
the left/right split in `Group`'s definition was just being overly
careful. It isn't: here is a small, fully concrete, genuinely
**non-abelian** group, built the same way `intGroup` was, field by field.

### The carrier: bijections of a 3-element set

The symmetric group $S_3$ consists of all bijections (permutations) of a
3-element set, under composition. We represent a permutation of
`Fin 3 := {0, 1, 2}` as a bijective function bundled with its own inverse
and the proofs that they cancel:

```lean
structure Perm3 where
  toFun : Fin 3 → Fin 3
  invFun : Fin 3 → Fin 3
  left_inv : ∀ x, invFun (toFun x) = x
  right_inv : ∀ x, toFun (invFun x) = x
```

This is the same "bundle data with the proofs that make it well-behaved"
pattern as `Group` itself. `Perm3` doesn't just carry a function, it
carries the *proof* that the function is invertible, since an arbitrary
`Fin 3 → Fin 3` need not be a bijection at all.

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

`Perm3.comp f g` composes `f` *after* `g` (apply `g.toFun` first, then
`f.toFun`). This is the standard function-composition convention. Its
inverse composes the two inverses in the *opposite* order
(`g.invFun ∘ f.invFun`), which is exactly $(fg)^{-1} = g^{-1}f^{-1}$, the
same "reverse the order" fact Chapter 7's Theorem 3
(`inv_op`) proves abstractly for every group. Here you can see concretely
*why* it's true: to undo "first $g$, then $f$," you must first undo $f$,
then undo $g$.

```lean
def Perm3.identity : Perm3 where
  toFun := fun x => x
  invFun := fun x => x
  left_inv := fun _ => rfl
  right_inv := fun _ => rfl
```

`Perm3.identity` is the identity permutation: it fixes every point, so
both of its proof fields are immediate by `rfl`.

```lean
def Perm3.inv (f : Perm3) : Perm3 where
  toFun := f.invFun
  invFun := f.toFun
  left_inv := f.right_inv
  right_inv := f.left_inv
```

`Perm3.inv` inverts a permutation by swapping its `toFun` and `invFun`,
and it correspondingly swaps which proof field (`left_inv` or
`right_inv`) plays which role, since inverting a bijection just swaps
which direction counts as "forward."

### Two concrete permutations, and a computed proof they don't commute

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

`swap01` is the permutation that swaps `0` and `1` while leaving `2`
fixed.

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

`cycle012` is the 3-cycle sending $0 \to 1 \to 2 \to 0$.

```lean
#eval (Perm3.comp swap01 cycle012).toFun 0   -- 0
#eval (Perm3.comp cycle012 swap01).toFun 0   -- 2
```

Both compositions send `0` somewhere, but to *different* places: applying
`cycle012` then `swap01` sends $0 \to 1 \to 0$, while applying `swap01`
then `cycle012` sends $0 \to 0 \to 1$. Concretely, `#eval` reports `0` for
the first and `2` for the second. This is **directly computed evidence**
that `Perm3.comp swap01 cycle012 ≠ Perm3.comp cycle012 swap01`, in other
words, that this group is genuinely non-abelian. This is exactly the kind
of "compute a counterexample" move Chapter 8 uses again for matrices. It
is cheaper than any hand-written non-commutativity proof, and it hands
you, for free, the specific pair of elements that fail to commute.

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

`Perm3.ext` is a small helper (an *extensionality* lemma, in the same
spirit as Chapter 8's `Mat2.mk.injEq`-based reasoning): two `Perm3`s are
equal exactly when their `toFun`s agree everywhere *and* their `invFun`s
agree everywhere, since those are `Perm3`'s only two fields (the proof
fields don't matter, by proof irrelevance, Chapter 5). Each `Group` field
is then proved by reducing to this extensionality check and confirming
both functions involved agree pointwise. Most cases are `rfl` directly
(both sides compute to the same function once unfolded), and `inv_left`/
`inv_right` cite exactly `f.left_inv`/`f.right_inv`, the proof obligations
already bundled into `Perm3` itself.

**Mathematical reading.** `Perm3` (with composition) is $S_3$, the
symmetric group on three letters. It is the smallest non-abelian group
(order $6$) and the standard first example in any course covering
non-commutative groups. `swap01` and `cycle012` here are, respectively, a
transposition and a 3-cycle, generating all of $S_3$ between them, exactly
as in the usual presentation $S_3 = \langle r, s \mid r^3 = s^2 = e,\ srs
= r^{-1} \rangle$ (with $r = $ `cycle012`, $s = $ `swap01`).

**Mathlib equivalent.** All of `Perm3`/`Perm3.comp`/`Perm3.ext`/
`perm3Group` above exists to build one thing: "the group of bijections of a
3-element set." Mathlib's ready-made model of exactly that is `Equiv.Perm`,
already a `Group` instance for *any* type:

```lean
example : Group (Equiv.Perm (Fin 3)) := inferInstance

-- Swap 0 and 1, leave 2 fixed — the Mathlib analogue of `swap01`.
def swap01' : Equiv.Perm (Fin 3) := Equiv.swap 0 1

-- The 3-cycle 0 → 1 → 2 → 0 — the Mathlib analogue of `cycle012`.
def cycle012' : Equiv.Perm (Fin 3) := finRotate 3

#eval (swap01' * cycle012') 0   -- 0
#eval (cycle012' * swap01') 0    -- 2
```

No `Perm3` bundle, no hand-written extensionality lemma, no field-by-field
`Group` construction is needed: `Equiv.Perm (Fin 3)` (the type of bijections
`Fin 3 ≃ Fin 3`) is already known to be a group, `Equiv.swap` and
`finRotate` are Mathlib's own constructors for a transposition and a
rotation, and `*` is the already-registered group operation (composition,
matching `Perm3.comp`'s convention). The two `#eval`s are the same
"compute a witness of non-commutativity" move as `swap01`/`cycle012`
above, now applied to the library's own $S_3$.

## Next

Continue to [Accessing the fields](05-accessing-fields.md).

---

[← Integers example](03-integers-example.md) | [Index](00-index.md) | [Next: Accessing the fields →](05-accessing-fields.md)
