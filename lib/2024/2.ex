import AOC

aoc 2024, 2 do
  def p1(input), do: common(input, &safe?/1)

  def p2(input), do: common(input, &almost_safe?/1)

  defp safe?(level) do
    values = level |> Enum.chunk_every(2, 1, :discard) |> Enum.map(&classify/1)
    Enum.all?(values, &(&1 == :increasing)) or Enum.all?(values, &(&1 == :decreasing))
  end

  defp almost_safe?(values) do
    0..(length(values)-1)
    |> Enum.map(&List.delete_at(values, &1))
    |> Enum.any?(&safe?/1)
  end

  def classify([a, b]) do
    if abs(a-b) in 1..3 do
      if(b < a, do: :decreasing, else: :increasing)
    end
  end

  defp common(input, f) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) end)
    |> Enum.count(f)
  end
end
