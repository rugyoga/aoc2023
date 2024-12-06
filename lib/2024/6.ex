import AOC

aoc 2024, 6 do
  @rc_dirs [{-1,0},{0,1},{1,0},{0, -1}]
  def p1(input) do
    {start, grid} = parse(input)
    grid |> path([start], @rc_dirs, MapSet.new) |> Enum.uniq() |> length()
  end

  def parse(input) do
    grid = Grid.parse(input, ["."])
    {start, _} = Enum.find(grid.map, fn {_p, ch} -> ch == "^" end)
    {start, %Grid{ grid | map: Map.delete(grid.map, start)}}
  end

  def path(grid, [{x, y} = pos| _] = path, [{x_d, y_d} = dir| _] = dirs, seen) do
    next = {x+x_d, y+y_d}
    cond do
      {pos, dir} in seen -> :loop
      !Grid.in?(grid, next) -> path
      Map.has_key?(grid.map, next) -> path(grid, path, Enum.drop(dirs, 1) ++ Enum.take(dirs, 1), MapSet.put(seen, {pos, dir}))
      true -> path(grid, [next | path], dirs, MapSet.put(seen, {pos, dir}))
    end
  end

  def p2(input) do
    {start, grid} = parse(input)
    grid
    |> path([start], @rc_dirs, MapSet.new)
    |> Enum.uniq()
    |> Enum.count(fn pos -> %Grid{grid | map: Map.put(grid.map, pos, "#")} |> path([start], @rc_dirs, MapSet.new) == :loop end)
  end
end
