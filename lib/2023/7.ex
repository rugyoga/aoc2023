import AOC

aoc 2023, 7 do
  def p1(input) do
    compute(input, &(&1), &map/1)
  end

  def p2(input) do
    compute(input, &go_wild/1, &map2/1)
  end

  def compute(input, f, g) do
    input
    |> String.split("\n")
    |> Enum.map(&(parse(&1, f, g)))
    |> Enum.sort()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_,bid}, value} -> bid * value end)
    |> Enum.sum
  end

  def map("A"), do: 14
  def map("K"), do: 13
  def map("Q"), do: 12
  def map("J"), do: 11
  def map("T"), do: 10
  def map(s), do: String.to_integer(s)

  def map2("J"), do: 0
  def map2(other), do: map(other)

  def parse(line, f, g) do
    line
    |> String.split()
    |> then(fn [hand, bid] ->
      {{
        hand
        |> String.split("", trim: true)
        |> Enum.frequencies()
        |> then(f)
        |> Map.values()
        |> Enum.sort(:desc),
        hand |> String.split("", trim: true) |> Enum.map(g)
        },
       String.to_integer(bid)}
      end)
  end

  def go_wild(freqs) do
      {wild, freqs} = Map.pop(freqs, "J")
      cond do
        is_nil(wild) -> freqs
        Enum.count(freqs) == 0 -> %{"A" => 5}
        true ->
          best = freqs |> Map.values |> Enum.max
          {card, _} = freqs |> Enum.filter(fn {_, v} -> v == best end) |> Enum.sort() |> hd
          Map.update!(freqs, card, &(&1 + wild))
      end
  end
end
