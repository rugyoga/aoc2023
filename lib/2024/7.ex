import AOC

aoc 2024, 7 do
  @ops [&Kernel.+/2, &Kernel.*/2]
  def p1(input), do: common(input, @ops)
  def p2(input), do: common(input, [&String.to_integer("#{&1}#{&2}")|@ops])

  defp common(input, ops) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.replace(":", "") |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) end)
    |> Enum.filter(fn [total| nums] -> makeable?(total, nums, ops) end)
    |> Enum.map(&hd/1)
    |> Enum.sum()
  end

  def makeable?(total, [accum], _), do: total == accum
  def makeable?(total, [a, b | nums], ops), do: Enum.any?(ops, fn f -> makeable?(total, [f.(a, b)|nums], ops) end)
end
