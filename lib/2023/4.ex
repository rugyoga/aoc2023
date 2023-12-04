import AOC

aoc 2023, 4 do
  @moduledoc """
  https://adventofcode.com/2023/day/4
  """

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    input
    |> winning_cards()
    |> Enum.map(fn 0 -> 0; n -> 2 ** (n-1) end)
    |> Enum.sum()
  end

  def winning_cards(input) do
    process = fn card -> card |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) |> MapSet.new end
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
       [winning, held] = line |> String.split(": ") |> Enum.at(1) |> String.split("|") |> Enum.map(process)
       MapSet.intersection(winning, held) |> Enum.count()
      end)
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    input
    |> winning_cards()
    |> Enum.map(&{1, &1})
    |> process()
    |> Enum.unzip()
    |> elem(0)
    |> Enum.sum()
  end

  def process([]), do: []
  def process([{count, multiplier} = x | xs]) do
    {before, after_} = Enum.split(xs, multiplier)
    [x | process(Enum.map(before, fn {c, n} -> {c + count, n} end) ++ after_)]
  end
end
