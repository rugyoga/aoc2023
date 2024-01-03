import AOC

aoc 2023, 24 do
  def p1(input) do
    input
    |> parse_stones()
    |> Enum.map(fn {{x, y, _}, {vx, vy, _}} -> {{x, y}, {vx, vy}} end)
    |> map_pairs(&intersection/2)
    |> Enum.filter(&within?(&1, 200_000_000_000_000, 400_000_000_000_000))
    |> length()
  end

  def within?(nil, _, _), do: false
  def within?({{x, y}, {{x1, y1}, {vx1, vy1}}, {{x2, y2}, {vx2, vy2}}}, min, max) do
    min <= x and x <= max and min <= y and y <= max and
    (x - x1) * vx1 > 0 and (y - y1) * vy1 > 0 and
    (x - x2) * vx2 > 0 and (y - y2) * vy2 > 0
  end

  def map_pairs(list, f), do: for a <- list, b <- list, a < b, do: f.(a, b)

  def normalize({x, y}) do
    d = Math.sqrt(x * x + y * y)
    {x/d, y/d}
  end

  def parse_stones(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_stone/1)
  end

  def parse_stone(line) do
    line
    |> String.split(" @ ", trim: true)
    |> Enum.map(fn triple -> triple |> String.split(", ", trim: true) |> Enum.map(&(&1 |> String.trim() |> String.to_integer())) |> List.to_tuple() end)
    |> List.to_tuple()
  end

  # def intersection(e1, e2) do
  #   {a, c} = line(e1)
  #   {b, d} = line(e2)
  #   if a != b do
  #     x = (d - c) / (a - b)
  #     y = a * x + c
  #     {{x, y}, e1, e2}
  #   end
  # end

  def intersection({{x1, y1}, {vx1, vy1}}, {{x2, y2}, {vx2, vy2}}) do
    a = Nx.tensor([[vx1, -vx2], [vy1, -vy2]])
    b = Nx.tensor([x2 - x1, y2 - y1])
    Nx.LinAlg.solve(a, b)
  end

  def line({{x, y}, {vx, vy}}) do
    gradient = vy/vx
    {gradient, -gradient * x + y}
  end

  def p2(_input) do
  end
end
