# Lamport clock

defmodule Dory.Clock do
  def start_link, do: Agent.start_link(fn -> 0 end, name: __MODULE__)
  def get, do: Agent.get(__MODULE__, fn clock -> clock end)
  def increment, do: Agent.update(__MODULE__, fn clock -> clock + 1 end)
  def witness(other) do
    Agent.update(__MODULE__, fn clock -> Kernel.max(clock, other) end)
  end
end
