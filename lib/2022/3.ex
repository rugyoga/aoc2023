import AOC

aoc 2022, 3 do
  def encode(x), do: if(x in ?a..?z, do: x - ?a + 1, else: x - ?A + 27)

  def p1(input) do
      input
      |> String.split("\n", trim: true)
      |> Enum.map(
          fn s ->
              l = s |> to_charlist()
              {a, b} = Enum.split(l, div(Enum.count(l), 2))
              MapSet.intersection(MapSet.new(a), MapSet.new(b))
              |> Enum.at(0)
              |> encode()
          end
      )
      |> Enum.sum
  end

  def p2(input) do
      input
      |> String.split("\n", trim: true)
      |> Enum.chunk_every(3)
      |> Enum.map(
          fn as ->
              as
              |> Enum.map(&(&1 |> to_charlist() |> MapSet.new()))
              |> Enum.reduce(&MapSet.intersection/2)
              |> Enum.at(0)
              |> encode()
          end
      )
      |> Enum.sum
  end
end
