import AOC

aoc 2022, 7 do
  def parse(input), do: input |> String.split("\n", trim: true) |> parse(["/"], %{}) |> size(["/"], %{})

  def parse([], _path, tree), do: tree
  def parse([line | lines], path, tree) do
      if line == "$ ls" do
          {listing, lines} = Enum.split_while(lines, fn line -> !String.starts_with?(line, "$") end)
          {dirs, files} = listing |> Enum.split_with(&String.starts_with?(&1, "dir"))
          dirs = dirs |> Enum.map(fn dir -> dir |> String.split(" ", trim: true) |> List.last() end)
          tree = dirs |> Enum.reduce(tree, fn dir, tree -> put_in(tree, [dir | path] |> Enum.reverse(), %{}) end)
          tree = files
               |> Enum.map(&String.split(&1, " ", trim: true))
               |> Enum.reduce(tree, fn [size, name], tree -> put_in(tree, [name | path] |> Enum.reverse(), String.to_integer(size)) end)
          parse(lines, path, tree)
      else
          [_, _, dir] = String.split(line, " ", trim: true)
          case dir do
          ".." ->
              [_hd | tail] = path
              parse(lines, tail, tree)
          "/" ->
              parse(lines, [], tree)
          _ ->
              parse(lines, [dir | path], tree)
          end
      end
  end

  def size(tree, path, size_map) do
      {sizes, subtrees} = tree |> Enum.split_with(fn {_, v} -> is_integer(v) end)
      subtotal = sizes |> Enum.unzip() |> elem(1) |> Enum.sum()
      Enum.reduce(
          subtrees,
          {subtotal, size_map},
          fn {key, subtree}, {subtotal, size_map} ->
              path_new = [key | path]
              {subtree_size, size_map} = size(subtree, path_new, size_map)
              {subtotal + subtree_size, Map.put(size_map, Enum.join(path_new, "/"), subtree_size)}
          end)
  end

  def p1(input), do: input |> parse() |> elem(1) |> Map.values() |> Enum.filter(&(&1 <= 100_000)) |> Enum.sum
  def p2(input) do
      {total, sizes} = input |> parse()
      free_space = 70_000_000 - total
      needed = 30_000_000 - free_space
      sizes |> Map.values |> Enum.sort |> Enum.drop_while(&(&1 < needed)) |> List.first()
  end
end
