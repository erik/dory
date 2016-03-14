defmodule Dory.Gossip do
  use GenServer
  require Logger

  alias Dory.Memberlist
  alias Dory.Member
  alias Dory.Message

  # How long to wait between each gossip phase (in ms)
  @gossip_interval 1_000

  def gossip(message) do
    # TODO: write me
  end

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

    [target | members] = Memberlist.random_members(5)

    # First try pinging our target, and if that times out, ask the remaining
    # members to also try pinging that target.
    #
    # If they all fail, gossip that target is down.
    unless Member.ping(target) do
      unreachable = members
      |> Enum.map &Member.ping_req(&1, target)
      |> Enum.any?

      if unreachable do
        gossip(%Message{:suspect, [target], [], 0})
      end
    end

    state
  end

  defp schedule_gossip() do
    Process.send_after(self(), :gossip, @gossip_interval)
  end

end
