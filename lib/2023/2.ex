import AOC
import String, only: [split: 2, to_integer: 1]
import Enum, only: [map: 2, max: 1, product: 1, reduce: 3, sum: 1, zip_with: 2]

aoc 2023, 2 do
  def parse_game(line) do
    ["Game " <> id, hands] = split(line, ": ")
    {to_integer(id), hands |> split("; ") |> map(&parse_hand/1)}
  end

  def parse_hand(hand) do
    hand |> split(", ") |> reduce([0,0,0], &parse_count/2)
  end

  def parse_count(count, [red, green, blue]) do
    case split(count, " ") do
      [n, "red"]   -> [to_integer(n), green, blue]
      [n, "green"] -> [red, to_integer(n), blue]
      [n, "blue"]  -> [red, green, to_integer(n)]
    end
  end

  def common(input, f) do
    input |> split("\n") |> map(&(&1 |> parse_game() |> f.())) |> sum()
  end

  def p1(input) do
    common(
      input,
      fn {id, games} ->
        [r, g, b] = zip_with(games, &max/1)
        if(r <= 12 and g <= 13 and b <= 14, do: id, else: 0)
      end)
  end

  def p2(input) do
    common(input, fn {_, hands} -> hands |> zip_with(&max/1) |> product() end)
  end
end
