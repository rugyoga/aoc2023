import AOC

aoc 2023, 10 do
  def p1(input) do
    {_dots, {graph, start}} = input |> grid() |> parse()
    search({[{start, []}], []}, graph |> Enum.map(&pipe/1) |> Map.new, %{})
    |> longest_path()
    |> Enum.count()
  end

  def longest_path(paths) do
    paths
    |> Enum.max_by(fn {_, paths} -> paths |> Enum.count() end)
    |> elem(1)
  end

  def parse(grid) do
    {dots, non_dots} = grid |> Enum.split_with(fn {_, char} -> char == "." end)
    {start, _} = Enum.find(non_dots, fn {_, char} -> char == "S" end)
    graph = non_dots |> Map.new |> fix_graph(start)
    {dots |> Enum.unzip() |> elem(0) |> MapSet.new(), {graph, start}}
  end

  def grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.flat_map(
      fn {line, row} ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index
        |> Enum.map(fn {char, col} -> {{row, col}, char} end)
      end)
  end

  def count_enclosed(loop_map) do
    loop_map
    |> Enum.group_by(fn ({{row, _}, _}) -> row end)
    |> Enum.sort()
    |> Enum.map(&count_row/1)
    |> Enum.sum()
  end

  def count_row({_, items}), do: items |> Enum.sort() |> count_row_rec(:out)

  def count(_, []), do: 0
  def count(col, [{{_, next_col}, _} | _]), do: next_col - (col+1)

  def count_row_rec([], _), do: 0
  def count_row_rec([{{_, col}, "|"} | pipes], :out), do: count(col, pipes) + count_row_rec(pipes, :in)
  def count_row_rec([{_, "|"} | pipes], :in), do: count_row_rec(pipes, :out)
  def count_row_rec([{_, "L"} | pipes], state) do
    [{{_, col}, end_pipe} | rest_pipes] = skip_horizontal(pipes)
    after_ = if(end_pipe == "7", do: invert(state), else: state)
    delta  = if(after_ == :in, do: count(col, rest_pipes), else: 0)
    delta + count_row_rec(rest_pipes, after_)
  end
  def count_row_rec(input, state) do
    a = plan_a(input, state)
    #b = plan_b(input, state, n)
    # if a != b do
    #   IO.inspect(input, label: "input")
    #   IO.inspect(state, label: "state")
    #   IO.inspect(n, label: "n")
    #   IO.inspect(a, label: "a")
    #   IO.inspect(b, label: "b")
    # end
    a
  end

  def plan_a([{_, "F"} | pipes], state) do
    [{{_, col}, end_pipe} | rest_pipes] = skip_horizontal(pipes)
    after_ = if(end_pipe == "J", do: invert(state), else: state)
    delta = if(after_ == :in, do: count(col, rest_pipes), else: 0)
    delta + count_row_rec(rest_pipes, after_)
  end

  def plan_b([{_, "F"} | pipes], state) do
    [{coord, end_pipe} | rest_pipes] = skip_horizontal(pipes)
    if end_pipe == "J" do
      count_row_rec([{coord, "|"} | rest_pipes], state)
    else
      count_row_rec(rest_pipes, state)
    end
  end

  def skip_horizontal(pipes), do: pipes |> Enum.drop_while(fn {_, pipe} -> pipe == "-" end)

  def invert(:in), do: :out
  def invert(:out), do: :in
  def p2(input) do
    grid = grid(input)
    {_, {graph, start}} = parse(grid)
    loop_set = graph |> Enum.map(&pipe/1) |> Map.new |> loop(start)
    loop_map = graph |> Enum.filter(fn {coord, _} -> MapSet.member?(loop_set, coord) end) |> Map.new()
    count_enclosed(loop_map)
  end

  def loop(graph, start) do
    forwards = search({[{start, []}], []}, graph, %{}) |> longest_path()
    graph2 = Map.put(graph, start, Enum.reverse(graph[start]))
    backwards = search({[{start, []}], []}, graph2, %{start => []}) |> longest_path()
    MapSet.new(forwards)
    |> MapSet.union(MapSet.new(backwards))
    |> MapSet.put(start)
  end

  def search({[], []}, _, visited), do: visited
  def search({[], rest}, graph, visited), do: search({Enum.reverse(rest), []}, graph, visited)
  def search({[{x, path} | xs], rest}, graph, visited) do
    to_visit = Enum.reject(graph[x], &Map.has_key?(visited, &1))
    search(
      {xs, Enum.map(to_visit, &{&1, [&1 | path]}) ++ rest},
      graph,
      Enum.reduce(to_visit, visited, &Map.put(&2, &1, [&1 | path]))
    )
  end

  def fix_graph(graph, coord) do
    west?  = Map.get(graph,  west(coord)) in ["-", "F", "L"]
    north? = Map.get(graph, north(coord)) in ["|", "7", "F"]
    east?  = Map.get(graph,  east(coord)) in ["-", "J", "7"]
    south? = Map.get(graph, south(coord)) in ["|", "L", "J"]
    Map.put(
      graph,
      coord,
      cond do
        north? and south? -> "|"
        east? and west? -> "-"
        north? and east? -> "L"
        north? and west? -> "J"
        south? and west? -> "7"
        south? and east? -> "F"
        true -> IO.inspect({west?, north?, east?, south?})
      end)
  end

  def pipe({coord, char}) do
    {coord,
    case char do
      "|" -> [north(coord), south(coord)]
      "-" -> [east(coord), west(coord)]
      "L" -> [north(coord), east(coord)]
      "J" -> [north(coord), west(coord)]
      "7" -> [south(coord), west(coord)]
      "F" -> [south(coord), east(coord)]
      x -> x
    end}
  end

  def north({row, col}), do: {row-1, col}
  def south({row, col}), do: {row+1, col}
  def east({row, col}), do: {row, col+1}
  def west({row, col}), do: {row, col-1}
end
