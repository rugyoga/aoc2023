import AOC

aoc 2022, 13 do
  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn block -> block |> String.split("\n", trim: true) |> Enum.map(&(&1 |> Code.eval_string() |> elem(0))) end)
end

def in_order?([], []), do: :eq
def in_order?([], [_ | _]), do: :lt
def in_order?([_ | _], []), do: :gt
def in_order?([a | as], [b | bs]) do
    first = in_order?(a, b)
    if(first == :eq, do: in_order?(as, bs), else: first)
end
def in_order?(a, b) when is_list(a) and is_integer(b), do: in_order?(a, [b])
def in_order?(a, b) when is_integer(a) and is_list(b), do: in_order?([a], b)
def in_order?(a, b) when is_integer(a) and is_integer(b), do: if(a < b, do: :lt, else: if(a == b, do: :eq, else: :gt))

def p1(input) do
    input
    |> parse()
    |> Enum.map(fn [a, b] -> in_order?(a, b) end)
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {b, i} -> if b != :gt, do: [i], else: [] end)
    |> Enum.sum()
end

def p2(input) do
    a = [[2]]
    b = [[6]]
    xs = input
      |> parse()
      |> Enum.reduce([], fn [a, b], acc -> [a | [b | acc]] end)
      |> then(fn xs -> [a | [ b  | xs]] end)
      |> Enum.sort(fn a, b -> in_order?(a,b) == :lt end)
    (1+Enum.find_index(xs, &(&1 == a))) * (1+Enum.find_index(xs, &(&1 == b)))
end
end
