defmodule Dory.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    Logger.info(IO.ANSI.green <> "Supervisor started" <> IO.ANSI.reset)

    Logger.info("seeding")
    seed_members()

    children = [
      worker(Dory.Memberlist, []),
      worker(Dory.Gossip, []),
      worker(Task, [Dory.Bootstrap, :accept, [19208]])
    ]

    opts = [strategy: :one_for_one, name: Dory.Supervisor]
    supervise(children, opts)
  end

  def seed_members do
    {:ok, client} = :gen_tcp.connect('localhost', 19209,
                                     [:binary, packet: :line, active: false])
    :ok = :gen_tcp.send(client, "HELLO!\n")

    Logger.info("#{inspect client}")

    {:ok, resp} = :gen_tcp.recv(client, 0, 1000)

    Logger.info("response is alive #{inspect resp}")

    :ok = :gen_tcp.close(client)
  end
end
