import AOC

aoc 2023, 19 do
  def p1(input) do
    [code, data] = input |> String.split("\n\n")
    code = parse_code(code)
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_data/1)
    |> Enum.map(&process(code, :in, &1))
    |> Enum.sum()
  end

  def process(_, :A, xmas), do: xmas |> Map.values |> Enum.sum
  def process(_, :R, _), do: 0
  def process(code, label, xmas), do: evaluate(code, code[label], xmas)

  def evaluate(code, [label], xmas), do: process(code, label, xmas)
  def evaluate(code, [{pred, label} | rest], xmas), do: if(evaluate_pred(pred, xmas), do: process(code, label, xmas), else: evaluate(code, rest, xmas))

  def evaluate_pred({var, "<", n}, xmas), do: xmas[var] < n
  def evaluate_pred({var, ">", n}, xmas), do: xmas[var] > n

  def parse_data(data) do
    data
    |> String.trim_leading("{")
    |> String.trim_trailing("}")
    |> String.split(",", trim: true)
    |> Enum.map(fn pair -> pair |> String.split("=", trim: true) |> then(fn [var, num] -> {String.to_atom(var), String.to_integer(num)} end) end)
    |> Map.new
  end

  def do_snd({fst, snd}, f), do: {fst, f.(snd)}

  def parse_code(code) do
    code
    |> String.split("\n", trim: true)
    |> Enum.map(
      fn line ->
        [name, rules, _] = String.split(line, ["{", "}"])
        {String.to_atom(name),
        String.split(rules, ",")
        |> Enum.map(
          fn rule ->
            case String.split(rule, ":") do
            [pred, label] -> {compile_op(pred, if(String.contains?(pred, "<"), do: "<", else: ">")), String.to_atom(label)}
            [label] -> String.to_atom(label)
            end
          end
          )}
      end
    )
    |> Map.new
  end

  def ranges_size(ranges) do
    ranges
    |> Map.values()
    |> Enum.map(&Enum.count/1)
    |> Enum.product()
  end

  def compile_op(pred, op) do
    [var, num] = String.split(pred, op)
    {String.to_atom(var), op, String.to_integer(num)}
  end

  def split_ranges(ranges, true), do: ranges
  def split_ranges(ranges, {var, "<", num}) do
    cond do
    num in ranges[var] ->
      {lo, hi} = split_range(ranges[var], num)
      [Map.put(ranges, var, lo), Map.put(ranges, var, hi)]
    ranges[var].last < num -> [ranges, empty_ranges()]
    true -> [empty_ranges(), ranges]
    end
  end
  def split_ranges(ranges, {var, ">", num}) do
    cond do
    num in ranges[var] ->
      {lo, hi} = split_range(ranges[var], num+1)
      [Map.put(ranges, var, hi), Map.put(ranges, var, lo)]
    ranges[var].first > num -> [ranges, empty_ranges()]
    true -> [empty_ranges(), ranges]
    end
  end

  def empty_ranges(), do: %{x: [], m: [], a: [], s: []}

  def split_range(lo..hi, n), do: {lo..(n-1), n..hi}

  def process2(_, :A, ranges), do: ranges_size(ranges)
  def process2(_, :R, _), do: 0
  def process2(code, label, ranges), do: evaluate2(code, code[label], ranges)

  def evaluate2(code, [label], ranges), do: process2(code, label, ranges)
  def evaluate2(code, [{pred, label} | rest], ranges) do
    [true_ranges, false_ranges] = split_ranges(ranges, pred)
    process2(code, label, true_ranges) + evaluate2(code, rest, false_ranges)
  end

  def p2(input) do
    input
    |> String.split("\n\n")
    |> hd()
    |> parse_code()
    |> process2(:in, %{x: 1..4000, m: 1..4000, a: 1..4000, s: 1..4000})
  end
end
