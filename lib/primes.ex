defmodule Primes do

  @doc """
  Generates a stream of primes.

    iex> Primes.primes() |> Enum.take(5)
    [2, 3, 5, 7, 11]

    iex> Primes.primes() |> Enum.at(25)
    101
  """

  @spec primes() :: Stream.t
  def primes() do
    final = fn primes -> {:cont, primes} end
    step = fn number, primes ->
      sqr_root = :math.sqrt(number) |> trunc()
      if 2..sqr_root |> Stream.filter(&(MapSet.member?(primes, &1))) |> Enum.any?(&(rem(number, &1) == 0)) do
        {:cont, primes}
      else
        {:cont, number, MapSet.put(primes, number)}
      end
    end

    Stream.iterate(2, &(&1 + 1)) |> Stream.chunk_while(MapSet.new, step, final)
  end
end
