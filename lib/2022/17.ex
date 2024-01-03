import AOC

aoc 2022, 17 do
  @hline [{0,0}, {1,0}, {2,0}, {3,0}] # ----
  @cross [{0,1}, {1,0}, {1,1}, {1,2}, {2,1}] # #
  @ell   [{0,0}, {1,0}, {2,0}, {2,1}, {2,2}] # _|
  @vline [{0,0}, {0,1}, {0,2}, {0,3}] # |
  @block [{0,0}, {0,1}, {1,0}, {1,1}] # ||

  def p1(input) do
    input
    |> parse()
    |> start_new_rock(%{}, 0, 0, fn _, r, _ -> r == 2022 end)
  end

  def p2(input) do
    input
    |> parse()
    |> start_new_rock(%{}, 0, 0, fn _, _, _ -> false end)
      #1_000_000_000_000
      #{board.height, r, i}
  end

  def parse(input) do
    input
    |> String.split("", trim: true)
    |> Enum.map(&if(&1 == "<", do: -1, else: 1))
    |> then(&%{moves: &1, rocks: rocks(), board: floor(), height: 0, n: Enum.count(&1)})
  end

  def rocks(), do: [@hline, @cross, @ell, @vline, @block] |> Enum.map(&MapSet.new/1)
  def floor, do: MapSet.new([{0,-1}, {1,-1}, {2,-1}, {3,-1}, {4,-1}, {5,-1}, {6,-1}])

  def part1 do
  end

  def move(state, memo, rock, r, i, f) do
      delta = Enum.at(state.moves, rem(i, state.n))
      rock_new = transform(rock, delta, 0)
      {min_x, max_x} = rock_new |> xs() |> Enum.min_max()
      if MapSet.disjoint?(rock_new, state.board) and 0 <= min_x and max_x <= 6 do
          drop(state, memo, rock_new, r, i+1, f)
      else
          drop(state, memo, rock, r, i+1, f)
      end
  end

  def drop(state, memo, rock, r, i, f) do
      rock_new = transform(rock, 0, -1)
      if MapSet.disjoint?(rock_new, state.board) do
          move(state, memo, rock_new, r, i, f)
      else
          board = Enum.to_list(state.board) ++ Enum.to_list(rock)
                  |> Enum.group_by(&get_x/1)
                  |> Enum.map(fn {_, items} -> Enum.max_by(items, &get_y/1) end)
                  |> MapSet.new()
          %{state |
              board: board,
              height: Enum.max([1 + Enum.max(ys(rock)), state.height])}
          |> start_new_rock(memo, r, i, f)
      end
  end

  def start_new_rock(state, memo, r, i, f) do
      #IO.inspect(state, label: "state")
      min_y = state.board |> Enum.min_by(&get_y/1) |> get_y
      key = {rem(r, 5), rem(i, state.n), state.board |> Enum.sort() |> Enum.map(fn {_, y} -> y-min_y end)}
      cond do
      Map.has_key?(memo, key) -> {:collision, {key, state, memo[key]}}
      f.(state, r, i) -> {:complete, {state, r, i}}
      true -> move(state, Map.put(memo, key, state), state.rocks |> Enum.at(rem(r, 5)) |> transform(2, state.height+3), r+1, i, f)
      end
  end

  def transform(rock, xd, yd), do: rock |> Enum.map(fn {x, y} -> {x+xd, y+yd} end) |> MapSet.new()

  def xs(rock), do: rock |> Enum.unzip() |> get_x()
  def ys(rock), do: rock |> Enum.unzip() |> get_y()
  def get_x({x, _}), do: x
  def get_y({_, y}), do: y
end
