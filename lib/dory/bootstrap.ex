defmodule Dory.Bootstrap do
  use GenServer
  require Logger
  require Poison
  alias Dory.Memberlist
  alias Dory.Member

  def accept(port) do
    Logger.info("Bootstrap accepting connections on port #{port}")
    {:ok, socket} = :gen_tcp.listen(port, [
          :binary, packet: :line, active: false, reuseaddr: true])

    loop_accept(socket)
  end

  defp loop_accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.start_link(fn -> handle_connection(client) end)
    loop_accept(socket)
  end

  defp handle_connection(socket) do
    Logger.info("got a client: #{inspect socket}")

    known_members = Memberlist.known_members()
    |> Poison.encode!(as: [%Member{}])

    :gen_tcp.send(socket, known_members <> "\n")
    Logger.info("sent messages")
  end
end
