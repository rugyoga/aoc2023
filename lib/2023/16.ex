import AOC

aoc 2023, 16 do
  def p1(input) do
    input
    |> Grid.parse()
    |> compute({{0, 0}, :east})
  end

  def compute(grid, start) do
    grid
    |> recurse([start], MapSet.new(), MapSet.new())
    |> Enum.count()
  end

  def p2(input) do # very slow
    grid = Grid.parse(input)

    (for(row <- 0..(grid.rows-1), do: [{{row, 0}, :east}, {{row, grid.cols-1}, :west}]) ++
    for(col <- 0..(grid.cols-1), do: [{{0, col}, :south}, {{grid.rows-1, col}, :north}]))
    |> List.flatten()
    |> Enum.map(&compute(grid, &1))
    |> Enum.max()
  end

  def recurse(_, [], energized, _), do: energized
  def recurse(grid, [active | actives], energized, seen) do
    {active_pos, active_dir} = active
    if not MapSet.member?(seen, active) and Grid.in?(grid, active_pos) do
      energized_new = MapSet.put(energized, active_pos)
      seen_new = MapSet.put(seen, active)
      f = fn candidates -> candidates |> Kernel.++(actives) |> then(&recurse(grid, &1, energized_new, seen_new)) end
      item = grid.map[active_pos]
      cond do
        item == "." or
        (item == "|" and active_dir in [:north, :south]) or
        (item == "-" and active_dir in [:east, :west]) -> f.([next(active)])
        item == "|" -> f.([next({active_pos, :north}), next({active_pos, :south})])
        item == "-" -> f.([next({active_pos, :west}), next({active_pos, :east})])
        item == "/" -> f.([next({active_pos, flip_sw(active_dir)})])
        item == "\\" -> f.([next({active_pos, flip_se(active_dir)})])
      end
    else
      recurse(grid, actives, energized, seen)
    end
  end

  def flip_sw(dir), do: %{north: :east, south: :west, west: :south, east: :north}[dir]
  def flip_se(dir), do: %{north: :west, south: :east, west: :north, east: :south}[dir]
  def next({{row, col}, :west}), do: {{row, col-1}, :west}
  def next({{row, col}, :east}), do: {{row, col+1}, :east}
  def next({{row, col}, :north}), do: {{row-1, col}, :north}
  def next({{row, col}, :south}), do: {{row+1, col}, :south}
end
