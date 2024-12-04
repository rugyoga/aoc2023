import AOC

aoc 2024, 4 do
  def p1(input) do
    {map, grid} = parse(input)
    [_ | remaining] = Enum.with_index(["X", "M", "A", "S"])
    map["X"]
    |> Enum.map(&count_xmas(grid, remaining, &1))
    |> Enum.sum()
  end

  def dirs do
    [{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}]
  end

  def count_xmas(grid, letters, {x_start, y_start}) do
    dirs()
    |> Enum.count(fn {x_dir, y_dir} -> Enum.all?(letters, fn {letter, i} -> grid[{x_start + i*x_dir, y_start + i * y_dir}] == letter end) end)
  end

  def masses do
    [[{"M", {1, 1}}, {"S", {-1, -1}}, {"M", {1, -1}}, {"S", {-1, 1}}],
     [{"M", {1, 1}}, {"S", {-1, -1}}, {"S", {1, -1}}, {"M", {-1, 1}}],
     [{"S", {1, 1}}, {"M", {-1, -1}}, {"S", {1, -1}}, {"M", {-1, 1}}],
     [{"S", {1, 1}}, {"M", {-1, -1}}, {"M", {1, -1}}, {"S", {-1, 1}}]]
  end

  def count_x_mas(grid, {x_start, y_start}) do
    masses()
    |> Enum.count(fn positions -> Enum.all?(positions, fn {letter, {x, y}} -> grid[{x_start+x, y_start+y}] == letter end) end)
  end

  def parse(input) do
    letters =input
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

  def p2(input) do
    {map, grid} = parse(input)

    map["A"]
    |> Enum.map(&count_x_mas(grid, &1))
    |> Enum.sum()
  end
end
