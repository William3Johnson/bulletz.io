Code.require_file("../../module_paths.exs")

defmodule Player.Mixfile do
  use Mix.Project

  def project do
    [
      app: :player,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Player.Supervisor, []}
    ]
  end

  defp deps do
    [
      {:uuid,   "~> 1.1" },
      {:poison, "~> 3.1"},
      {:world,  path: ModulePaths.world},
      {:bullet,  path: ModulePaths.bullet},
      {:food,  path: ModulePaths.food},
      {:ticks,  path: ModulePaths.ticks},
      {:move,  path: ModulePaths.move},
      {:peek, path: ModulePaths.peek},
      {:collisions,  path: ModulePaths.collisions},
      {:game_config, path: ModulePaths.config},
      {:color_gen,  path: ModulePaths.color_gen},
      {:food_bucketizer, path: ModulePaths.food_bucketizer}
    ]
  end

end
