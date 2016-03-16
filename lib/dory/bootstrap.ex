defmodule Dory.Bootstrap do
  use GenServer
  require Logger
  alias Dory.Memberlist
  alias Dory.Member

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [
          :binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")
    loop_accept(socket)
  end

  defp loop_accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.start_link(fn -> handle_connection(client) end)
    loop_accept(socket)
  end

  defp handle_connection(socket) do
    Logger.info("got a client: #{inspect socket}, awaiting hello")

    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    Logger.info("got #{inspect data}")

    known_members = Memberlist.known_members()
    |> Enum.map(&Member.encode &1)
    |> Enum.join(",")

    :gen_tcp.send(socket, known_members <> "\n")
    Logger.info("yo")
  end
end
