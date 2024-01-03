import AOC

aoc 2022, 15 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({[], MapSet.new}, &extract/2)
    |> then(fn {sensors, beacon_set} -> %{sensors: sensors, beacons: beacons_on_y(beacon_set)} end)
end

def distance({ax, ay}, {bx, by}), do: abs(ax - bx) + abs(ay - by)

def extract(line, {sensors, beacons}) do
    data = Regex.named_captures(~r/Sensor at x=(?<s_x>-?\d+), y=(?<s_y>-?\d+): closest beacon is at x=(?<b_x>-?\d+), y=(?<b_y>-?\d+)/, line)
    grab = &(data[&1] |> String.to_integer())
    sensor = {grab.("s_x"), grab.("s_y")}
    beacon = {grab.("b_x"), grab.("b_y")}
    {[%{sensor: sensor, range: distance(sensor, beacon)} | sensors],
     MapSet.put(beacons, beacon)}
end

def beacons_on_y_axis(beacons, y_target) do
    beacons
    |> Enum.flat_map(fn %{beacon: {x, y}} -> if(y == y_target, do: [x], else: []) end)
    |> Enum.uniq()
    |> Enum.count()
end

def ranges_by_y(sensors, y_target) do
    Enum.flat_map(
        sensors,
        fn %{sensor: {x, y}, range: distance} ->
            y_distance = abs(y - y_target)
            x_distance = distance - y_distance
            if(y_distance <= distance, do: [x-x_distance..x+x_distance], else: [])
        end)
    |> Enum.sort()
    |> merge_ranges()
end

def merge_ranges([]), do: []
def merge_ranges([a]), do: [a]
def merge_ranges([a | [b | rest]]) do
    if Range.disjoint?(a, b) do
        [a | merge_ranges([b | rest])]
    else
        a_min..a_max = a
        b_min..b_max = b
        merge_ranges([Enum.min([a_min, b_min])..Enum.max([a_max, b_max]) | rest])
    end
end

def gaps(data, y) do
    data
    |> ranges_by_y(y)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [_..a_max, b_min.._] -> a_max+1..b_min-1 end)
end

def get_x({x, _}), do: x
def get_y({_, y}), do: y

def one_gap?({[r], _}), do: Range.size(r) == 1
def one_gap?(_), do: false

def beacons_on_y(beacons) do
    beacons
    |> Enum.group_by(&get_y/1)
    |> Enum.map(fn {y, on_y} -> {y, on_y |> Enum.map(&get_x/1) |> Enum.sort()} end)
    |> Map.new
end

def in_range(range, items), do: Enum.count(items, &Enum.member?(range, &1))

def coverage(data, y) do
    data.sensors
    |> ranges_by_y(y)
    |> Enum.map(&Range.size/1)
    |> Enum.sum
    |> then(fn n -> n - Enum.count(Map.get(data.beacons, y, [])) end)
end

def tuning({x, y}), do: x * 4_000_000 + y

def p1(input) do
    input |> parse() |> coverage(2_000_000)
end

def p2(input) do
    data = parse(input)

    0..4_000_000
    |> Enum.map(&{gaps(data.sensors, &1), &1})
    |> Enum.filter(&one_gap?/1)
    |> Enum.map(fn {[x..x], y} -> tuning({x, y}) end)
    |> hd
end
end
