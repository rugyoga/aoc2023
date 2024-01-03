import AOC

aoc 2022, 5 do
  def transfer([amount, from, to], stacks, f) do
    {xs, from_new } = Enum.at(stacks, from-1) |> Enum.split(amount)
    to_new = f.(xs) ++ Enum.at(stacks, to-1)
    stacks |> List.replace_at(from-1, from_new) |> List.replace_at(to-1, to_new)
  end

  def parse(input) do
    [stacks, moves] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1,"\n", trim: true))

    stacks = stacks |>
        Enum.map(
            fn s ->
                xs = String.split(s, "", trim: true)
                Enum.map([1,5,9,13,17,21,25,29,33], &Enum.at(xs, &1))
            end)
        |> Enum.zip_with(&(&1))
        |> Enum.map(fn l -> Enum.drop_while(l, &(&1 == " ")) end)
    moves = moves
        |> Enum.map(
            fn s ->
                xs = String.split(s, " ", trim: true)
                Enum.map([1,3,5], &Enum.at(xs, &1) |> String.to_integer)
            end)
    [stacks, moves]
  end

  def solve(input, f) do
    [stacks, moves] = parse(input)
    moves
    |> Enum.reduce(stacks, &transfer(&1, &2, f))
    |> Enum.map(&List.first/1)
    |> Enum.join("")
  end

  def p1(input), do: solve(input, &Enum.reverse/1)
  def p2(input), do: solve(input, &(&1))
end
