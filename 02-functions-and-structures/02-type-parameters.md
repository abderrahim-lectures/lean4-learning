## Structures with type parameters

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)

---

### Recall

Formal definitions cited in this section, gathered here for quick
reference (full citations in the [Bibliography](../bibliography.md)):

- **Type-parameterized structure.** This book's working statement:
  `structure Pair (α β : Type)` defines a whole *family* of products
  at once — one instance per choice of type arguments — categorically
  a functor of the type parameters, not a single fixed structure.
- **Parametric polymorphism.** After Milner ([Milner1978]), the
  theoretical account of type polymorphism that Python's `TypeVar`
  and Lean's `{α : Type} → ...` both implement to different degrees.
  Brief: genericity that is *proved* once for every type, checked
  before the generic code is ever called, unlike an optional/erased
  type annotation.

```lean
structure Pair (α β : Type) where
  fst : α
  snd : β

def p : Pair Nat String := { fst := 1, snd := "one" }

#eval p.fst    -- 1
#eval p.snd     -- "one"
```

This generalizes directly to how we will write, e.g., `structure Group (α : Type)`.

**Mathematical reading.** `Pair α β` is the ordinary binary Cartesian
product, but taken *uniformly*, as a functor of two arguments at once.
Rather than fixing $\alpha$ and $\beta$ once, `structure Pair (α β : Type)
where ...` defines the *whole family* of products $\alpha \times \beta$ at
once, one for every choice of the two type arguments. `Pair Nat String`
is then just this construction evaluated at the pair $(\mathbb{N},
\mathrm{String})$, giving $\mathbb{N} \times \mathrm{String}$. This is the
same "definition parameterized by objects of the category" idea that lets
us later write `Group (G : Type)`: not one group, but the functor sending
a carrier type $G$ to the type of group-structures on $G$.

**Programmer's corner (Python).** Python code like `def identity(x): return
x` or `class Pair: def __init__(self, fst, snd): ...` is also "generic" in
the sense that it does not mention any particular type. Nothing checks
that genericity until the code actually runs, however. Writing
`identity(3) + "oops"` causes Python to happily run `identity`, hand back
`3`, and only then break on `3 + "oops"` at runtime. Constructing a `Pair`
and placing a `Group (Fin 3)` into its `fst` draws no complaint from
Python. The closer analogue is `typing.TypeVar`: `def identity(x: T) -> T:
return x` *documents* the same universally quantified type `identity` has
in Lean, but that annotation is optional, erased at runtime, and enforced
only if a checker such as `mypy` is separately run — and nothing stops a
stray `# type: ignore` from silencing it. Lean's `{α : Type} → α → α` is
not documentation: it is *proved*, once, that `identity` works for every
type `α`, and that proof is checked before `identity` is ever called. It
is not merely approximated by a linter that might go unrun.

### References

Full citations in the [Bibliography](../bibliography.md). Formal
definitions are gathered in Recall, above.

- Python `typing` module documentation and mypy documentation ([PythonTyping], [MypyDocs]) — for the Python-side comparison used in this section's box.
- Milner ([Milner1978]) — parametric polymorphism.

[PythonTyping]: ../bibliography.md#pythontyping
[MypyDocs]: ../bibliography.md#mypydocs
[Milner1978]: ../bibliography.md#milner1978

---

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)
