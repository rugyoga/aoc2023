import AOC

aoc 2023, 6 do
  def p1(input) do
    input
    |> parse()
    |> Enum.map(fn l -> Enum.map(l , &String.to_integer/1) end)
    |> Enum.zip()
    |> Enum.map(&possibilities/1)
    |> Enum.product()
  end

  def possibilities({time, record}), do: Enum.count(0..time, &(&1 * (time-&1) > record))

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&(&1 |> String.split(":") |> Enum.at(1) |> String.split(" ", trim: true)))
  end

  def p2(input) do
    input
    |> parse()
    |> Enum.map(&(&1 |> Enum.join("") |> String.to_integer()))
    |> then(fn [a, b] -> possibilities({a, b}) end)
  end
end
