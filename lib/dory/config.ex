defmodule Dory.Config do
  @agent __MODULE__

  def start_link do
    Agent.start_link(@agent, :init_state, [], [name: @agent])
  end

  def init_state do
    %{
      bind_addr: {127, 0, 0, 1},
      bind_port: 9863,
      advertise_addr: {127, 0, 0, 1},
      advertise_port: 9863,
      probe_interval: 500,
      probe_timeout: 500,
      gossip_interval: 250,
      join_nodes: []
    }
  end

  def parse_argv(args) do
    {opts, head, _} = OptionParser.parse_head(args, switches: [
          join: :keep, listen: :string, advertise: :string
        ])

    Enum.each opts, fn
      {:join, value} ->
        IO.puts "JOINING #{inspect value} <<"
        case String.split(value, ":") do
          [host, port_str] ->
            port = String.to_integer(port_str)
            Agent.update(@agent, &Map.put(&1, :join_nodes,
                                          &1[:join_nodes] ++ [{host, port}]))
          _ -> raise ArgumentError, message: "Invalid host:port #{inspect value}"
        end

      {:listen, value} ->
        IO.puts "LISTEN ON PORT #{inspect value} >>"
        port = String.to_integer(value)
        Agent.update(@agent, &Map.put(&1, :bind_port, port))
      x ->
        IO.puts "#{inspect x}"
    end

    IO.puts "the state: #{inspect Agent.get(@agent, fn x -> x end)}"
  end

  def get do
    Agent.get(@agent, fn cfg -> cfg end)
  end

  def get(val) do
    Agent.get(@agent, &Map.get(&1, val))
  end

end
