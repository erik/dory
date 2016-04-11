defmodule Mix.Tasks.Node do
  use Mix.Task

  @shortdoc "Runs the given file or expression"

  def run(args) do
    {opts, head, _} = OptionParser.parse_head(args, switches: [
          join: :keep, listen: :string, advertise: :string
        ])

    Enum.each opts, fn
      {:join, value} ->
        IO.puts "#{inspect value} <<"
      {:listen, value} ->
        IO.puts "#{inspect value}"
      x ->
        IO.puts "#{inspect x}"
    end

    Dory.Config.start_link

    :application.ensure_all_started(:dory)
    :timer.sleep(:infinity)

    :ok
  end

end
