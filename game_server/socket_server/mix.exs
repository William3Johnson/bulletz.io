Code.require_file("../module_paths.exs")
defmodule BulletzSocket.MixProject do
  use Mix.Project

  def project do
    [
      app: :socket_server,
      version: "0.1.8",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      config_path: "../game_config/config/config.exs",
      releases: [
        socket_server: [
            include_executables_for: [:unix]
          ]
        ]
    ]
  end



  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {SocketServer.Application, []},
      extra_applications: [:logger, :runtime_tools, :bullet, :world, :player, :scoreboard, :color_gen, :game_config, :food, :moving_food]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:phoenix, "~> 1.5.9"},
        {:phoenix_html, "~> 2.13.3"},
        {:phoenix_pubsub, "~> 2.0.0"},
        {:phoenix_live_reload, "~> 1.2.1", only: :dev},
        {:gettext, "~> 0.11"},
        {:cowboy, "~> 2.7"},
        {:plug, "~> 1.10"},
        {:plug_cowboy, "~> 2.2.0"},
        {:plug_crypto, "~> 1.2"},
        {:cors_plug, "~> 1.5"},
        {:poison, "~> 3.1.0"},

        {:game_config, path: ModulePaths.config()},

        {:admin, path: ModulePaths.admin()},
        {:bullet, path: ModulePaths.bullet()},
        {:bot, path: ModulePaths.bot()},
        {:food, path: ModulePaths.food()},
        {:food_bucketizer, path: ModulePaths.food_bucketizer()},
        {:moving_food, path: ModulePaths.moving_food()},
        {:player, path: ModulePaths.player()},
        {:world, path: ModulePaths.world()},
        {:highscores, path: ModulePaths.highscores()},
        {:powerups, path: ModulePaths.powerups()},
        {:powerup, path: ModulePaths.powerup()},
        {:color_gen, path: ModulePaths.color_gen()},
        {:scoreboard, path: ModulePaths.scoreboard()},
        {:collisions, path: ModulePaths.collisions()},
        {:name_gen, path: ModulePaths.name_gen()},
        {:move, path: ModulePaths.move()},
        {:peek, path: ModulePaths.peek()},
        {:ticks, path: ModulePaths.ticks()},
        {:ticker, path: ModulePaths.ticker()},
    ]
  end
end
