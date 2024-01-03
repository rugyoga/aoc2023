import AOC

aoc 2023, 17 do
  def compute(input, candidates) do
    grid = Grid.parse(input, [], &String.to_integer/1)
    Heap.new()
    |> Heap.push({0, [{{0,0}, :east}]})
    |> Heap.push({0, [{{0,0}, :south}]})
    |> search({grid.rows-1, grid.cols-1}, grid.map, MapSet.new, candidates)
  end

  def p1(input), do: compute(input, &candidates_simple/1)
  def p2(input), do: compute(input, &candidates_ultra/1)

  def search(heap, {row_t, col_t} = target, heat_map, seen, candidates) do
    {{cost, last_3}, heap} = Heap.pop(heap)
    row_col = last_3 |> hd |> elem(0)
    cond do
      row_col == target -> cost
      MapSet.member?(seen, last_3) -> search(heap, target, heat_map, seen, candidates)
      true ->
        last_3
        |> then(candidates)
        |> Enum.filter(fn [{{row, col}, _} | _] -> 0 <= row and row <= row_t and 0 <= col and col <= col_t end)
        |> Enum.reduce(heap, fn last_3, heap -> Heap.push(heap, {cost+heat_map[last_3 |> hd |> elem(0)], last_3}) end)
        |> search(target, heat_map, MapSet.put(seen, last_3), candidates)
    end
  end

  def candidates_simple([x, _, _]), do: [[go(:left, x)], [go(:right, x)]]
  def candidates_simple([x | rest]), do: [[go(:straight, x), x | rest], [go(:left, x)], [go(:right, x)]]

  def candidates_ultra([move | moves] = all_moves) do
    cond do
    length(moves) < 4 -> [[go(:straight, move) | all_moves]]
    length(moves) == 10 -> [[go(:left, move)], [go(:right, move)]]
    true -> [[go(:straight, move) | all_moves], [go(:left, move)], [go(:right, move)]]
    end
  end

  @spec go(any(), {{any(), any()}, any()}) :: {{any(), any()}, :east | :north | :south | :west}
  def go(which_way, {row_col, dir}), do: next(row_col, dirs()[dir][which_way])

  def dirs() do
   %{west:  %{left: :south, straight: :west, right: :north},
     north: %{left: :west, straight: :north, right: :east},
     east:  %{left: :south, straight: :east, right: :north},
     south: %{left: :east, straight: :south, right: :west}}
  end

  def next({row, col}, :west), do: {{row, col-1}, :west}
  def next({row, col}, :east), do: {{row, col+1}, :east}
  def next({row, col}, :north), do: {{row-1, col}, :north}
  def next({row, col}, :south), do: {{row+1, col}, :south}
end
