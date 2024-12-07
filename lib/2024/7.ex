import AOC

aoc 2024, 7 do
  def p1(input) do
    common(input, &makeable?/2)
  end

  defp common(input, f) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.replace(":", "") |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) end)
    |> Enum.filter(fn [total| nums] -> f.(total, nums) end)
    |> Enum.map(&hd/1)
    |> Enum.sum()
  end

  def makeable?(total, [accum]), do: total == accum
  def makeable?(total, [num1, num2 | nums]), do: makeable?(total, [num1+num2| nums]) or makeable?(total, [num1*num2|nums])

  def makeable2?(total, [accum]), do: total == accum
  def makeable2?(total, [num1, num2 | nums]), do: makeable2?(total, [num1+num2| nums]) or makeable2?(total, [num1*num2|nums]) or makeable2?(total, [concat(num1,num2)|nums])

  def concat(a, b), do: String.to_integer("#{a}#{b}")

  def p2(input) do
    common(input, &makeable2?/2)
  end
end
