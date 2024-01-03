import AOC

aoc 2022, 14 do
  @start {500,0}

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
                    line
                    |> String.split(" -> ", trim: true)
                    |> Enum.map(fn pair -> pair |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1) end)
                    end)
    |> build_blocks(MapSet.new())
  end

  def build_blocks(lines, blocks) do
    Enum.reduce(
      lines,
      blocks,
      fn line, blocks ->
        line
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce(
          blocks,
          fn [[x1, y1], [x2, y2]], blocks ->
              if x1 == x2 do
                  y1..y2 |> Enum.reduce(blocks, fn y, blocks -> MapSet.put(blocks, {x1, y}) end)
              else
                  x1..x2 |> Enum.reduce(blocks, fn x, blocks -> MapSet.put(blocks, {x, y1}) end)
              end
          end)
      end)
  end

  def drop_all_sand(blocks) do
    {_, y_max} = Enum.max_by(blocks, fn {_, y} -> y end)
    Stream.iterate(blocks, &drop_sand(&1, @start, y_max))
  end

  def create_floor(blocks) do
    {{x_min, _}, {x_max, _}} = Enum.min_max_by(blocks, fn {x, _} -> x end)
    {_, y_max} = Enum.max_by(blocks, fn {_, y} -> y end)
    Enum.reduce(x_min-y_max..x_max+y_max, blocks, &MapSet.put(&2, {&1, y_max+2}))
  end

  def drop_sand(blocks, {x, y}, y_max) do
    cond do
    y > y_max -> blocks
    MapSet.member?(blocks, {x, y}) ->
        cond do
        !MapSet.member?(blocks, {x-1, y}) -> drop_sand(blocks, {x-1, y}, y_max)
        !MapSet.member?(blocks, {x+1, y}) -> drop_sand(blocks, {x+1, y}, y_max)
        true -> MapSet.put(blocks, {x, y-1})
        end
    true -> drop_sand(blocks, {x, y+1}, y_max)
    end
  end

  def p1(input) do
    input
    |> parse()
    |> drop_all_sand()
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.take_while(fn [a, b] -> Enum.count(b) > Enum.count(a) end)
    |> Enum.count()
  end

  def p2(input) do
    input
    |> parse()
    |> create_floor()
    |> drop_all_sand()
    |> Enum.take_while(fn blocks -> !Enum.member?(blocks, @start) end)
    |> Enum.count()
  end
end
