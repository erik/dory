defmodule Dory.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    Logger.info(IO.ANSI.green <> "Supervisor started" <> IO.ANSI.reset)

    children = [
      worker(Dory.Memberlist, []),
      worker(Dory.Gossip, []),
    ]

    opts = [strategy: :one_for_one, name: Dory.Supervisor]
    supervise(children, opts)
  end
end
