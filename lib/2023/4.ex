import AOC

aoc 2023, 4 do
  def p1(input) do
    input
    |> winning_cards()
    |> Enum.map(fn 0 -> 0; n -> 2 ** (n-1) end)
    |> Enum.sum()
  end

  def winning_cards(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
        line
        |> String.split(": ")
        |> Enum.at(1)
        |> String.split("|")
        |> Enum.map(fn card -> card |> String.split(" ", trim: true) |> MapSet.new end)
        |> then(fn [winning, hand] -> MapSet.intersection(winning, hand) |> Enum.count() end)
      end)
  end

  def p2(input) do
    input
    |> winning_cards()
    |> Enum.map(&{1, &1})
    |> process()
    |> Enum.unzip()
    |> elem(0)
    |> Enum.sum()
  end

  def process([]), do: []
  def process([{count, multiplier} = x | xs]) do
    {before, after_} = Enum.split(xs, multiplier)
    [x | process(Enum.map(before, fn {c, n} -> {c + count, n} end) ++ after_)]
  end
end
