import AOC

aoc 2024, 8 do
  def p1(input), do: common(input, &pair/4)
  def p2(input), do: common(input, &multi/4)

  def common(input, f) do
    grid = Grid.parse(input, ["."])
    grid.map
    |> Enum.group_by(fn {_p, v} -> v end, fn {p, _v} -> p end)
    |> Enum.map(fn {_value, locations} ->
      for a <- locations, b <- locations, a < b do
        f.(grid, a, b, minus(b, a))
      end
    end)
    |> List.flatten()
    |> Enum.filter(&Grid.in?(grid, &1))
    |> Enum.uniq()
    |> length()
  end

  def plus({a_x, a_y}, {b_x, b_y}), do: {a_x + b_x, a_y + b_y}
  def minus({a_x, a_y}, {b_x, b_y}), do: {a_x - b_x, a_y - b_y}
  def pair(_grid, a, b, v), do: [minus(a, v), plus(b, v)]
  def multi(grid, a, b, v), do: [line(grid, a, minus({0, 0}, v)), line(grid, b, v)]
  def line(grid, p, v), do: if(Grid.in?(grid, p), do: [p | line(grid, plus(p, v), v)], else: [])
end
