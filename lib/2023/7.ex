import AOC

aoc 2023, 7 do
  def p1(input), do: compute(input, &(&1), &value/1)

  def p2(input), do: compute(input, &go_wild/1, &value2/1)

  def compute(input, f, g) do
    input
    |> String.split("\n")
    |> Enum.map(&(parse(&1, f, g)))
    |> Enum.sort()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_,bid}, value} -> bid * value end)
    |> Enum.sum
  end

  def value(s), do: %{"A" => 14, "K" => 13, "Q" => 12, "J" => 11, "T" => 10}[s] || String.to_integer(s)

  def value2(card), do: if(card == "J", do: 0, else: value(card))

  def parse(line, f, g) do
    [hand, bid] = String.split(line)
    {{hand
      |> String.split("", trim: true)
      |> Enum.frequencies()
      |> then(f)
      |> Map.values()
      |> Enum.sort(:desc),
      hand |> String.split("", trim: true) |> Enum.map(g)},
    String.to_integer(bid)}
  end

  def go_wild(freqs) do
      {wild, freqs} = Map.pop(freqs, "J")
      case wild do
        nil -> freqs
        5 -> %{"A" => 5}
        _ ->
          best = freqs |> Map.values |> Enum.max
          {card, _} = freqs |> Enum.filter(fn {_, v} -> v == best end) |> Enum.sort() |> hd
          Map.update!(freqs, card, &(&1 + wild))
      end
  end
end
