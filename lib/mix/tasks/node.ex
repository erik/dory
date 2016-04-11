defmodule Mix.Tasks.Node do
  use Mix.Task

  @shortdoc "Runs the given file or expression"

  def run(args) do
    Dory.Config.start_link
    Dory.Config.parse_argv(args)

    :application.ensure_all_started(:dory)
    :timer.sleep(:infinity)

    :ok
  end

end
