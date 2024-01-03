import AOC

aoc 2023, 13 do
  def p1(input) do
    process(input, &calculate/1)
  end

  def p2(input) do
    process(input, &calculate_with_smudge/1)
  end

  def process(input, f) do
    {xs, ys} = input |> grids() |> Enum.map(f) |> Enum.unzip()
    combine = fn items -> items |> List.flatten() |> Enum.map(fn n -> (1 + n)/2 end) |> Enum.sum() end
    100*combine.(xs) + combine.(ys) |> trunc()
  end

  def calculate(grid) do
    grid = grid |> Enum.map(fn {x, y} -> {2*x, 2*y} end) |> MapSet.new
    max_x = max_(grid, &get_x/1)
    max_y = max_(grid, &get_y/1)
    {1..max_x//2 |> Enum.filter(fn i -> x_reflect?(grid, i, max_x) end),
     1..max_y//2 |> Enum.filter(fn i -> y_reflect?(grid, i, max_y) end)}
  end

  @spec calculate_with_smudge(any()) :: {list(), list()}
  def calculate_with_smudge(grid) do
    {original_xs, original_ys} = calculate(grid)
    grid_set = grid |> MapSet.new()
    max_x = max_(grid_set , &get_x/1)
    max_y = max_(grid_set, &get_y/1)
    for x <- 0..max_x, y <- 0..max_y do
      calculate(invert(grid_set, {x, y}))
    end
    |> Enum.reject(fn {[], []} -> true; _ -> false end)
    |> Enum.reduce(fn {x, y}, {x2, y2} -> {x ++ x2, y ++ y2} end)
    |> then(fn {xs, ys} -> {Enum.uniq(xs) -- original_xs, Enum.uniq(ys) -- original_ys} end)
   end

  def invert(grid, p) do
    if MapSet.member?(grid, p) do
      MapSet.delete(grid, p)
    else
      MapSet.put(grid, p)
    end
  end

  def get_x({x, _}), do: x
  def get_y({_, y}), do: y

  def max_(grid, f), do: Enum.max_by(grid, f) |> then(f)

  def x_reflect?(grid, i, max) do
    grid
    |> Enum.group_by(&get_y/1)
    |> Enum.all?(
      fn {_, row} ->
        Enum.all?(
          row,
          fn {x, y} -> x_r = i + i - x; x_r > max || x_r < 0 || Enum.member?(grid, {x_r, y}) end
        )
      end)
  end

  def y_reflect?(grid, i, max) do
    grid
    |> Enum.group_by(&get_x/1)
    |> Enum.all?(
      fn {_, col} ->
        Enum.all?(
          col,
          fn {x, y} -> y_r = i + i - y; y_r > max  || y_r < 0 || Enum.member?(grid, {x, y_r}) end
        )
      end)
  end

  def grid(input) do
    Grid.parse(input, ["."]).map |> Map.keys()
  end

  def grids(input) do
    input |> String.split("\n\n") |> Enum.map(&grid/1)
  end
end
