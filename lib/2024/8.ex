import AOC

aoc 2024, 8 do
  def p1(input) do
    common(input, &antinodes/2)
  end

  def common(input, f) do
    grid = Grid.parse(input, ["."])
    grid.map
    |> Enum.group_by(fn {_p, v} -> v end, fn {p, _v} -> p end)
    |> Enum.map(fn p -> f.(grid, p) end)
    |> List.flatten()
    |> Enum.filter(&Grid.in?(grid, &1))
    |> Enum.uniq()
    |> length()
  end

  def antinodes(grid, {_value, locations}) do
    for a <- locations, b <- locations, a < b do
      pair(grid, a, b)
    end
  end

  def antinodes2(grid, {_value, locations}) do
    for a <- locations, b <- locations, a < b do
      multi(grid, a, b)
    end
  end

  def pair(_grid, {a_x, a_y}=a, {b_x, b_y}=b) do
    {v_x, v_y} = {b_x-a_x, b_y-a_y}
    [{a_x + 2*v_x, a_y + 2*v_y}, {a_x - v_x, a_y - v_y}]
  end

  def multi(grid, {a_x, a_y}=a, {b_x, b_y}=b) do
    {v_x, v_y} = {b_x-a_x, b_y-a_y}
    [line(grid, a, {-v_x, -v_y}), line(grid, b, {v_x, v_y})]
  end

  def line(grid, {x, y} = p, {d_x, d_y} = v) do
    if(Grid.in?(grid, p), do: [p | line(grid, {x + d_x, y + d_y}, v)], else: [] )
  end

  def p2(input) do
    common(input, &antinodes2/2)
  end
end
