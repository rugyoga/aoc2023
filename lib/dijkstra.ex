defmodule Dijkstra do
  # def search(heap, success?, graph, seen, candidates) do
  #   {cheapest, heap} = Heap.pop(heap)
  #   if cheapest == :empty do
  #     :error
  #   else
  #     {cost, item} = cheapest

  #     cond do
  #       success?.(cheapest) -> cheapest
  #       MapSet.member?(seen, item) -> search(heap, success?, graph, seen, candidates)
  #       true ->
  #         item
  #         |> then(fn item -> candidates(graph, seen, item) end)
  #         |> Enum.reduce(heap, fn item, heap -> Heap.push(heap, {cost(item)+cost, item}) end)
  #         |> search(success?, graph, MapSet.put(seen, item), candidates)
  #     end
  #   else
  #   end
  # end
end
