import AOC

aoc 2024, 1 do
  def p1(input) do
    {left, right} = common(input)
    Enum.sort(left)
    |> Enum.zip_with(Enum.sort(right), fn a, b -> abs(a - b) end)
    |> Enum.sum()
  end

  defp common(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)
    |> Enum.unzip()
  end

  def p2(input) do
    {left, right} = common(input)
    right_counts = Enum.frequencies(right)
    left
    |> Enum.map(fn l -> l * Map.get(right_counts, l, 0) end)
    |> Enum.sum()
  end
end
