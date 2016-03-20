defmodule Dory.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    Logger.info(IO.ANSI.green <> "Supervisor started" <> IO.ANSI.reset)

    case {System.get_env("SEED_HOST"), System.get_env("SEED_PORT")} do
      {host, port_str} when not is_nil(host) and not is_nil(port_str)->
          {port, ""} = port_str |> Integer.parse
          seed_members(host, port)
      _ -> nil
    end

    bootstrap =
      case System.get_env("BOOTSTRAP_PORT") do
        nil -> []
        port_str ->
          {port, ""} = port_str |> Integer.parse
          [worker(Task, [Dory.Bootstrap, :accept, [port]])]
      end

    children = [
      worker(Dory.Memberlist, []),
      worker(Dory.Gossip, []),
    ] ++ bootstrap

    opts = [strategy: :one_for_one, name: Dory.Supervisor]
    supervise(children, opts)
  end

  def seed_members(host, port) do
    Logger.info(IO.ANSI.yellow <> "Seeding from #{inspect host}:#{port}" <> IO.ANSI.reset)

    {:ok, client} = :gen_tcp.connect(host |> String.to_char_list , port, [
          :binary, packet: :line, active: false])

    :ok = :gen_tcp.send(client, "HELLO!\n")
    Logger.info("hereererer e #{inspect client}")

    {:ok, resp} = :gen_tcp.recv(client, 0, 1000)

    Logger.info("response is alive #{inspect resp}")
    :ok = :gen_tcp.close(client)
  end
end
