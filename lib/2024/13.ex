import AOC

aoc 2024, 13 do
  def p1(input), do: common(input, &extract/1, &p1_ok?/1)
  def p2(input), do: common(input, &extract2/1, &p2_ok?/1)

  def p1_ok?([a, b]) when a <= 100 and b <= 100, do: [3 * a + b]
  def p1_ok?(_), do: []

  def p2_ok?([a, b]), do: [3 * a + b]
  def p2_ok?(_), do: []

  def common(input, extract, ok?) do
    input
    |> String.split("\n\n")
    |> Enum.map(&(&1 |> then(extract) |> solve()))
    |> Enum.flat_map(ok?)
    |> Enum.sum()
  end

  def extract(block) do
    ["Button A: " <> a,
    "Button B: " <> b,
    "Prize: " <> c] =  block |> String.split("\n")
    [parse(a, "+"), parse(b, "+"), parse(c, "=")]
  end

  def extract2(block) do
    [a, b, c] = extract(block)
    [a, b, Enum.map(c, &(&1 + 10_000_000_000_000))]
  end

  def solve([[a, c], [b, d], [e, f]]) do
    x = ((d * e) - (b * f)) / ((a * d) - (b * c))
    y = ((a * f) - (c * e)) / ((a * d) - (b * c))
    if floor(x) == x and floor(y) == y do
      [trunc(x), trunc(y)]
    end
  end

  def parse(s, comma) do
    s
    |> String.split(", ")
    |> Enum.map(&(&1 |> String.split(comma) |> Enum.at(1) |> String.to_integer()))
  end
end
