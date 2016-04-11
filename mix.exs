defmodule Dory.Mixfile do
  use Mix.Project

  def project do
    [app: :dory,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
     mod: {Dory, []}]
  end

  defp deps do
    [{:poison, "~> 2.0"},
     {:socket, "~> 0.3.1"}]
  end
end
