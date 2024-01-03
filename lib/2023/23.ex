import AOC

aoc 2023, 23 do
  def p1(input) do
    input
    |> Grid.parse()
    |> search({0,1},{140, 139})
    |> Enum.max
  end

  def search(grid, current, target, f \\ &part1/2, n \\ 0, cutoff \\ 5000, seen \\ MapSet.new) do
    if current == target do
      [n]
    else
      if n > cutoff do
        []
      else
        f.(grid, current)
        |> Enum.reject(fn c -> grid.map[c] == "#" or MapSet.member?(seen, c) end)
        |> Enum.flat_map(fn c -> search(grid, c, target, f, n+1, cutoff, MapSet.put(seen, c)) end)
      end
    end
  end

  def part1(grid, {r, c} = current) do
    case grid.map[current] do
      ">" -> [{r, c+1}]
      "<" -> [{r, c-1}]
      "^" -> [{r-1, c}]
      "v" -> [{r+1, c}]
      _ -> Grid.neighbours_4(grid, current)
    end
  end

  def connected(queue, neighbours, seen) do
    if Queue.empty?(queue) do
      []
    else
      {{point, cost}, queue} = Queue.pop_front(queue)
      candidates = Map.get(neighbours, point)
      if length(candidates) == 2 or cost == 0 do
        candidates
        |> Enum.reject(&MapSet.member?(seen, &1))
        |> Enum.flat_map(fn p -> connected(Queue.add_back(queue, {p, cost+1}), neighbours, MapSet.put(seen, p)) end)
      else
        [{point, cost}]
      end
    end
  end

  def neighbours(grid) do
    points =
      grid.map
      |> Enum.flat_map(fn {p, char} -> if(char == "#", do: [], else: [p]) end)
      |> MapSet.new

    points
    |> Enum.map(
      fn p ->
        grid
        |> Grid.neighbours_4(p)
        |> Enum.filter(&MapSet.member?(points, &1))
        |> then(&{p, &1})
      end)
    |> Map.new
  end

  def all_neighbours(neighbours) do
    neighbours
    |> Enum.reject(fn {_, ns} -> length(ns) == 2 end)
    |> Enum.map(fn {p, _} -> {p, connected(Queue.new() |> Queue.add_back({p, 0}), neighbours, MapSet.new([p]))} end)
    |> Map.new
  end

  def search2(costs, current, target, cost, seen \\ MapSet.new) do
    if current == target do
      [cost]
    else
      costs[current]
      |> Enum.reject(fn {point, _} -> MapSet.member?(seen, point) end)
      |> Enum.flat_map(fn {point, delta} -> search2(costs, point, target, cost+delta, MapSet.put(seen, point)) end)
    end
  end

  def p2(input) do
    input
    |> Grid.parse()
    |> neighbours()
    |> all_neighbours()
    |> search2({0,1}, {140, 139}, 0, MapSet.new([{0,1}]))
    |> Enum.max()
  end
end
