defmodule Dory.Memberlist do
  use GenServer
  require Logger

  def start_link, do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  # Client API
  def join(member), do: GenServer.call(__MODULE__, {:join, member})
  def suspect(member), do: GenServer.call(__MODULE__, {:suspect, member})
  def confirm(member), do: GenServer.call(__MODULE__, {:confirm_down, member})
  def random_members(num), do: GenServer.call(__MODULE__, {:random_members, num})

  # GenServer API

  def init(_args) do
    Logger.info("HELLO, I AM ALIVE AND WELL.")
    {:ok, []}
  end

  def handle_call({:random_members, num}, _from, state) do
    members = state |> Enum.take_random(num)
    {:reply, members, state}
  end

  # Backend

end
