## Structures with type parameters

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)

---

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch02Structures%0A%0Astructure%20Point%20where%0A%20%20x%20%3A%20Nat%0A%20%20y%20%3A%20Nat%0A%0Adef%20origin%20%3A%20Point%20%3A%3D%20%7B%20x%20%3A%3D%200%2C%20y%20%3A%3D%200%20%7D%0A%0A%23eval%20origin.x%20%20%20%20%20%20%20%20--%200%0A%0Adef%20shift%20%28p%20%3A%20Point%29%20%28dx%20dy%20%3A%20Nat%29%20%3A%20Point%20%3A%3D%0A%20%20%7B%20x%20%3A%3D%20p.x%20%2B%20dx%2C%20y%20%3A%3D%20p.y%20%2B%20dy%20%7D%0A%0A%23eval%20%28shift%20origin%203%204%29.y%20%20%20--%204%0A%0Astructure%20Pair%20%28%CE%B1%20%CE%B2%20%3A%20Type%29%20where%0A%20%20fst%20%3A%20%CE%B1%0A%20%20snd%20%3A%20%CE%B2%0A%0Adef%20p%20%3A%20Pair%20Nat%20String%20%3A%3D%20%7B%20fst%20%3A%3D%201%2C%20snd%20%3A%3D%20%22one%22%20%7D%0A%0A%23eval%20p.fst%20%20%20%20--%201%0A%23eval%20p.snd" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch02Structures%0A%0Astructure%20Point%20where%0A%20%20x%20%3A%20Nat%0A%20%20y%20%3A%20Nat%0A%0Adef%20origin%20%3A%20Point%20%3A%3D%20%7B%20x%20%3A%3D%200%2C%20y%20%3A%3D%200%20%7D%0A%0A%23eval%20origin.x%20%20%20%20%20%20%20%20--%200%0A%0Adef%20shift%20%28p%20%3A%20Point%29%20%28dx%20dy%20%3A%20Nat%29%20%3A%20Point%20%3A%3D%0A%20%20%7B%20x%20%3A%3D%20p.x%20%2B%20dx%2C%20y%20%3A%3D%20p.y%20%2B%20dy%20%7D%0A%0A%23eval%20%28shift%20origin%203%204%29.y%20%20%20--%204%0A%0Astructure%20Pair%20%28%CE%B1%20%CE%B2%20%3A%20Type%29%20where%0A%20%20fst%20%3A%20%CE%B1%0A%20%20snd%20%3A%20%CE%B2%0A%0Adef%20p%20%3A%20Pair%20Nat%20String%20%3A%3D%20%7B%20fst%20%3A%3D%201%2C%20snd%20%3A%3D%20%22one%22%20%7D%0A%0A%23eval%20p.fst%20%20%20%20--%201%0A%23eval%20p.snd" title="Lean playground" loading="lazy" style="width:100%;height:212px;border:1px solid #ccc;border-radius:8px;">
</iframe>

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

Full citations in the [Bibliography](../bibliography.md).

- Python `typing` module documentation and mypy documentation ([PythonTyping], [MypyDocs]) — for the Python-side comparison used in this section's box.
- Milner ([Milner1978]) — the theoretical account of parametric polymorphism that `TypeVar`, and Lean's `{α : Type} → ...`, both implement to different degrees.

[PythonTyping]: ../bibliography.md#pythontyping
[MypyDocs]: ../bibliography.md#mypydocs
[Milner1978]: ../bibliography.md#milner1978

---

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)
