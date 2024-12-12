import AOC

aoc 2024, 11 do
  use Memoize

  def p1(input), do: common(input, 25)
  def p2(input), do: common(input, 75)

  def common(input, depth) do
    input
    |> String.split(" ", trim: true)
    |> Enum.map(&{String.to_integer(&1), depth})
    |> Enum.map(&transform/1)
    |> Enum.sum()
  end

  defmemo count(items) when is_list(items), do: Enum.reduce(items, 0, fn items, n -> n + count(items) end)
  defmemo count(_), do: 1

  defmemo transform({n, 0}), do: count(n)
  defmemo transform({0, depth}), do: transform({1, depth-1})
  defmemo transform({n, depth}) do
    k = trunc(:math.log10(n)) + 1
    if rem(k, 2) == 0 do
      p = trunc(:math.pow(10, div(k, 2)))
      transform({div(n, p), depth - 1}) + transform({rem(n, p), depth - 1})
    else
      transform({n * 2024, depth - 1})
    end
  end
end
