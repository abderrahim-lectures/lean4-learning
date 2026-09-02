## Chapter 1: First steps

[← Index](00-index.md) | [Next: Chapter 2 →](02-chapter-2.md)

---

**1. Is `Nat.succ : Nat → Nat` a Π-type?**

Yes. `∀ n : Nat, Nat` is a Π-type whose body happens not to mention the
bound variable. Every ordinary function type is a Π-type in the
degenerate case where the codomain is constant. "Dependent" describes
the *interesting* instances, where the codomain does mention the bound
variable, not a separate kind of arrow from the Π-type.

**2. `Vec.toList : Vec α n → List α`**

```lean
def Vec.toList : Vec α n → List α
  | Vec.nil => []
  | Vec.cons a rest => a :: Vec.toList rest
```

The type of `Vec.replicate`, `(n : Nat) → Vec α n`, is genuinely dependent. The
*return* type `Vec α n` mentions `n`, the value just supplied as the
argument. The type of `Vec.toList`, `Vec α n → List α`, is not. Its return
type `List α` never mentions `n` at all, even though its *argument* type
happens to be dependent (`Vec α n`, one specific type per length). Taking
a dependently-typed *input* does not automatically make a function
dependent; what matters is whether the *output* type varies with the
*value* of the input. `Vec.toList` throws the length away on the way out, the
same way the own length information of `Vec α n` disappears once converted to
a plain `List α`.

Unlike `Vec`, `List` does have a `Repr` instance for any printable `α`,
so the recursion of `Vec.toList` can be watched directly with `dbg_trace`,
using `Vec.replicate` (Chapter 1, Section 3) to build a concrete input.

```lean
def Vec.toList' : Vec α n → List α
  | Vec.nil => dbg_trace s!"toList: nil, base case, returning []"; []
  | Vec.cons a rest =>
      dbg_trace s!"toList: cons, prepending one element, recursing on the rest";
      a :: Vec.toList' rest

#eval Vec.toList' (Vec.replicate (7 : Int) 3)
-- toList: cons, prepending one element, recursing on the rest
-- toList: cons, prepending one element, recursing on the rest
-- toList: cons, prepending one element, recursing on the rest
-- toList: nil, base case, returning []
-- [7, 7, 7]
```

Three `cons` lines print before the `nil` line, one per element of the
length-3 vector, and only once the base case is reached does the fully
assembled `[7, 7, 7]` print, the same "peel off constructors, print on
the way down, assemble the result on the way back up" shape as every
other traced recursion in this book.

---

[← Index](00-index.md) | [Next: Chapter 2 →](02-chapter-2.md)
