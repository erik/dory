defmodule Dory.Member do
  # State is one of :up, :suspect, :down
  defstruct [:host, :port, :name, :state]

  def ping(member, timeout \\ 30), do: false
  def ping_req(member, target, timeout \\ 30), do: false
  def ack(member, from, timeout \\ 30), do: false

  def self() do
    %__MODULE__{host: 'localhost', port: 1929, name: 'hi', state: :up}
  end

  def encode(member) do
    "#{member.host}: #{member.port} -> #{member.name}"
  end

end
