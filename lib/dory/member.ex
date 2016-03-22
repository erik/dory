defmodule Dory.Member do
  require Poison

  # State is one of :up, :suspect, :down
  @derive {Poison.Encoder, except: []}
  defstruct [:host, :port, :name, :state]

  def ping(member, timeout \\ 30), do: false
  def ping_req(member, target, timeout \\ 30), do: false
  def ack(member, from, timeout \\ 30), do: false

  def self() do
    %__MODULE__{host: 'localhost', port: 9999, name: 'hi', state: :up}
  end
end
