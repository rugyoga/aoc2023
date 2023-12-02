import AOC

aoc 2023, 2 do
  def p1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_game/1 )
    |> Enum.filter(fn {_, games} -> Enum.all?(games, fn game -> g(game, "red") <= 12 and g(game, "green") <= 13 and g(game, "blue") <= 14 end) end)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum()
  end

  def parse_game(line) do
    [id, games] = String.split(line, ": ", trim: true)
    games
    |> String.split("; ", trim: true)
    |> Enum.map(fn game -> game |> String.split(", ", trim: true) |> Enum.map(fn cubes -> [num, colour] = String.split(cubes, " ", trim: true); {colour, String.to_integer(num)} end) |> Map.new() end)
    |> then(&{id |> String.replace("Game ", "") |> String.to_integer(), &1})
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_game/1)
    |> Enum.map(&fewest/1)
    |> Enum.sum()
  end

  def fewest({_, games}) do
    games
    |> Enum.reduce({0, 0, 0}, fn game, {r, g, b} -> {Enum.max([g(game,"red"), r]), Enum.max([g(game,"green"), g]), Enum.max([g(game, "blue"), b])} end)
    |> Tuple.to_list()
    |> Enum.product()
  end

  def g(m, k), do: Map.get(m, k, 0)
end
