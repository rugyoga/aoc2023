import AOC

aoc 2022, 6 do
  def count(input, n) do
      input
      |> String.split("", trim: true)
      |> Enum.chunk_every(n, 1)
      |> Enum.take_while(fn items -> (Enum.count(MapSet.new(items))) != n end)
      |> Enum.count
      |> then(&(&1+n))
  end

  def p1(input), do: count(input, 4)
  def p2(input), do: count(input, 14)
end
