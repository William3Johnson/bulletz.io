defprotocol Ticks do
  @fallback_to_any true
  def elapsed_ticks(state)
end

defimpl Ticks, for: Any do

  def elapsed_ticks(state = %{timestamp: timestamp}) do
    interval = GameConfig.get(:world, :interval)
    current_time = :erlang.system_time(:milli_seconds)
    ticks = (current_time - timestamp) / interval
    {ticks, Map.put(state, :timestamp, current_time)}
  end

end
