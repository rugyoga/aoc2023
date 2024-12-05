import AOC

aoc 2024, 5 do
  def p1(input) do
    {rules, updates} = parse(input)
    updates
    |> Enum.filter(&valid?(rules, &1))
    |> Enum.map(fn update -> update |> Enum.at(div(length(update),2)) end)
    |> Enum.sum()
  end

  def valid?(_, []), do: true
  def valid?(rules, [x | xs]), do: Enum.all?(xs, fn y -> y in rules[x] end) and valid?(rules, xs)

  def parse(input) do
    [rules, update] = String.split(input, "\n\n")
    {rules
    |> String.split("\n")
    |> Enum.map(fn s -> s |> String.split("|") |> Enum.map(&String.to_integer/1) end)
    |> Enum.group_by(fn [key, _] -> key end, fn [_, value] -> value end),
    update
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.split(",") |> Enum.map(&String.to_integer/1) end)
    }
  end

  def fixup(_, []), do: []
  def fixup(rules, current) do
    next = Enum.find(current, fn x -> current -- rules[x] == [x] end)
    [next | fixup(rules, List.delete(current, next))]
  end

  def p2(input) do
    {rules, updates} = parse(input)
    updates
    |> Enum.reject(&valid?(rules, &1))
    |> Enum.map(&fixup(rules, &1))
    |> Enum.map(fn update -> update |> Enum.at(div(length(update),2)) end)
    |> Enum.sum()
  end
end
