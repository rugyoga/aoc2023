import AOC

aoc 2022, 8 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(
        fn {line, x} ->
            line
            |> String.split("", trim: true)
            |> Enum.with_index(fn element, y -> {String.to_integer(element), {x, y}} end)
        end)
  end

  def visible_row(trees) do
      trees
      |> Enum.drop(-1)
      |> Enum.drop(1)
      |> Enum.map(fn row ->
          [{x, _} | xs] = row |> Enum.drop(-1)
          xs
          |> Enum.reduce({x, []}, fn {y, p}, {max, ps} = state -> if y > max, do: {y, [p | ps]}, else: state end)
          |> elem(1)
          |> MapSet.new()
      end)
      |> Enum.reduce(&MapSet.union/2)
  end

  def transpose(l), do: l |> Enum.zip_with(&(&1))
  def reverse(t), do: t |> Enum.map(&Enum.reverse/1)

  def visible(trees) do
      trees_t = transpose(trees)
      [visible_row(trees), visible_row(trees_t), visible_row(reverse(trees)), visible_row(reverse(trees_t))]
      |> Enum.reduce(&MapSet.union/2)
      |> Enum.count()
      |> then(fn size -> size + 2 * (Enum.count(trees) - 1) + 2 * (Enum.count(trees |> List.first()) - 1) end)
  end

  def scenic(trees, {v, {row, col}} = target) do
      cdvef = trees |> Enum.at(row)
      abvgh = trees |> Enum.map(&Enum.at(&1, col))
      {cd, vef} = cdvef |> Enum.split_while(&(&1 != target))
      {ab, vgh} = abvgh |> Enum.split_while(&(&1 != target))
      [Enum.reverse(ab), Enum.reverse(cd), Enum.drop(vgh, 1), Enum.drop(vef, 1)]
      |> Enum.map(&view(&1, v))
      |> Enum.product()
  end

  def view(l, n), do: [1, f(l, n)] |> Enum.max()

  def f([], _), do: 0
  def f([{x, _} | xps], n) when x < n, do: 1 + f(xps, n)
  def f(_, _), do: 1

  def tree_house(trees) do
      trees
      |> Enum.drop(1)
      |> Enum.drop(-1)
      |> Enum.map(&(&1 |> Enum.drop(1) |> Enum.drop(-1)))
      |> List.flatten()
      |> Enum.map(&scenic(trees, &1))
      |> Enum.max()
  end

  def p1(input), do: input |> parse() |> visible()
  def p2(input), do: input |> parse() |> tree_house()
end
