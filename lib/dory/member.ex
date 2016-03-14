defmodule Dory.Member do
  defstruct [:socket, :name, :state]

  def ping(member, timeout \\ 30), do: false
  def ping_req(member, target, timeout \\ 30), do: false
  def ack(member, from, timeout \\ 30), do: false
end
