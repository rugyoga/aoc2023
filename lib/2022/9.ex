import AOC

aoc 2022, 9 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split(" ", trim: true) |> then(fn [p, n] -> {p, String.to_integer(n)} end) end)
  end

  def move_all([], state), do: state.tails
  def move_all([{_, 0} | moves], state), do: move_all(moves, state)
  def move_all([{d, n} | moves], state), do: move_all([{d, n-1} | moves], move_one(d, state))

  def move_one(d, state), do: state |> move_head(d) |> move_tails() |> record_tail()

  def record_tail(%{ rope: rope, tails: tails} = state), do: %{state | tails: MapSet.put(tails, rope |> List.last())}

  def move({x, y}, "R"), do: {x+1, y}
  def move({x, y}, "L"), do: {x-1, y}
  def move({x, y}, "U"), do: {x, y+1}
  def move({x, y}, "D"), do: {x, y-1}

  def move_head(%{rope: [head | rest]} = state, dir), do: %{state | rope: [move(head, dir) | rest]}

  def move_tails(%{rope: rope} = state), do: %{state | rope: move_rope(rope)}

  def move_rope([]), do: []
  def move_rope([x]), do: [x]
  def move_rope([head | [tail | rest]]), do: [head | move_rope([move_tail(head, tail) | rest])]

  def move_tail(head, tail) do
    {xd, yd} = diff(head, tail)
    cond do
      xd == 0 and abs(yd) > 1 -> move_tail_y(tail, yd)
      xd == 0 -> tail
      yd == 0 and abs(xd) > 1 -> move_tail_x(tail, xd)
      yd == 0 -> tail
      abs(xd) > 1 or abs(yd) > 1 -> tail |> move_tail_x(xd) |> move_tail_y(yd)
      true -> tail
    end
  end

  def move_tail_x({x, y}, d), do: {if(d > 0, do: x+1, else: x-1), y}
  def move_tail_y({x, y}, d), do: {x, if(d > 0, do: y+1, else: y-1)}

  def diff({x1, y1}, {x2, y2}), do: {x1-x2, y1-y2}

  def count(moves, rope), do: move_all(moves, %{rope: rope, tails: MapSet.new([{0,0}])}) |> Enum.count()

  def p1(input), do: input |> parse() |> count([{0,0}, {0,0}])
  def p2(input), do: input |> parse() |> count([{0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}])
end
