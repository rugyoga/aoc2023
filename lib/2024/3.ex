import AOC

aoc 2024, 3 do
  def p1(input), do: parse(input, &process_p1/2)
  def p2(input), do: parse(input, &process_p2/2)

  def parse(input, process) do
    ~r/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/
    |> Regex.scan(input)
    |> Enum.reduce(0, process)
    |> abs()
  end

  def process_p1([_, a, b], count), do: count + String.to_integer(a) * String.to_integer(b)
  def process_p1(_, count), do: count

  def process_p2(["do()"], count), do: abs(count)
  def process_p2(["don't()"], count), do: -abs(count)
  def process_p2(match, count) when count >= 0, do: process_p1(match, count)
  def process_p2(_, count), do: count
end
