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
    |> Enum.unzip()
    |> elem(1)
    |> Enum.map(fn 0 -> 0; n -> 2 ** (n-1) end)
    |> Enum.sum()
  end

  def winning_cards(input) do
    process = fn card -> card |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) |> MapSet.new end
    input
    |> String.split("\n", trim: true)
    |> Enum.map(
      fn line ->
        ["Card " <> n, cards] = String.split(line, ": ")
        card_strs = String.split(cards, "|")
        [winning, holding] = card_strs |> Enum.map(process)
        {String.to_integer(String.trim(n)), MapSet.intersection(winning, holding) |> Enum.count()}
      end
    )
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    input
    |> winning_cards()
    |> Enum.map(fn {i, n} -> {i, {1, n}} end)
    |> process()
    |> Enum.unzip()
    |> elem(1)
    |> Enum.unzip()
    |> elem(0)
    |> Enum.sum()
  end

  def process([]), do: []
  def process([{i, {0, n}} = x | xs]), do: [x | process(xs)]
  def process([{i, {count, multiplier}} = x | xs]) do
    {before, after_} = Enum.split(xs, multiplier)
    [x | process(Enum.map(before, fn {i, {c, n}} -> {i, {c + count, n}} end) ++ after_)]
  end
end
