defmodule GameConfig do

  @bullet %{
    speed: 12,
    global_damage_mod: 1,
    parent_radius_ratio: 5,
    lifetime: 400,
    slowdown_duration: 500
  }

  @player %{
    acceleration: 0.5,
    radius: 10,
    min_radius: 10,
    reload: 75,
    afk_timer: 7500,
    max_age: 200,
    friction: 0.1,
    death_mark_timer: 100,
    food_falloff_size: 115,
    player_linear_cap: 700
  }

  @world %{
        max_players: 40,
        width:  500,
        height: 500,
        interval: 16,
        real_tick_rate: 50,
        area_per_player: 6500*6500,
        dx: 3,
        background: "#000000AA",
        background_boundary: "#FFFFFF",
        grid_color: "#FFFFFF55",
        background_image: nil
  }

  @food %{
    food_value_mod: 0.35,
    radius_range: 5..20,
    base_food: 10,
    area_per_food: 400*400,
    lifetime: 8000
  }

  @moving_food %{
    speed: 2,
    value_mod: 0.85,
    size_mod: 2.5,
    player_death_ratio: 0.5,
    slowdown_duration: 100,
    lifetime: 1500
  }

  @pickup %{
    radius: 75
  }

  @bot %{minimum_bots: 5, max_bots: 8}

  @scoreboard %{ size: 5 }

  @frost %{
    max_frost: 0.5,
    thaw_rate: 0.001
  }

  @ghost %{
    stall_visible: 500, stall_invisible: 250
  }

  def start(_opts, _args) do
    :ok = config(:bullet, @bullet)
    :ok = config(:player, @player)
    :ok = config(:world, @world)
    :ok = config(:food, @food)
    :ok = config(:moving_food, @moving_food)
    :ok = config(:pickup, @pickup)

    powers = apply(GameConfig.Powerups, Application.get_env(:powerups, :powers) || :default_powerups, [])
    Application.put_env(:powerups, :powers, powers)

    :ok = config(:powerups, Map.put(GameConfig.Powerups.defaults, :powers, powers))
    :ok = config(:color_gen, GameConfig.ColorGen.defaults)
    :ok = config(:bot, @bot)

    :ok = config(:scoreboard, @scoreboard)
    :ok = config(:frost, @frost)
    :ok = config(:ghost, @ghost)

    Agent.start(fn -> nil end)
  end

  defp config(module, defaults) do
    craft_config(module, defaults) |>
      put_config(module)
  end

  defp craft_config(module, defs) do
    Application.get_all_env(module)
      |>  Enum.reduce(defs, fn {key, val}, acc ->
        Map.put(acc, key, val)
      end)
  end

  defp put_config(config, module) do
    :persistent_term.put(module, config)
  end

  def get(mod_name) do
    :persistent_term.get(mod_name)
  end

  def get(mod_name, attribute) do
    :persistent_term.get(mod_name) |>
      Map.get(attribute)
  end

end
