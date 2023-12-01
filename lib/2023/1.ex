import AOC

aoc 2023, 1 do
  @moduledoc """
  https://adventofcode.com/2023/day/1
  """

  def p1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> s |> String.split("", trim: true) |> Enum.filter(&("0" <= &1 and &1 <= "9")) |> calibration() end)
    |> Enum.sum()
  end

  def calibration(xs), do: String.to_integer("#{hd(xs)}#{List.last(xs)}")

  def p2(input) do
    [{"one", "1"}, {"two", "2"}, {"three", "3"}, {"four", "4"}, {"five", "5"}, {"six", "6"}, {"seven", "7"}, {"eight", "8"}, {"nine", "9"}]
    |> Enum.reduce(input, fn {word, number}, s -> String.replace(s, word, "#{word}#{number}#{word}", global: true) end)
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> s |> String.split("", trim: true) |> Enum.filter(&("0" <= &1 and &1 <= "9")) |> calibration() end)
    |> Enum.sum()
  end
end
