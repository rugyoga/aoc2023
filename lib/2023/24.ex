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

  def map_pairs(list, f) do
    for a <- list, b <- list, a < b, do: f.(a, b)
  end

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

  def intersection(e1, e2) do
    {a, c} = line(e1)
    {b, d} = line(e2)
    if a != b do
      x = (d - c) / (a - b)
      y = a * x + c
      {{x, y}, e1, e2}
    end
  end

  def line({{x, y}, {vx, vy}}) do
    gradient = vy/vx
    {gradient, -gradient * x + y}
  end

  def coefficients([{{x1, y1, _}, {vx1, vy1, _}}, {{x2, y2, _}, {vx2, vy2, _}}]) do
    {
      [vy2 - vy1, vx1 - vx2, y1 - y2, x2 - x1],
      (vx1 * y1) - (vx2 * y2) + (x2 * vy2) - (x1 * vy1)
    }
  end

  def position({p, _}), do: p
  def velocity({_, v}), do: v
  def key({k, _}), do: k
  def value({_, v}), do: v

  @doc """
  All the points are integers.
  That implies that the answer to the problem are all integers.
  So find a collection of hailstones moving at the same speed
  along one axis. The distance between them will be an exact
  multiple of the answer's velocity combined with the stone's velocity.

  i.e. abs(vi + v) * t = d
  """

  def compute_gap({vi, items}, axis) do
    items
    |> Enum.map(&(&1 |> position() |> elem(axis)))
    |> Enum.sort
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b-a end)
    |> Enum.reduce(&Math.gcd/2)
    |> then(&[&1 - vi, -(&1 + vi)])
  end

  def compute_axis_velocity(stones, axis) do
    stones
    |> Enum.group_by(&(&1 |> velocity() |> elem(axis)))
    |> Enum.filter(&(&1 |> value() |> length() |> Kernel.>(2)))
    |> Enum.map(&compute_gap(&1, axis))
  end

  def compute_velocities(stones) do
    0..2
    |> Enum.map(fn axis -> stones |> compute_axis_velocity(axis) |> List.flatten() |> Enum.frequencies() |> Enum.max_by(&value/1) |> key() end)
    |> Enum.map(& -&1)
    |> List.to_tuple()
  end

  def format(n) do
    n
    |> Integer.to_charlist
    |> Enum.reverse
    |> Enum.chunk_every(3)
    |> Enum.join(",")
    |> String.reverse
  end

  @doc """
  https://math.stackexchange.com/questions/313526/intersection-between-two-lines
  """
  def tensor(t), do: t |> Tuple.to_list |> Nx.tensor(type: :s64)
  def tensor2(t), do: t |> Tuple.to_list |> Enum.take(2) |> Nx.tensor(type: :s64)
  def intersect(v, {ap, av} = a, {bp, bv} = b) do
    [v_t, ap_t, av_t, bp_t, bv_t] = Enum.map([v, ap, av, bp, bv], &tensor2(&1))

    p2_t = Nx.subtract(bp_t, ap_t)
    av2_t = Nx.subtract(av_t, v_t)
    bv2_t = Nx.subtract(v_t, bv_t)
    a_matrix_t = Nx.stack([av2_t, bv2_t]) |> Nx.transpose()
    [t1, t2] = Nx.LinAlg.solve(a_matrix_t, p2_t) |> Nx.to_list() |> Enum.map(&trunc/1)
    _a_answer = compute_intersection(a, v, t1)
    compute_intersection(b, v, t2)
    |> Nx.to_list()
    |> Enum.sum()
  end

  def compute_intersection({point, velocity}, v, t) do
    Nx.add(tensor(point), Nx.multiply(Nx.subtract(tensor(velocity), tensor(v)), t))
  end

  def p2(input) do
    stones = input |> parse_stones()
    {{min_x, _, _}, _} = stones |> Enum.min_by(fn {{x, _, _}, _} -> x end)
    {{_, min_y, _}, _} = stones |> Enum.min_by(fn {{_, y, _}, _} -> y end)
    {{_, _, min_z}, _} = stones |> Enum.min_by(fn {{_, _, z}, _} -> z end)
    stones = Enum.map(stones, fn {{x, y, z}, v} -> {{x-min_x, y-min_y, z-min_z}, v} end)
    v = stones |> compute_velocities()
    intersect(v, Enum.at(stones, 16), Enum.at(stones, 251)) + min_x + min_y + min_z
  end
end
