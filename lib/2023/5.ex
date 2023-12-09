import AOC

aoc 2023, 5 do

  def p1(input) do
    {seeds, maps} = process(input)
    Enum.map(seeds, &maps_number(&1, maps)) |> Enum.min
  end

  def map_number([], n), do: n
  def map_number([{range, _} = fun | maps], n) do
    if(n in range, do: apply_fun(fun, n), else: map_number(maps, n))
  end

  def apply_fun({range, dest}, n), do: dest+n-range.first

  def process(input) do
    ["seeds: " <> seeds | maps] = input |> String.split("\n\n", trim: true)
    {parse_nums(seeds),
     maps
      |> Enum.map(
        fn map ->
          [_name, elements] = String.split(map, " map:\n")
            elements
            |> String.split("\n", trim: true)
            |> Enum.map(&parse_nums/1)
            |> Enum.map(&fun_new/1)
        end
      )}
  end

  def fun_new([dest, source, length]), do: {source..(source+length-1), dest}

  def map_range(range, []), do: [range]
  def map_range(arg, [{fun, _} = fun_def | maps]) do
    if Range.disjoint?(fun, arg) do
      map_range(arg, maps)
    else
      lo = Enum.max([fun.first, arg.first])
      hi = Enum.min([fun.last, arg.last])
      [apply_fun(fun_def, lo)..apply_fun(fun_def, hi) |
       (if arg.first < lo, do: map_range(arg.first..lo-1, maps), else: [])
       ++ (if hi < arg.last, do: map_range(hi+1..arg.last, maps), else: [])]
    end
  end

  def map_ranges(ranges, []), do: normalize_ranges(ranges)
  def map_ranges(ranges, [map | maps]) do
    ranges
    |> normalize_ranges()
    |> Enum.map(fn arg -> map_range(arg, map) end)
    |> List.flatten
    |> map_ranges(maps)
  end

  def normalize_ranges(ranges), do: ranges |> Enum.sort() |> merge_ranges()

  def merge_ranges([]), do: []
  def merge_ranges([a]), do: [a]
  def merge_ranges([a | [b | ranges]]) do
    if Range.disjoint?(a, b) and a.last + 1 != b.first do
      [a | merge_ranges([b | ranges])]
    else
      merge_ranges([Enum.min([a.first, b.first])..Enum.max([a.last, b.last]) | ranges])
    end
  end

  def maps_number(n, maps), do: Enum.reduce(maps, n, &map_number/2)

  def parse_nums(nums), do: nums |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)

  def p2(input) do
    {seeds, maps} = process(input)
    seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, length] -> start..(start+length-1) end)
    |> map_ranges(maps)
    |> then(&(hd(&1)).first)
  end
end
