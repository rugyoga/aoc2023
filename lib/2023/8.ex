import AOC
import Math, only: [lcm: 2]

aoc 2023, 8 do
  def p1(input) do
    {moves, map} = parse(input)
    traverse("AAA", map, 0, moves, moves, &(&1 == "ZZZ"))
  end

  def extract(<<key::binary-3, " = (", left::binary-3, ", ", right::binary-3, ")">>) do
    {key, {left, right}}
  end

  def traverse(key, map, n, [], path, finished?), do: traverse(key, map, n, path, path, finished?)
  def traverse(key, map, n, [move | moves], path, finished?) do
    if finished?.(key) do
      n
    else
      traverse(elem(map[key], move), map, n+1, moves, path, finished?)
    end
  end

  def parse(input) do
    [moves_str, map_str] = input |> String.split("\n\n")
    {moves_str |> String.split("", trim: true) |> Enum.map(&(%{"L" => 0, "R" => 1}[&1])),
     map_str |> String.split("\n") |> Enum.map(&extract/1) |> Map.new}
  end

  def p2(input) do
    {moves, map} = parse(input)
    map
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Enum.map(&traverse(&1, map, 0, moves, moves, fn s -> String.ends_with?(s, "Z") end))
    |> Enum.reduce(&lcm/2)
  end
end
