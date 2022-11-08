defmodule Powerup.Ghost do

    @diff 0.01

    def ghost(player) do
      player |>
        Player.restore_state |>
        Map.put(:sprite, "ghost.png") |>
        Map.put(:extra_callbacks, [&update_opacity/2]) |>
        Map.put(:extra_data, :decreasing) |>
        Map.put(:stall_opacity, 0) |>
        Map.put(:opacity_dx, @diff)
    end

    defp update_opacity(player = %{stall_opacity: stall_opacity}, ticks) when stall_opacity > 0 do
      Map.put(player, :stall_opacity, stall_opacity-ticks)
    end
    defp update_opacity(player = %{extra_data: :decreasing, opacity: opacity}, ticks) when opacity - ticks*@diff <= 0 do
      Map.put(player, :opacity, 0.0) |>
        Map.put(:opacity_dx, @diff) |>
        Map.put(:stall_opacity, GameConfig.get(:ghost, :stall_invisible)) |>
        Map.put(:extra_data, :increasing)
    end
    defp update_opacity(player = %{extra_data: :increasing, opacity: opacity}, ticks) when opacity + ticks*@diff >= 1.0 do
      Map.put(player, :opacity, 1.0) |>
        Map.put(:opacity_dx, -@diff) |>
        Map.put(:stall_opacity, GameConfig.get(:ghost, :stall_visible)) |>
        Map.put(:extra_data, :decreasing)
    end

    defp update_opacity(player = %{extra_data: :decreasing, opacity: opacity}, ticks) do
      new_opacity = opacity-@diff*ticks
      Map.put(player, :opacity, new_opacity) |>
        Map.put(:invincible, new_opacity < 0.25)
    end
    defp update_opacity(player = %{extra_data: :increasing, opacity: opacity}, ticks) do
      new_opacity = opacity+@diff*ticks
      Map.put(player, :opacity, new_opacity) |>
        Map.put(:invincible, new_opacity < 0.25)
    end
end
