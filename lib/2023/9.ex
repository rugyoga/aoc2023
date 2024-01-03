import AOC

aoc 2023, 9 do
  def p1(input) do
    parse(input)
    |> Enum.map(
      fn nums ->
        nums
        |> recurse
        |> Enum.map(&Enum.reverse/1)
        |> Enum.reverse()
        |> carry_plus(0)
        |> List.last()
      end)
    |> Enum.sum()
  end

  def p2(input) do
    parse(input)
    |> Enum.map(
      fn nums ->
        nums
        |> recurse()
        |> Enum.reverse()
        |> carry_minus(0)
        |> List.last()
      end)
    |> Enum.sum()
  end

  def recurse(nums) do
    if Enum.all?(nums, &(&1 == 0)) do
      [nums]
    else
      [nums | recurse(diffs(nums))]
    end
  end

  def carry_plus([], carry), do: [carry]
  def carry_plus([[x | xs] | ys], carry) do
    [[x + carry | [x | xs]] | carry_plus(ys, x + carry)]
  end

  def carry_minus([], carry), do: [carry]
  def carry_minus([[x | xs] | ys], carry) do
    [[x - carry | [x | xs]] | carry_minus(ys, x - carry)]
  end

  def diffs([]), do: []
  def diffs([_]), do: []
  def diffs([x | xs]), do: [hd(xs)-x | diffs(xs)]

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.split(" ") |> Enum.map(&String.to_integer/1) end)
  end
end
