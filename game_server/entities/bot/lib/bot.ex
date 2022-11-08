defmodule Bot do
  defdelegate new(callback), to: Bot.Supervisor

  def start(_opt, _args) do
    Bot.Supervisor.start_link() 
  end
end
