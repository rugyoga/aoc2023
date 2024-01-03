defmodule Memo do
  use Agent

  def start_link(name \\ __MODULE__) do
    Agent.start_link(fn -> %{} end, name: name)
  end

  def get(key) do
    Agent.get(__MODULE__, fn memo -> memo[key] end)
  end

  def set(key, value) do
    Agent.update(__MODULE__, fn memo -> Map.put(memo, key, value) end)
  end

  def ised(f, args) do
    value = get(args)
    if is_nil(value) do
      value = apply(f, args)
      set(args, value)
      value
    else
      value
    end
  end
end
