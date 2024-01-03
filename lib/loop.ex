defmodule Loop do
  defstruct [:map, :start, :length]

  def compute(initial, f, hash) do
    initial
    |> Stream.iterate(f)
    |> Stream.with_index()
    |> Enum.reduce_while(
      {%{}, %{}},
      fn {state, i}, {map, hash_to_i} ->
        h = hash.(state)
        if Map.has_key?(hash_to_i, h) do
          start = hash_to_i[h]
          {:halt, %Loop{map: map, start: start, length: i-start}}
        else
          {:cont, {Map.put(map, i, state), Map.put(hash_to_i, h, i)}}
        end
      end
    )
  end

  def nth(%Loop{map: map, start: start, length: length}, n) do
    map[start + rem(n - start, length)]
  end
end
