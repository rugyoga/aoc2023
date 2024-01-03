import AOC

aoc 2023, 3 do
  def p1(input) do
    {symbols, numbers} = input |> String.split("", trim: true) |> parse({0,0}, {%{}, []})
    numbers
    |> Enum.filter(fn {indices, _} -> symbol_adjacent?(symbols, indices) end)
    |> Enum.unzip
    |> elem(1)
    |> Enum.sum()
  end

  def parse([], _, {symbols, numbers}), do: {symbols, Enum.reverse(numbers)}
  def parse([char | chars] = l, {row, col} = coord, {symbols, numbers} = state) do
    cond do
      char == "." ->
        parse(chars, {row, col+1}, state)
      char == "\n" ->
        parse(chars, {row+1, 0}, state)
      is_digit(char) ->
        {num_chars, non_num_chars} = Enum.split_while(l, &is_digit/1)
        number = num_chars |> Enum.join("") |> String.to_integer()
        {indices, last_col} = num_chars |> Enum.reduce({[], col}, fn _, {numbers, col} -> {[{row, col} | numbers], col+1} end)
        parse(non_num_chars, {row, last_col}, {symbols, [{Enum.reverse(indices), number} | numbers]})
      true ->
        parse(chars, {row, col+1}, {Map.put(symbols, coord, char), numbers})
    end
  end

  def is_digit(ch), do: "0" <= ch and ch <= "9"

  def p2(input) do
    {symbols, numbers} = input |> String.split("", trim: true) |> parse({0,0}, {%{}, []})
    numbers = numbers |> Enum.reduce(%{}, fn {indices, number}, numbers -> Enum.reduce(indices, numbers, &Map.put(&2, &1, {hd(indices), number})) end)
    symbols
    |> Enum.filter(fn {_, symbol} -> symbol == "*" end)
    |> Enum.unzip
    |> elem(0)
    |> Enum.map(&numbers_adjacent(&1, numbers))
    |> Enum.filter(fn l -> length(l) == 2 end)
    |> Enum.map(fn l -> l |> Enum.map(&elem(&1, 1)) |> Enum.product() end)
    |> Enum.sum()
  end

  def symbol_adjacent?(symbols, indices) do
    {row, first} = List.first(indices)
    {_row, last} = List.last(indices)
    before = first-1
    after_ = last+1
    before..after_
    |> Enum.map(fn col -> [{row-1, col}, {row+1, col}] end)
    |> List.flatten
    |> then(&[{row, before} | [{row, after_} | &1]])
    |> Enum.any?(&Map.has_key?(symbols, &1))
  end

  def numbers_adjacent({row, col}, numbers) do
    [{row-1, col-1}, {row-1, col}, {row-1, col+1},
     {row,   col-1},               {row,   col+1},
     {row+1, col-1}, {row+1, col}, {row+1, col+1}]
     |> Enum.map(&Map.get(numbers, &1))
     |> Enum.reject(&is_nil/1)
     |> Enum.uniq
  end
end
