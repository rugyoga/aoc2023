defmodule Heap do
  @type heap(a) :: node(a) | nil
  @type node(a) :: {a, heap(a), heap(a)}

  @spec tree(a, heap(a), heap(a)) :: heap(a) when a: var
  def tree(x, l \\ nil, r \\ nil), do: {x, l, r}

  @spec new :: heap(term)
  def new, do: nil

  @spec union(heap(a), heap(a)) :: heap(a) when a: var
  def union(nil, t2), do: t2
  def union(t1, nil), do: t1
  def union({{p1, _} = x1, l1, r1}, {{p2, _}, _, _} = t2) when p1 <= p2, do: tree(x1, union(t2, r1), l1)
  def union(t1, {x2, l2, r2}), do: tree(x2, union(t1, r2), l2)

  @spec push(heap(a), a) :: heap(a) when a: var
  def push(heap, x), do: x |> tree |> union(heap)

  @spec pop(heap(a)) :: {a | :empty, heap(a)} when a: var
  def pop(nil), do: {:empty, nil}
  def pop({x, l, r}), do: {x, union(l, r)}

  def peek(nil), do: :empty
  def peek({x, _, _}), do: x

  def empty?(nil), do: true
  def empty?(_), do: false

  def to_list(nil), do: []
  def to_list(h) do
      {item, new_h} = pop(h)
      [item | to_list(new_h)]
  end
end
