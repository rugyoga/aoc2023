import AOC
import Math

aoc 2023, 8 do
  def p1(input) do
    {moves, map} = parse(input)
    traverse("AAA", map, 0, moves, moves, &(&1 == "ZZZ"))
  end

  def extract(<<key::binary-size(3), " = (", left::binary-size(3), ", ", right::binary-size(3), ")">>) do
    {key, {left, right}}
  end

  def traverse(key, map, n, [], path, finished?), do: traverse(key, map, n, path, path, finished?)
  def traverse(key, map, n, [move | moves], path, finished?) do
    if finished?.(key) do
      n
    else
      {left, right} = map[key]
      traverse(if(move == "L", do: left, else: right), map, n+1, moves, path, finished?)
    end
  end

  def parse(input) do
    [moves_str, map_str] = input |> String.split("\n\n")
    {moves_str |> String.split("", trim: true),
     map_str |> String.split("\n") |> Enum.map(&extract/1) |> Map.new}
  end

  def p2(input) do
    {moves, map} = parse(input)
    map
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Enum.map(fn start -> traverse(start, map, 0, moves, moves, &String.ends_with?(&1, "Z")) end)
    |> Enum.reduce(&lcm/2)
  end
end
