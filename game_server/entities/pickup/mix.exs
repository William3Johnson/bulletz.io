Code.require_file("../../module_paths.exs")

defmodule Pickup.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pickup,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Pickup.Supervisor, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:uuid,   "~> 1.1" },
      {:world, path: ModulePaths.world},
      {:player, path: ModulePaths.player},
      {:game_config, path: ModulePaths.config},
      {:collisions, path: ModulePaths.collisions},
      {:peek, path: ModulePaths.peek}
    ]
  end
end
