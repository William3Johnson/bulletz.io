defmodule Highscores.Server do
  use GenServer

  def init(args) do
    Process.send_after(self(), :boot, 0)
    {:ok, args}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_info(:boot, _state) do
    if Application.get_env(:highscores, :enabled, false) do
      {:noreply, Highscores.Firestore.load_scores(Highscores.Auth.conn(), Application.get_env(:highscores, :server_name))}
    else
      {:noreply, []}
    end
  end

  def handle_info(:sync_scores, state) do
    if Application.get_env(:highscores, :enabled, false) do
      :ok = Highscores.Firestore.sync_scores(Highscores.Auth.conn(), Application.get_env(:highscores, :server_name), state)
    end
    {:noreply, state}
  end

  def handle_cast({:score, player}, state) do
    {needs_change, new_state} = Highscores.Impl.update_scores(state, player)
    if needs_change do
      send self(), :sync_scores
    end
    {:noreply, new_state}
  end
end
