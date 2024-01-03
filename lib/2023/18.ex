import AOC

aoc 2023, 18 do
  def p1(input) do
    input
    |> parse()
    |> chunker()
    |> Enum.reduce({{0,0}, %{}}, &dig/2)
    |> elem(1)
    |> count_enclosed()
  end

  def dig([{dir1, n1, hex1}, {dir2, n2, hex2}], {{row, col}, map}) do
    {filler, final} = case {dir1, dir2} do
      {"R", "D"} -> {"-", "7"}
      {"R", "U"} -> {"-", "J"}
      {"L", "D"} -> {"-", "F"}
      {"L", "U"} -> {"-", "L"}
      {"D", "R"} -> {"|", "L"}
      {"U", "R"} -> {"|", "F"}
      {"D", "L"} -> {"|", "J"}
      {"U", "L"} -> {"|", "7"}
    end

    {delta_row, delta_col} = %{"R" => {0, 1}, "L" => {0, -1}, "U" => {-1, 0}, "D" => {1, 0}}[dir1]
    coord = {row+n1*delta_row, col+n1*delta_col}
    map = Map.put(map, coord, if(n1 == 1, do: final, else: filler))
    if n1==1 do
      {coord, map}
    else
      dig([{dir1, n1-1, hex1}, {dir2, n2, hex2}], {coord, map})
    end
  end

  def count_enclosed(loop_map) do
    loop_map
    |> Enum.group_by(fn ({{row, _}, _}) -> row end)
    |> Enum.sort()
    |> Enum.map(&count_row/1)
    |> Enum.sum()
  end

  def count_row({_, items}) do
    items
    |> Enum.sort()
    |> Enum.reduce(
      {{false, 0}, {nil, nil}},
      fn {{_, col}, pipe}, {{interior, count}, {last_col, last_turn}} ->
        case pipe do
          "L" -> {{interior, count+1+ add_count(interior, last_col, col)}, {col, "L"}}
          "F" -> {{interior, count+1+ add_count(interior, last_col, col)}, {col, "F"}}
          "J" -> {{if(last_turn == "F", do: not interior, else: interior), count+1}, {col, "J"}}
          "7" -> {{if(last_turn == "L", do: not interior, else: interior), count+1}, {col, "7"}}
          "|" -> {{not interior, count+1 + add_count(interior, last_col, col)}, {col, "|"}}
          "-" -> {{interior, count+1}, {last_col, last_turn}}
        end
      end)
    |> elem(0)
    |> elem(1)
  end

  def add_count(false, _, _), do: 0
  def add_count(true, last_col, col), do: col - last_col - 1

  def chunker(l), do: Enum.chunk_every(l, 2, 1, l)

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.split(" ", trim: true) |> then(fn [x, y, z] -> {x, String.to_integer(y), z} end) end)
  end

  def extract_hex({_, _, <<"(#", distance::binary-5, direction::binary-1, ")">>}) do
    {Enum.at(["R", "D", "L", "U"], String.to_integer(direction, 16)), String.to_integer(distance, 16), nil}
  end

  def p2(input) do
    input
    |> parse()
    |> Enum.map(&extract_hex/1)
    |> chunker()
    |> Enum.reduce({{0,0}, %{}}, &dig/2)
    |> elem(1)
    |> count_enclosed()
  end
end
