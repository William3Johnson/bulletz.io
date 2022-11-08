Code.require_file("../../module_paths.exs")

defmodule Powerups.Mixfile do
  use Mix.Project

  def project do
    [
      app: :powerups,
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
      mod: {Powerups, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:pickup, path: ModulePaths.pickup},
      {:player, path: ModulePaths.player},
      {:game_config, path: ModulePaths.config},
      {:powerup, path: ModulePaths.powerup}
    ]
  end
end
