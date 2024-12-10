import AOC

aoc 2024, 10 do
  def p1(input) do
    {grid, by_num} = common(input)
    by_num[0]
    |> Enum.map(&counter(&1, grid, by_num))
    |> Enum.sum
  end

  def p2(input) do
    {grid, by_num} = common(input)
    by_num[0]
    |> Enum.map(&count2(&1, grid, by_num))
    |> Enum.sum()
  end

  def count2({_, 9}, _, _), do: 1
  def count2({p, i}, grid, by_num) do
    grid
    |> Grid.neighbours_4(p)
    |> Enum.filter(fn n -> grid.map[n] == i + 1 end)
    |> Enum.map(&count2({&1, i + 1}, grid, by_num))
    |> Enum.sum()
  end

  def count({p, 9}, _, _), do: [p]
  def count({p, i}, grid, by_num) do
    grid
    |> Grid.neighbours_4(p)
    |> Enum.filter(fn n -> grid.map[n] == i + 1 end)
    |> Enum.flat_map(&count({&1, i + 1}, grid, by_num))
  end

  def counter(p, grid, by_num) do
    count(p, grid, by_num)
    |> Enum.uniq
    |> length()
  end

  def common(input) do
    grid = Grid.parse(input, [], &String.to_integer/1)
    {grid, Enum.group_by(grid.map, fn {_p, i} -> i end)}
  end
end
