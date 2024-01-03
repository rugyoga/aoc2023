import AOC

aoc 2023, 22 do
  def p1(input) do
    input
    |> parse()
    |> counter()
  end

  def p2(input) do
    input
    |> parse()
    |> fallen()
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_brick/1)
    |> Enum.with_index()
    |> Enum.reduce(Heap.new(), &Heap.push(&2, &1))
    |> lower_bricks([], %{})
  end

  def counter({bricks_map, cubes_map, _}) do
    Enum.count(bricks_map, fn {_, brick} -> removable?(bricks_map, cubes_map, brick) end)
  end

  def fallen({bricks_map, _, _}) do
    bricks_map
    |> Enum.map(fn {_, brick} -> fall(bricks_map, brick) end)
    |> Enum.sum()
  end

  def fall(bricks_map, brick) do
    {_, _, n} =
      bricks_map
      |> Map.values()
      |> List.delete(brick)
      |> Enum.with_index()
      |> Enum.reduce(Heap.new(), &Heap.push(&2, &1))
      |> lower_bricks([], %{})
    n
  end

  def removable?(bricks_map, cubes_map, brick) do
    Enum.all?(top_contacts(cubes_map, brick), fn id -> Enum.count(bot_contacts(cubes_map, bricks_map[id])) > 1 end)
  end

  def top_contacts(cube_map, brick), do: contacts(cube_map, brick, &top/1, &raised/1)
  def bot_contacts(cube_map, brick), do: contacts(cube_map, brick, &bottom/1, &lowered/1)

  def contacts(cube_map, brick, surface, move) do
    brick
    |> then(surface)
    |> Enum.map(move)
    |> Enum.flat_map(&if(Map.has_key?(cube_map, &1), do: [cube_map[&1]], else: []))
    |> Enum.uniq()
  end

  def lower_bricks(brick_heap, bricks, cube_map, n \\ 0) do
    if Heap.empty?(brick_heap) do
      {Map.new(bricks), cube_map, n}
    else
      {{lowest, id}, heap} = Heap.pop(brick_heap)
      {brick, cubes, lowered?} = lower_brick(lowest, cubes(lowest), cube_map)
      lower_bricks(heap, [{id, brick} | bricks], Enum.reduce(cubes, cube_map, &Map.put(&2, &1, id)), if(lowered?, do: n+1, else: n))
    end
  end

  def lowered({z, y, x}), do: {z-1, y, x}
  def raised({z, y, x}), do: {z+1, y, x}

  def lower_brick({start, finish} = brick, cubes, cube_map, lowered? \\ false) do
    lowered_cubes = Enum.map(cubes, &lowered/1)
    if Enum.any?(lowered_cubes, &occupied?(cube_map, &1)) do
      {brick, cubes, lowered?}
    else
      brick = {lowered(start), lowered(finish)}
      lower_brick(brick, lowered_cubes, cube_map, true)
    end
  end

  def parse_brick(line) do
    line |> String.split("~") |> Enum.map(&parse_points/1) |> Enum.sort() |> List.to_tuple()
  end

  def parse_points(point) do
    point |> String.split(",") |> Enum.map(&String.to_integer/1) |> Enum.reverse() |> List.to_tuple()
  end

  def occupied?(_, {0, _, _}), do: true
  def occupied?(%{} = cubes, cube), do: Map.has_key?(cubes, cube)
  def occupied?(%MapSet{} = cubes, cube), do: MapSet.member?(cubes, cube)

  def create_brick({[[x1, y1, z1], [x2, y2, z2]], id}) do
    {id, {{z1, y1, x1}, {z2, y2, x2}}}
  end

  def top({{z1, y1, x1}, {z2, y2, x2}}) do
    z_max = Enum.max([z1, z2])
    cubes({{z_max, y1, x1}, {z_max, y2, x2}})
  end

  def bottom({{z1, y1, x1}, {z2, y2, x2}}) do
    z_min = Enum.min([z1, z2])
    cubes({{z_min, y1, x1}, {z_min, y2, x2}})
  end

  def cubes({{z1, y1, x1}, {z2, y2, x2}}) do
    for x <- x1..x2, y <- y1..y2, z <- z1..z2 do
      {z, y, x}
    end
  end

  def compute_cubes({{p1, p2}, id}) do
    cubes({p1, p2}) |> Enum.map(&{&1, id})
  end
end
