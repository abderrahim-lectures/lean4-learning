/-
Mathlib-equivalent code for Chapter 6 (Structures and classes: defining a
`Group`). Kept in its own module, alongside the from-scratch `Ch06Groups`,
so it's obvious at a glance which file needs the (heavy) Mathlib import and
which doesn't. See `00-setup/04-mathlib-note.md` and the README for why the
book pairs a from-scratch example with a Mathlib one throughout Chapters
6-11.
-/
import Mathlib

-- §3 Mathlib equivalent: `Int` is already registered as an `AddCommGroup`,
-- so there is no `intGroup`-style bundle to build by hand — the instance
-- already exists, and the axioms are available as free-standing lemmas
-- that apply to *every* additive group, not just `Int`.
example : AddCommGroup Int := inferInstance

example (a b c : Int) : (a + b) + c = a + (b + c) := add_assoc a b c
example (a : Int) : 0 + a = a := zero_add a
example (a : Int) : a + 0 = a := add_zero a
example (a : Int) : -a + a = 0 := neg_add_cancel a
example (a : Int) : a + -a = 0 := add_neg_cancel a

-- §4 Mathlib equivalent: the non-abelian example. Mathlib's stock model of
-- "bijections of a finite type" is `Equiv.Perm`, already a `Group` for any
-- type — no hand-rolled `Perm3`/`Group Perm3` bundle needed.
example : Group (Equiv.Perm (Fin 3)) := inferInstance

-- `Equiv.swap 0 1` swaps 0 and 1 and fixes everything else — the Mathlib
-- analogue of `swap01`.
def swap01' : Equiv.Perm (Fin 3) := Equiv.swap 0 1

-- `finRotate 3` is the 3-cycle `0 ↦ 1 ↦ 2 ↦ 0` — the Mathlib analogue of
-- `cycle012`.
def cycle012' : Equiv.Perm (Fin 3) := finRotate 3

-- Same "compute a witness of non-commutativity" move as the book's
-- `swap01`/`cycle012` example, now against Mathlib's permutation group.
#eval (swap01' * cycle012') 0   -- 0
#eval (cycle012' * swap01') 0    -- 2

-- §5 Mathlib equivalent: accessing fields. `intGroup.op 3 4` had to project
-- a field out of a hand-built bundle; here `+`/`0`/`-` already resolve to
-- the `AddCommGroup Int` instance's operations directly, and `add_assoc`
-- is exactly the "proof, for every a b c" `intGroup.assoc` was.
#eval (3 : Int) + 4
#eval (0 : Int)
#eval -(5 : Int)
#check (add_assoc : ∀ a b c : Int, (a + b) + c = a + (b + c))

-- §6 Mathlib equivalent: "prove it once, get it for free everywhere" is not
-- a promise this book has to redeem later — it's how Mathlib's hierarchy
-- already works. The *same* lemma name, `mul_assoc`/`add_assoc`, applies
-- unchanged to two utterly different groups.
example (a b c : Int) : (a + b) + c = a + (b + c) := add_assoc a b c
example (f g h : Equiv.Perm (Fin 3)) : (f * g) * h = f * (g * h) := mul_assoc f g h
