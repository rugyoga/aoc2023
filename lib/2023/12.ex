import AOC

aoc 2023, 12 do
  def calculate(input, f) do
    Memo.start_link()
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
        [pattern, nums] = String.split(line)
        {pattern, nums |> String.split(",") |> Enum.map(&String.to_integer/1)}
        |> then(f)
        |> then(fn {a, b} -> a |> String.split("", trim: true) |> match(b, false) end)
    end)
    |> Enum.sum()
  end

  def p1(input), do: calculate(input, & &1)
  def p2(input), do: calculate(input, &duplicate/1)

  def match([], [], count) when count == 0 or count == false, do: 1
  def match([], _, _), do: 0
  def match(["." | rest], ns, count) when count == 0 or count == false, do: match(rest, ns, false)
  def match(["." | _], _, _), do: 0
  def match(["#" | _], [], false), do: 0
  def match(["#" | _], _, 0), do: 0
  def match(["#" | rest], [n | ns], false), do: match(rest, ns, n-1)
  def match(["#" | rest], numbers, n), do: match(rest, numbers, n-1)
  def match(["?" | rest], ns, count), do: Memo.ised(&match/3, [["#" | rest], ns, count]) + Memo.ised(&match/3, [["." | rest], ns, count])

  def duplicate({pattern, numbers}) do
    {Stream.cycle([pattern]) |> Enum.take(5) |> Enum.join("?"),
     Stream.cycle([numbers]) |> Enum.take(5) |> List.flatten()}
  end
end
