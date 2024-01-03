import AOC

aoc 2022, 10 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(
        fn "noop" -> :noop
           line -> line |> String.split(" ", trim: true) |> then(fn [_, n] -> String.to_integer(n) end)
        end)
  end

  def register([], _), do: []
  def register([:noop | lines], r), do: [r | register(lines, r)]
  def register([n | lines], r), do: [r | [r | register(lines, r+n)]]

  def strength(l), do: l |> Enum.with_index(1) |> Enum.map(fn {a, b} -> a*b end)

  def strengths(l, rs), do: rs |> Enum.map(&Enum.at(l, &1-1)) |> Enum.sum

  def crt(l) do
      l
      |> Enum.with_index()
      |> Enum.map(fn {s, i} -> if(rem(i, 40) in (s - 1)..(s + 1), do: "#", else: " ") end)
      |> Enum.chunk_every(40)
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.join("\n")
  end

  def p1(input), do: input |> parse() |> register(1) |> strength() |> strengths([20, 60, 100, 140, 180, 220])
  def p2(input), do: input |> parse() |> register(1) |> crt() |> IO.puts
end
