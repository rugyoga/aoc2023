import AOC

aoc 2023, 15 do
  def p1(input) do
    input |> String.split(",", trim: true) |> Enum.map(&hash/1) |> Enum.sum()
  end

  def hash(string) do
    string
    |> to_charlist()
    |> Enum.reduce(0, fn ascii, hash -> rem((hash + ascii) * 17, 256) end)
  end

  def p2(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.reduce(%{},
      fn command, boxes ->
        case String.split(command, ["=", "-"], trim: true) do
          [target, n] ->
            box = hash(target)
            n = String.to_integer(n)
            stack = Map.get(boxes, box, [])
            index = Enum.find_index(stack, fn {label, _} -> label == target end)
            stack = if is_nil(index) do [{target, n} | stack] else List.replace_at(stack, index, {target, n}) end
            Map.put(boxes, box, stack)
        [target] ->
          box = hash(target)
          stack = Map.get(boxes, box, []) |> Enum.reject(fn {label, _} -> label == target end)
          Map.put(boxes, box, stack)
        end
      end)
    |> Enum.flat_map(fn {box, stack} -> stack |> Enum.reverse() |> Enum.with_index(1) |> Enum.map(fn {{_, focal}, slot} -> focal * slot * (box+1) end) end)
    |> Enum.sum()
  end
end
