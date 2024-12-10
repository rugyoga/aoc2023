import AOC

aoc 2024, 10 do
  def p1(input), do: common(input, &count1/2)
  def p2(input), do: common(input, &count2/2)

  def count2({_, 9}, _), do: 1
  def count2({p, i}, grid) do
    grid
    |> Grid.neighbours_4(p)
    |> Enum.filter(fn n -> grid.map[n] == i + 1 end)
    |> Enum.map(&count2({&1, i + 1}, grid))
    |> Enum.sum()
  end

  def count1_rec({p, 9}, _), do: [p]
  def count1_rec({p, i}, grid) do
    grid
    |> Grid.neighbours_4(p)
    |> Enum.filter(fn n -> grid.map[n] == i + 1 end)
    |> Enum.flat_map(&count1_rec({&1, i + 1}, grid))
  end

  def count1(p, grid) do
    count1_rec(p, grid)
    |> Enum.uniq
    |> length()
  end

  def common(input, f) do
    grid = Grid.parse(input, [], &String.to_integer/1)
    Enum.group_by(grid.map, fn {_p, i} -> i end)[0]
    |> Enum.map(&f.(&1, grid))
    |> Enum.sum()
  end
end
