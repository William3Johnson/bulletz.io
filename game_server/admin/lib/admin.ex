defmodule Admin do
  def apply_for_player(name, func) do
    pid = Peek.peek(SocketServer.Connector.world) |>
      Map.get(:players) |>
      Enum.map(&Peek.peek/1) |>
      Enum.filter(fn p -> p.name == name end) |>
      List.first |>
      Map.get(:pid)
    Player.effect(pid, func)
  end
end
