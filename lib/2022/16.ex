import AOC

aoc 2022, 16 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&extract/1)
    |> Map.new()
  end

  def extract(line) do
    ~r/Valve (?<valve>..) has flow rate=(?<flow>\d+); tunnel(?:s)? lead(?:s)? to valve(?:s)? (?<valves>.*)/
    |> Regex.named_captures(line)
    |> then(fn m ->
      {m["valve"],
       %{rate: String.to_integer(m["flow"]), edges: String.split(m["valves"], ", ", trim: true)}}
    end)
  end

  def closed(graph) do
    graph
    |> Enum.flat_map(fn {name, v} -> if(v.rate > 0, do: [name], else: []) end)
    |> MapSet.new()
  end

  def generate_costs({pq, costs}, graph, uncosted) do
    if Heap.empty?(pq) do
      costs
    else
      {{cost, {a, b}}, pq} = Heap.pop(pq)
      Enum.reduce(
        for(
          from_b <- graph[b].edges,
          a != from_b and !Map.has_key?(costs, order(a, from_b)),
          do:
            order(a, from_b) ++
              for(
                from_a <- graph[a].edges,
                from_a != b and !Map.has_key?(costs, order(from_a, b)),
                do: order(from_a, b)
              )
        ),
        {pq, costs},
        fn edge, {pq, costs} ->
          {pq |> Heap.push({cost + 1, edge}), costs |> Map.put(edge, cost + 1)}
        end
      )
      |> generate_costs(graph, uncosted)
    end
  end

  def order(a, b), do: if(a < b, do: {a, b}, else: {b, a})

  def generate_costs(graph, closed) do
    costs =
      Enum.reduce(graph, %{}, fn {valve, %{edges: valves}}, costs ->
        Enum.reduce(valves, costs, &Map.put(&2, order(&1, valve), 1))
      end)

    uncosted =
      for x <- closed,
          y <- closed,
          x < y and !Map.has_key?(costs, {x, y}),
          into: MapSet.new(),
          do: {x, y}

    costs
    |> Enum.reduce(Heap.new(), fn {edge, cost}, costs -> Heap.push(costs, {cost, edge}) end)
    |> generate_costs(graph, uncosted)
    |> Enum.flat_map(fn {{a, b}, cost} -> [{{a, b}, cost}, {{b, a}, cost}] end)
    |> Enum.group_by(fn {{a, _}, _} -> a end)
    |> Enum.map(fn {a, a_b_costs} ->
      {a, a_b_costs |> Enum.map(fn {{_, b}, cost} -> {b, cost} end) |> Map.new()}
    end)
    |> Map.new()
  end

  def search(pq, graph, costs) do
    {result, pq} = Heap.pop(pq)

    if result != :empty do
      {pq_key, {edge, closed, path}} = result

      if Enum.empty?(closed) do
        pq
      else
        closed
        |> IO.inspect(label: "edges")
        |> Enum.reduce(pq, &open(&1, costs[edge][&1], &2, pq_key, graph, closed, path))
        |> search(graph, costs)
      end
    end
  end

  @open_cost 1

  def open(to_edge, move_cost, pq, {minutes, neg_cost}, graph, closed, path) do
    new_minutes = (minutes - move_cost - @open_cost) |> IO.inspect(label: "new_minutes")

    if new_minutes >= 0 do
      new_cost = (neg_cost - new_minutes * graph[to_edge].rate) |> IO.inspect(label: "new_cost")

      Heap.push(
        pq,
        {{new_cost, new_minutes}, {to_edge, MapSet.delete(closed, to_edge), [to_edge | path]}}
      )
      |> IO.inspect(label: "Added(#{to_edge},#{move_cost})")
      |> display(label: "open")
    else
      pq
    end
  end

  def first_move(graph, closed, minutes, start) do
    pq = Heap.new() |> Heap.push({{minutes, 0}, {start, closed, []}})

    if MapSet.member?(closed, start) do
      open(start, 0, pq, {minutes, 0}, graph, closed, [])
    else
      pq
    end
  end

  def display(h, opts \\ []) do
    IO.inspect(Heap.to_list(h), opts)
    h
  end

  def p1(input) do
    graph = parse(input)
    closed = closed(graph) |> IO.inspect(label: "closed")
    costs = generate_costs(graph, closed) |> IO.inspect(label: "costs")

    graph
    |> first_move(closed, 30, "AA")
    |> search(graph, costs)
  end

  def p2(input) do
    input |> parse()
  end
end
