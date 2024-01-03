import AOC

aoc 2022, 4 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
        s
        |> String.split(",", trim: true)
        |> Enum.map(fn range -> range |> String.split("-", trim: true) |> Enum.map(&String.to_integer/1) end)
        end)
  end

  def solve(input, f), do: input |> parse() |> Enum.filter(f) |> Enum.count

  def contained?([[a, b], [c ,d]]), do: (a <= c and b >= d) or  (a >= c and b <= d)
  def overlapped?([[a, b], [c ,d]]), do: (b >= c and a <= d) or  (c >= b and a >= d)

  def p1(input), do: solve(input, &contained?/1)
  def p2(input), do: solve(input, &overlapped?/1)
end
