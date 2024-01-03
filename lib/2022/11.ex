import AOC

aoc 2022, 11 do
  def monkeys(), do: [%{ divisor: 13, throw: [6, 2], op: &(&1*3) },
            %{ divisor: 3,  throw: [7, 4], op: &(&1+1) },
            %{ divisor: 7,  throw: [1, 4], op: &(&1*13) },
            %{ divisor: 2,  throw: [6, 0], op: &(&1*&1) },
            %{ divisor: 19, throw: [5, 7], op: &(&1+7) },
            %{ divisor: 5,  throw: [3, 0], op: &(&1+8) },
            %{ divisor: 11, throw: [1, 2], op: &(&1+4) },
            %{ divisor: 17, throw: [3, 5], op: &(&1+5) }]

  @initial [[89, 73, 66, 57, 64, 80],
            [83, 78, 81, 55, 81, 59, 69],
            [76, 91, 58, 85],
            [71, 72, 74, 76, 68],
            [98, 85, 84],
            [78],
            [86, 70, 60, 88, 88, 78, 74, 83],
            [81, 58]]

  def run(i, state, less_worry) do
      monkey = Enum.at(monkeys(), i)
      {_, worries} = state |> Enum.at(i)
      worries
      |> Enum.reduce(
          state,
          fn worry, state ->
              new_worry = less_worry.(monkey.op.(worry))
              enqueue(
                  state,
                  Enum.at(monkey.throw, if(rem(new_worry, monkey.divisor) == 0, do: 0, else: 1)),
                  new_worry)
          end
      )
      |> List.replace_at(i, {Enum.count(worries), []})
  end

  def run_round(state, less_worry), do: 0..7 |> Enum.reduce(state, &run(&1, &2, less_worry))

  def enqueue(state, n, x), do: state |> List.update_at(n, fn {c, ws} -> {c, ws ++ [x]} end)

  def solve(rounds, less_worry) do
      @initial
      |> Enum.map(&{0, &1})
      |> Stream.iterate(fn s -> run_round(s, less_worry) end)
      |> Stream.drop(1) |> Enum.take(rounds)
      |> Enum.zip_reduce([], fn xs, acc -> [xs |> Enum.map(&elem(&1, 0)) |> Enum.sum() | acc] end)
      |> Enum.sort(:desc)
      |> Enum.take(2)
      |> Enum.product()
  end

  def p1(_input), do: solve(20, &div(&1, 3))
  def p2(_input) do
      modulo = monkeys() |> Enum.map(&(&1.divisor)) |> Enum.product()
      solve(10_000, &rem(&1, modulo))
  end
end
