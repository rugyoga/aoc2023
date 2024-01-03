import AOC

aoc 2023, 21 do
  def p1(input) do
    grid = input |> Grid.parse()
    {start, _} = grid.map |> Enum.find(fn {_, char} -> char == "S" end)
    Queue.new()
    |> Queue.add_back({0, start})
    |> search(grid, MapSet.new)
    |> Enum.filter(fn {n, p} -> n == 64 end)
    |> Enum.count()
  end

  def search(q, grid, seen) do
    {x, q} = Queue.pop_front(q)
    if x == :empty or elem(x, 0) == 64 do
      seen
    else
      next(x, grid, seen)
      |> Enum.reduce(seen, fn x, seen -> search(Queue.add_back(q, x), grid, MapSet.put(seen, x)) end)
    end
  end

  def next({n, p}, grid, seen) do
    grid
    |> Grid.neighbours_4(p)
    |> Enum.flat_map(
      fn p ->
        candidate = {n+1, p}
        if(grid.map[p] == "#" or MapSet.member?(seen, candidate), do: [], else: [candidate])
      end)
  end

  def p2(_input) do
  end
end
