import AOC

aoc 2022, 1 do
  def p1(input) do
    input |> parse() |> Enum.max()
  end

  def p2(input) do
    input |> parse() |> Enum.sort(:desc) |> Enum.take(3) |> Enum.sum()
  end

  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn s -> s |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1) |> Enum.sum() end)
  end
end
