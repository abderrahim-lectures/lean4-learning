## Structures with type parameters

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)

---

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
product, but taken *uniformly*, as a functor of two arguments at once:
rather than fixing $\alpha$ and $\beta$ once, `structure Pair (α β : Type)
where ...` defines the *whole family* of products $\alpha \times \beta$ at
once, one for every choice of the two type arguments — `Pair Nat String`
is then just this construction evaluated at the pair $(\mathbb{N},
\mathrm{String})$, giving $\mathbb{N} \times \mathrm{String}$. This is the
same "definition parameterized by objects of the category" idea that lets
us later write `Group (G : Type)` — not one group, but the functor sending
a carrier type $G$ to the type of group-structures on $G$.

**Programmer's corner (Python).** Python code like `def identity(x): return
x` or `class Pair: def __init__(self, fst, snd): ...` is also "generic" in
the sense that it doesn't mention any particular type — but nothing checks
that genericity until the code actually runs. Write `identity(3) + "oops"`
and Python happily executes `identity`, hands back `3`, and only then blows
up on `3 + "oops"` at runtime; write a `Pair` and put a `Group (Fin 3)` into
its `fst` and Python won't blink. The closer analogue is `typing.TypeVar`:
`def identity(x: T) -> T: return x` *documents* the same universally
quantified type `identity` has in Lean, but that annotation is optional,
erased at runtime, and only enforced if you separately run a checker like
`mypy` — and nothing stops a stray `# type: ignore` from silencing it.
Lean's `{α : Type} → α → α` is not documentation: it is *proved*, once,
that `identity` works for every type `α`, and that proof is checked before
`identity` is ever called, not approximated by a linter you might forget to
run.

---

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)
