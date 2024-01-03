defmodule Queue do
  @type t(item) :: {[item], [item]}

  def new, do: {[], []}

  def add_back({front, back}, item), do: {front, [item | back]}

  def pop_front({[], []} = q), do: {:empty, q}
  def pop_front({[], back}), do: pop_front({Enum.reverse(back), []})
  def pop_front({[head | front], back}), do: {head, {front, back}}

  def peek_front({[], []}), do: :empty
  def peek_front({[], back}), do: List.last(back)
  def peek_front({front, _}), do: hd(front)

  def empty?({front, back}), do: Enum.empty?(front) and Enum.empty?(back)

  def size({front, back}), do: Enum.count(front) + Enum.count(back)
end
