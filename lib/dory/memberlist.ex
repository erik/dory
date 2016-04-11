defmodule Dory.Memberlist do
  use GenServer
  require Logger

  alias Dory.Member

  def start_link, do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  # Client API
  def join(member), do: GenServer.call(__MODULE__, {:join, member})
  def suspect(member), do: GenServer.call(__MODULE__, {:suspect, member})
  def confirm(member), do: GenServer.call(__MODULE__, {:confirm_down, member})
  def random_members(num), do: GenServer.call(__MODULE__, {:random_members, num})
  def known_members, do: GenServer.call(__MODULE__, :known_members)

  # GenServer API

  def init(_args) do
    Logger.info("HELLO, I AM ALIVE AND WELL.")
    {:ok, []}
  end

  def handle_call({:join, member}, _from, state) do
    Logger.info(IO.ANSI.green <> "JOIN #{inspect member}" <> IO.ANSI.reset)
    {:reply, member, state}
  end

  def handle_call({:random_members, num}, _from, state) do
    members = state |> Enum.take_random(num)
    {:reply, members, state}
  end

  def handle_call(:known_members, _from, state) do
    members = state ++ [Member.self] |> Enum.filter(&(&1.state == :up))

    {:reply, members, state}
  end

  # Backend

end
