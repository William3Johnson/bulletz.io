Code.require_file("../../module_paths.exs")

defmodule MovingFood.Mixfile do
  use Mix.Project

  def project do
    [
      app: :moving_food,
      version: "0.1.0",
      build_path: "_build",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MovingFood.Supervisor, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:uuid,   "~> 1.1" },
      {:world, path: ModulePaths.world},
      {:ticks,  path: ModulePaths.ticks},
      {:peek,  path: ModulePaths.peek},
      {:collisions,  path: ModulePaths.collisions},
      {:game_config, path: ModulePaths.config}
    ]
  end
end
