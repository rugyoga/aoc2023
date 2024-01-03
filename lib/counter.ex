defmodule Counter do
  def start_link(initial) do
    Agent.start_link(fn -> initial end, name: __MODULE__)
  end

  def increment() do
    Agent.get_and_update(__MODULE__, fn state -> {state, state + 1} end)
  end
end
