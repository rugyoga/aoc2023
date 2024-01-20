import AOC

aoc 2023, 21 do
  def p1(input) do
    grid = Grid.parse(input)
    start = Enum.find(grid.map, fn {_, v} -> v == "S" end) |> elem(0)
    [start]
    |> loop(1, 64, Map.put(grid.map, start, "."), bounds(grid.map))
    |> length()
  end

  defp loop(open, step, max_steps, _grid, _bounds) when step > max_steps, do: open
  defp loop(open, step, max_steps, grid, bounds) do
    Enum.flat_map(open, fn pos ->
      bounds
      |> neighbours(pos)
      |> Enum.filter(fn p -> Map.get(grid, p) == "." end)
    end)
    |> Enum.uniq()
    |> loop(step + 1, max_steps, grid, bounds)
  end

  def p2(input) do
    grid = Grid.parse(input)
    start = Enum.find(grid.map, fn {_, v} -> v == "S" end) |> elem(0)
    grid = %Grid{grid | map: Map.put(grid.map, start, ".")}
    max_steps = 26_501_365
    width = grid.cols
    height = grid.rows
    square_size = width

    n_tiles_side = elem(start, 0)
    remain_steps = max_steps - n_tiles_side
    short_ray = div(remain_steps, square_size)

    center = grid.map

    top = Map.new(center, fn {{x, y}, v} -> {{x, y - height}, v} end)
    top_left = Map.new(center, fn {{x, y}, v} -> {{x - width, y - height}, v} end)
    top_right = Map.new(center, fn {{x, y}, v} -> {{x + width, y - height}, v} end)

    left = Map.new(center, fn {{x, y}, v} -> {{x - width, y}, v} end)
    right = Map.new(center, fn {{x, y}, v} -> {{x + width, y}, v} end)

    bottom = Map.new(center, fn {{x, y}, v} -> {{x, y + height}, v} end)
    bottom_left = Map.new(center, fn {{x, y}, v} -> {{x - width, y + height}, v} end)
    bottom_right = Map.new(center, fn {{x, y}, v} -> {{x + width, y + height}, v} end)

    expanded_grid =
      Enum.reduce([top, top_left, top_right, left, right, bottom, bottom_left, bottom_right], center, &Map.merge/2)

    sim_steps = n_tiles_side + square_size

    positions = loop([start], 1, sim_steps, expanded_grid, bounds(expanded_grid))
    top_bounds = bounds(top)
    bottom_bounds = bounds(bottom)
    left_bounds = bounds(left)
    right_bounds = bounds(right)

    top_slots_centered =
      positions |> filter_slots(top_bounds) |> Enum.map(fn {x, y} -> {x, y + height} end)

    bottom_slots_centered =
      positions |> filter_slots(bottom_bounds) |> Enum.map(fn {x, y} -> {x, y - height} end)

    left_slots_centered =
      positions |> filter_slots(left_bounds) |> Enum.map(fn {x, y} -> {x + width, y} end)

    right_slots_centered =
      positions |> filter_slots(right_bounds) |> Enum.map(fn {x, y} -> {x - width, y} end)

    regular_full_tile = unique_length(top_slots_centered, bottom_slots_centered)

    seven_eighteenths_top_left = unique_length(top_slots_centered, left_slots_centered)
    seven_eighteenths_top_right = unique_length(top_slots_centered, right_slots_centered)
    seven_eighteenths_bottom_left = unique_length(bottom_slots_centered, left_slots_centered)
    seven_eighteenths_bottom_right = unique_length(bottom_slots_centered, right_slots_centered)

    alternate_full_tile = count_slots(positions, bounds(center))

    alternate_eighteenths_count =
      count_slots(positions, bounds(top_left)) +
      count_slots(positions, bounds(top_right)) +
      count_slots(positions, bounds(bottom_left)) +
      count_slots(positions, bounds(bottom_right))

    n_oneight = short_ray
    n_seveneight = short_ray - 1
    n_full_regular = sum_to(short_ray - 1) + sum_to(short_ray - 2)
    n_full_alternate = sum_to(short_ray) + sum_to(short_ray - 1)

    [length(top_slots_centered),
    length(bottom_slots_centered),
    length(left_slots_centered),
    length(right_slots_centered),
    alternate_eighteenths_count * n_oneight,
    seven_eighteenths_top_left * n_seveneight,
    seven_eighteenths_top_right * n_seveneight,
    seven_eighteenths_bottom_left * n_seveneight,
    seven_eighteenths_bottom_right * n_seveneight,
    regular_full_tile * n_full_regular,
    alternate_full_tile * n_full_alternate]
    |> Enum.sum()
  end

  def bounds(map) do
    {xs, ys} = map |> Map.keys() |> Enum.unzip()
    {Enum.min_max(xs), Enum.min_max(ys)}
  end

  def neighbours({{x_min, x_max}, {y_min, y_max}}, {x, y}) do
    [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}]
    |> Enum.filter(fn {x, y} -> x in x_min..x_max and y in y_min..y_max end)
  end

    # 1+2+3+4+...+n = n*(n+1)/2
  defp sum_to(n) do
    div(n * (n + 1), 2)
  end

  defp count_slots(xys, {{xa, xo}, {ya, yo}}) do
    Enum.count(xys, fn {x, y} -> x in xa..xo and y in ya..yo end)
  end

  defp filter_slots(xys, {{xa, xo}, {ya, yo}}) do
    Enum.filter(xys, fn {x, y} -> x in xa..xo and y in ya..yo end)
  end

  defp unique_length(xys_a, xys_b) do
    length(Enum.uniq(xys_a ++ xys_b))
  end
end
