import AOC

aoc 2024, 2 do
  def p1(input) do
    input |> common() |> Enum.count(&safe?/1)
  end

  def p2(input) do
    input |> common() |> Enum.count(&almost_safe?/1)
  end

  defp safe?(level) do
    values = level |> Enum.chunk_every(2, 1, :discard) |> Enum.map(&safe/1)
    Enum.all?(values, &(&1 == :increasing)) or Enum.all?(values, &(&1 == :decreasing))
  end

  defp almost_safe?(values) do
    0..(length(values)-1)
    |> Enum.map(&List.delete_at(values, &1))
    |> Enum.any?(&safe?/1)
  end

  def safe([a, b]) do
    diff = abs(a-b)
    cond do
      diff == 0 or diff > 3 -> nil
      b < a -> :decreasing
      a < b -> :increasing
    end
  end

  defp common(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) end)
  end
end
