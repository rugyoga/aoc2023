import AOC

aoc 2022, 12 do
  @finish_value ?E - ?a
  @start_value ?S - ?a

  def parse(input) do
    locations =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index(
          fn line, row ->
              line
              |> String.to_charlist()
              |> Enum.map(&(&1 -?a))
              |> Enum.with_index(fn height, col -> {{col, row}, height} end)
          end)
      |> List.flatten
    start = find(locations, @start_value)
    %{ start: start,
        finish: find(locations, @finish_value),
        locations: Map.new(locations) |> Map.put(start, 0)}
  end

  def find(locations, target), do: locations |> Enum.find(locations, fn {_, h} -> h == target end) |> elem(0)

  def search(%{start: start, finish: finish, locations: locations}) do
      search(Heap.push(Heap.new(), {0, start}), finish, locations, MapSet.new([start]))
  end

  def search(heap, goal, locations, seen) do
      if Heap.empty?(heap) do
          10_000_000
      else
          {{n, point}, heap} = Heap.pop(heap)
          if point == goal do
              n
          else
              candidates = neighbours(point, locations, seen)
              heap = candidates |> Enum.reduce(heap, fn neighbour, heap -> heap |> Heap.push({n+1, neighbour}) end)
              seen = MapSet.new(candidates) |> MapSet.union(seen)
              search(heap, goal, locations, seen)
          end
      end
  end

  def neighbours({x, y} = point, locations, seen) do
      h = Map.get(locations, point)
      [{x+1, y}, {x-1, y}, {x, y-1}, {x, y+1}]
      |> Enum.flat_map(
          fn p -> h_n = Map.get(locations, p)
              if h_n == @start_value or
                  (!is_nil(h_n) and h_n <= h+1 and !MapSet.member?(seen, p)) do
                  [p]
              else
                  []
              end
          end)
  end

  def candidates(t) do
      t.locations
      |> Enum.filter(fn {_, v} -> v == 0 end)
      |> Enum.map(fn {p, _} -> %{ t | start: p} end)
  end

  def p1(input), do: input |> parse() |> search()
  def p2(input), do: input |> parse() |> candidates |> Enum.map(&search/1) |> Enum.min
end
