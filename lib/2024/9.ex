import AOC

aoc 2024, 9 do
  def p1(input) do
     rle = common(input)
     total_runs = rle |> Enum.filter(&is_tuple/1) |> Enum.map(&elem(&1, 1)) |> Enum.sum
     fill_gaps(rle, Enum.reverse(rle), total_runs) |> take(total_runs) |> checksum(0) |> Enum.sum()
  end

  def p2(input) do
    {gaps, blocks} = input |> common() |> enumerate_gaps([], [], 0)
    fill_blocks(Enum.reverse(gaps), blocks) |> checksum_blocks()
  end

  def fill_gaps([], _, _), do: []
  def fill_gaps(_, _, runs) when runs <= 0, do: []
  def fill_gaps([{x, n} | rle], elr, runs), do: [{x, n} | fill_gaps(rle, elr, runs-n)]
  def fill_gaps([gap | rle], [{y, m} | elr], runs) do
    gap = min(gap, runs)
    cond do
      gap == 0 -> fill_gaps(rle, [{y, m} | elr], runs)
      gap  > m -> [{y, m} | fill_gaps([gap - m | rle], elr, runs-m)]
      gap == m -> [{y, m} | fill_gaps(rle, elr, runs-m)]
      true     -> [{y, gap} | fill_gaps(rle, [{y, m - gap} | elr], runs - gap)]
    end
  end
  def fill_gaps(rle, [_gap | elr], runs), do: fill_gaps(rle, elr, runs)

  def checksum([], _), do: []
  def checksum([{id, 1} | ids], n), do: [n * id | checksum(ids, n+1)]
  def checksum([{id, k} | ids], n), do: [n * id | checksum([{id, k-1} | ids], n+1)]

  def take(_, 0), do: []
  def take([{id, m} | rest], n), do: if(m < n, do: [{id, m} | take(rest, n-m)], else: [{id, n}])

  def common(input) do
    input
    |> String.trim_trailing()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> annotate(0)
  end

  def annotate([], _), do: []
  def annotate([x|xs], id) when id >= 0, do: [{id, x} | annotate(xs, -id-1)]
  def annotate([x|xs], id), do: [x | annotate(xs, -id)]

  def enumerate_gaps([], gaps, blocks, _), do: {gaps, blocks}
  def enumerate_gaps([{_, k} = block| rle], gaps, blocks, i), do: enumerate_gaps(rle, gaps, [{i, block} | blocks], i+k)
  def enumerate_gaps([0 | rle], gaps, blocks, i), do: enumerate_gaps(rle, gaps, blocks, i)
  def enumerate_gaps([gap | rle], gaps, blocks, i), do: enumerate_gaps(rle, [{gap, i} | gaps], blocks, i+gap)

  def checksum_blocks([]), do: 0
  def checksum_blocks([{i, {id, 1}} | blocks]), do: i * id + checksum_blocks(blocks)
  def checksum_blocks([{i, {id, k}} | blocks]), do: i * id + checksum_blocks([{i+1, {id, k-1}} | blocks])

  def fill_blocks(_, []), do: []
  def fill_blocks(gaps, [{i, {id, k}} = block| blocks]) do
    candidate_i = Enum.find_index(gaps, fn {gap, j} -> gap >=k and j < i end)
    if candidate_i do
      {gap, new_i} = Enum.at(gaps, candidate_i)
      new_gaps = if gap == k do
        List.delete_at(gaps, candidate_i)
      else
        List.replace_at(gaps, candidate_i, {gap-k, new_i+k})
      end
      [{new_i, {id, k}} | fill_blocks(new_gaps, blocks)]
    else
      [block | fill_blocks(gaps, blocks)]
    end
  end
end
