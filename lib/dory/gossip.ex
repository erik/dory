defmodule Dory.Gossip do
  use GenServer
  require Logger
  alias Dory.Memberlist
  alias Dory.Member

  # How long to wait between each gossip phase (in ms)
  @gossip_interval 1_000

  def start_link, do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_args) do
    Logger.info("Spreading rumors...")
    schedule_gossip()
    {:ok, []}
  end

  def handle_info(:gossip, state) do
    state = gossip_step(state)
    schedule_gossip()
    {:noreply, state}
  end

  defp gossip_step(state) do
    Logger.info("time to gossip!")
    members = Memberlist.random_members(5)

    # TODO: ping all members
    # TODO: send ping_reqs out for no-responses
    # TODO: gossip out suspects

    state
  end

  defp schedule_gossip() do
    Process.send_after(self(), :gossip, @gossip_interval)
  end

end
