defmodule Grid do
  defstruct [:rows, :cols, :map]

  defimpl String.Chars, for: Grid do
    def to_string(grid) do
      "%Grid{ rows: #{grid.rows}, cols: #{grid.cols}, map: #{inspect(grid.map)}}"
    end
  end

  def parse(input, ignore \\ [], f \\ &Function.identity/1) do
    lines = input |> String.split("\n", trim: true)
    lines
    |> Enum.with_index
    |> Enum.flat_map(
      fn {line, row} ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index
        |> Enum.reject(fn {char, _} -> char in ignore end)
        |> Enum.map(fn {char, col} -> {{row, col}, f.(char)} end)
      end)
    |> then(fn items -> %Grid{rows: length(lines), cols: String.length(hd(lines)), map: Map.new(items)} end)
  end

  def hash(grid, items, default \\ nil) do
    for row <- 0..(grid.rows-1), col <- 0..(grid.cols-1) do
      item = Map.get(grid.map, {row, col}, default)
      Enum.find_index(items, item) || 0
    end
    |> Integer.undigits(length(items))
  end

  def in?(grid, {r, c}), do: 0 <= r and r < grid.rows and 0 <= c and c < grid.cols

  def neighbours_4(grid, {r, c}), do: [{r-1, c}, {r+1, c}, {r, c-1}, {r, c+1}] |> Enum.filter(&in?(grid, &1))
  def neighbours_8(grid, {r, c}), do: [{r-1, c}, {r+1, c}, {r, c-1}, {r, c+1}, {r-1, c-1}, {r+1, c-1}, {r-1, c-1}, {r+1, c+1}] |> Enum.filter(&in?(grid, &1))

  def valid_coords(grid, coords), do: Enum.filter(coords, &in?(grid, &1))
  def valid_items(grid, items), do: Enum.filter(items, fn {coord, _} -> in?(grid, coord) end)
end
