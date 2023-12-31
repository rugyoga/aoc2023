import AOC

aoc 2023, 1 do
  @moduledoc """
  https://adventofcode.com/2023/day/1
  """

  def calibration(s) do
    s
    |> String.split("", trim: true)
    |> Enum.filter(&("0" <= &1 and &1 <= "9"))
    |> then(&String.to_integer("#{hd(&1)}#{List.last(&1)}"))
  end

  def p1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&calibration/1)
    |> Enum.sum()
  end

  def p2(input) do
    %{one: "o1e", two: "t2o", three: "t3e", four: "f4r", five: "f5e", six: "s6x", seven: "s7n", eight: "e8t", nine: "n9e"}
    |> Enum.reduce(input, fn {word, number}, s -> String.replace(s, "#{word}", number, global: true) end)
    |> p1()
  end
end
