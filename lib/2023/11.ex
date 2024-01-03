import AOC

aoc 2023, 11 do
  def p1(input) do
    calculate(input, 2)
  end

  def p2(input) do
    calculate(input, 1_000_000)
  end

  def calculate(input, multiplier) do
    grid = Grid.parse(input)
    blank_rows = 0..(grid.rows-1) |> Enum.filter(fn row -> Enum.all?(0..(grid.cols-1), fn col -> grid.map[{row, col}] == "." end) end)
    blank_cols = 0..(grid.cols-1) |> Enum.filter(fn col -> Enum.all?(0..(grid.rows-1), fn row -> grid.map[{row, col}] == "." end) end)
    galaxies = Enum.filter(grid.map, fn {_, char} -> char == "#" end) |> Enum.unzip() |> elem(0)
    for i <- 1..Enum.count(galaxies), j <- 1..i, j < i do
      distance(Enum.at(galaxies, i-1), Enum.at(galaxies, j-1), blank_rows, blank_cols, multiplier)
    end |> Enum.sum()
  end

  def distance({a, b}, {c, d}, blank_rows, blank_cols, multiplier) do
    [lo_row, hi_row] = [a, c] |> Enum.sort()
    [lo_col, hi_col] = [b, d] |> Enum.sort()
    [blank_rows |> Enum.count(fn row -> lo_row <= row and row <= hi_row end) |> Kernel.*(multiplier-1),
     blank_cols |> Enum.count(fn col -> lo_col <= col and col <= hi_col end) |> Kernel.*(multiplier-1),
     hi_row - lo_row,
     hi_col - lo_col] |> Enum.sum()
  end
end
