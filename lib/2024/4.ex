import AOC

aoc 2024, 4 do
  def p1(input) do
    {map, grid} = parse(input)
    [_ | letters] = Enum.with_index(["X", "M", "A", "S"])
    map["X"]
    |> Enum.map(&count_xmas(grid, letters, &1))
    |> Enum.sum()
  end

  def p2(input) do
    {map, grid} = parse(input)
    map["A"]
    |> Enum.map(&count_x_mas(grid, &1))
    |> Enum.sum()
  end

  def count_xmas(grid, letters, {x_start, y_start}) do
    [{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}]
    |> Enum.count(fn {x, y} -> Enum.all?(letters, fn {letter, i} -> grid[{x_start + i*x, y_start + i * y}] == letter end) end)
  end

  def count_x_mas(grid, {x_start, y_start}) do
    trees = [["M", "S"], ["S", "M"]]
    for a <- trees, b <- trees do
      Enum.zip_with(a ++ b, [{1,1}, {-1,-1}, {1, -1}, {-1, 1}], fn letter, {x, y} -> grid[{x_start+x, y_start+y}] == letter end) |> Enum.all?()
    end |> Enum.count(& &1)
  end

  def parse(input) do
    letters = input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {ch, x} -> {{x, y}, ch} end)
      end)
    {Enum.group_by(letters, fn {_p, ch} -> ch end, fn {p, _ch} -> p end), Map.new(letters)}
  end
end
