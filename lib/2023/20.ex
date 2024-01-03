import AOC

aoc 2023, 20 do

  defmodule Device do
    defstruct [:type, :outputs, :state]

    def hi, do: true
    def lo, do: false

    def parse(line) do
      [device_str, outputs_str] = String.split(line, " -> ")
      {name, type, state} = parse_name(device_str)
      outputs = String.split(outputs_str, ", ")
      {name, %Device{type: type, outputs: outputs, state: state}}
    end

    def parse_name("broadcaster"), do: {"broadcaster", :broadcaster, nil}
    def parse_name(<<"%" <>  name>>), do: {name, :flipflop, false}
    def parse_name(<<"&" <> name>>), do: {name, :conjunction, %{}}

    def action(device, {_, "rx", _}), do: {device, [], lo()}
    def action(%Device{type: :broadcaster} = device, {_, _, signal}), do: {device, device.outputs, signal}
    def action(%Device{type: :flipflop} = device, {_, _, true}), do: {device, [], lo()}
    def action(%Device{type: :flipflop} = device, {_, _, false}) do
      state = not device.state
      {%Device{device | state: state}, device.outputs, state}
    end
    def action(%Device{type: :conjunction} = device, {from, _, signal}) do
      state = Map.put(device.state, from, signal)
      output = state |> Map.values() |> Enum.all?()
      {%Device{device | state: state}, device.outputs, not output}
    end
  end

  defmodule Machine do
    defstruct devices: %{}, queue: Queue.new(), counts: %{false: 0, true: 0}, messages: []

    def send_inputs(queue, from, inputs, signal) do
      Enum.reduce(inputs, queue, &Queue.add_back(&2, {from, &1, signal}))
    end

    def simulate(machine) do
      if Queue.empty?(machine.queue) do
        machine
      else
        {{_, to, in_signal} = message, queue} = Queue.pop_front(machine.queue)
        {device, outputs, out_signal} = Device.action(machine.devices[to], message)
        %Machine{ machine |
          devices: Map.put(machine.devices, to, device),
          queue: send_inputs(queue, to, outputs, out_signal),
          messages: [message | machine.messages],
          counts: Map.update!(machine.counts, in_signal, &(&1 + 1))
        }
        |> simulate()
      end
    end

    def reset(machine) do
      %Machine{machine | queue: Queue.new() |> Queue.add_back({"button", "broadcaster", Device.lo()})}
    end
  end

  def devices(input) do
    input
    |> String.split("\n")
    |> Enum.map(&Device.parse/1)
    |> Map.new
  end

  def conjunctions(devices) do
    devices
    |> Enum.flat_map(fn {name, device} -> if(device.type == :conjunction, do: [name], else: []) end)
    |> MapSet.new()
  end

  def wire_up_conjunction(conjunctions) do
    fn {name, device}, map ->
      device.outputs
      |> Enum.filter(&MapSet.member?(conjunctions, &1))
      |> Enum.reduce(map, fn output, map -> put_in(map[output].state[name], Device.lo()) end)
    end
  end

  def wire_up_conjunctions(devices, conjunctions) do
    Enum.reduce(devices, devices, wire_up_conjunction(conjunctions))
  end

  def machine(input) do
    devices = input |> devices()
    %Machine{devices: wire_up_conjunctions(devices, conjunctions(devices))}
  end

  def p1(input) do
    input
    |> machine()
    |> Stream.iterate(fn m -> m |> Machine.reset() |> Machine.simulate() end)
    |> Enum.at(1000)
    |> then(fn m -> m.counts[true] * m.counts[false] end)
  end

  def source(target, machine) do
    machine.devices |> Enum.flat_map(fn {name, device} -> if target in device.outputs, do: [name], else: [] end)
  end

  def p2(input) do
    machine = input |> machine()

    targets = "rx" |> source(machine) |> hd() |> source(machine) |> MapSet.new
    only_targets = fn m -> Enum.filter(m.messages, fn {target, _, s} -> s and target in targets end) end

    machine
    |> Stream.iterate(& &1 |> Machine.reset() |> Machine.simulate())
    |> Stream.map(only_targets)
    |> Stream.with_index()
    |> Enum.reduce_while(
      %{},
      fn {items, cycle}, cycles ->
        if Enum.count(cycles) == 4 do
          {:halt, cycles |> Map.values() |> Enum.reduce(&Math.lcm/2)}
        else
          {:cont, Enum.reduce(items, cycles, fn {from, _, _}, cycles -> Map.put_new(cycles, from, cycle) end)}
        end
      end)
  end
end
