import AOC

aoc 2023, 14 do
  def p1(input) do
    grid = Grid.parse(input, ["."])
    grid.map |> shift_north() |> compute_load(grid.rows)
  end

  def p2(input) do
    grid =  Grid.parse(input, ["."])
    grid.map
    |> Loop.compute(&shift_all(&1, grid.rows, grid.cols), &checksum(&1, grid.cols))
    |> Loop.nth(1_000_000_000)
    |> compute_load(grid.rows)
  end

  @spec shift_all(any(), any(), any()) :: list()
  def shift_all(items, height, width) do
    items
    |> shift_north()
    |> shift_west()
    |> shift_south(height)
    |> shift_east(width)
    |> Enum.sort()
  end

  def checksum(items, width) do
    bits = items |> Enum.flat_map(fn {{row, col}, char} -> if(char == "O", do: [row * width + col], else: []) end) |> MapSet.new()
    for row <- 0..(width-1), col <- 0..(width-1) do
      if(MapSet.member?(bits, row * width + col), do: 1, else: 0)
    end
    |> Integer.undigits(2)
  end

  def compute_load(items, height) do
    items
    |> Enum.flat_map(fn {{row, _}, ch} -> if(ch == "O", do: [height-row], else: []) end)
    |> Enum.sum()
  end

  def by_col({{_, col}, _}), do: col
  def by_row({{row, _}, _}), do: row

  def shift_north(items), do: items |> Enum.group_by(&by_col/1) |> Enum.flat_map(&shift_north_one_col/1)
  def shift_west(items), do: items |> Enum.group_by(&by_row/1) |> Enum.flat_map(&shift_west_one_row/1)
  def shift_south(items, height), do: items |> Enum.group_by(&by_col/1) |> Enum.flat_map(&shift_south_one_col(&1, height))
  def shift_east(items, width), do: items |> Enum.group_by(&by_row/1) |> Enum.flat_map(&shift_east_one_row(&1, width))

  def incr(x), do: x+1
  def decr(x), do: x-1

  def get_row({row, _}), do: row
  def get_col({_, col}), do: col

  def update_row({_, col}, new_row), do: {new_row, col}
  def update_col({row, _}, new_col), do: {row, new_col}

  def shift_east_one_row({_, items}, width), do: shift(items, width, :desc, &decr/1, &get_col/1, &update_col/2)
  def shift_west_one_row({_, items}), do: shift(items, -1,  :asc, &incr/1, &get_col/1, &update_col/2)
  def shift_north_one_col({_, items}), do: shift(items, -1,  :asc, &incr/1, &get_row/1, &update_row/2)
  def shift_south_one_col({_, items}, height), do: shift(items, height, :desc, &decr/1, &get_row/1, &update_row/2)

  def shift(items, sentinel, order, next_to, field, update_field) do
    items
    |> Enum.sort(order)
    |> Enum.reduce({[], []},
      fn {coord, item} = orig, {stack, processed} ->
        opening = next_to.(List.first(stack, sentinel))
        case item do
          "#" -> {[field.(coord) | stack], [orig | processed]}
          "O" -> {[opening | stack], [{update_field.(coord, opening), "O"} | processed]}
        end
      end)
    |> elem(1)
  end
end
