import AOC

aoc 2023, 25 do
  def p1(input) do
    graph = input |> parse_graph()
    Stream.repeatedly(fn -> contract(graph) end)
    |> Enum.find(fn contracted -> cut_size(contracted, graph) == 3 end)
    |> Map.keys()
    |> Enum.map(&String.length/1)
    |> Enum.map(&div(&1, 3))
    |> Enum.product()
  end

  def extract(key) do
    key
    |> String.to_charlist()
    |> Enum.chunk_every(3)
    |> Enum.map(&to_string/1)
  end

  def cut_size(contracted, original) do
    [as, bs] = contracted |> Map.keys() |> Enum.map(&extract/1)
    bs = MapSet.new(bs)
    Enum.flat_map(as, &MapSet.intersection(original[&1], bs)) |> Enum.count()
  end

  def parse_graph(input) do
    nodes = input |> String.split("\n") |> Enum.map(&parse_line/1) |> Map.new()
    Enum.reduce(nodes, nodes, &invert/2)
  end

  def invert({a, bs}, graph) do
    Enum.reduce(bs, graph, fn b, graph -> Map.update(graph, b, MapSet.new([a]), &(MapSet.put(&1, a))) end)
  end

  def contract(graph) do
    if Enum.count(graph) == 2 do
      graph
    else
      {a, a_edges} = Enum.random(graph)
      b = Enum.random(a_edges)
      b_edges = graph[b]

      ab = a <> b

      a_edges_minus_b = MapSet.delete(a_edges, b)
      b_edges_minus_a = MapSet.delete(b_edges, a)
      ab_edges = MapSet.union(a_edges_minus_b, b_edges_minus_a)

      Enum.reduce(
        a_edges_minus_b,
        graph,
        fn a_edge, graph -> Map.update!(graph, a_edge, &(&1 |> MapSet.delete(a) |> MapSet.put(ab))) end
      )
      |> then(fn graph ->
        Enum.reduce(
          b_edges_minus_a,
          graph,
          fn b_edge, graph -> Map.update!(graph, b_edge, &(&1 |> MapSet.delete(b) |> MapSet.put(ab))) end
        )
      end)
      |> Map.delete(a)
      |> Map.delete(b)
      |> Map.put(ab, ab_edges)
      |> contract()
    end
  end

  def parse_line(line) do
    [node | nodes] = String.split(line, [" ", ":"], trim: true)
    {node, MapSet.new(nodes)}
  end
end
