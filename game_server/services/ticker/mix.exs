Code.require_file("../../module_paths.exs")

defmodule Ticker.MixProject do
  use Mix.Project

  def project do
    [
      app: :ticker,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bucketizer, path: ModulePaths.bucketizer},
      {:game_config, path: ModulePaths.config},
      {:peek, path: ModulePaths.peek},
      {:player, path: ModulePaths.player},
      {:bullet, path: ModulePaths.bullet},
      {:moving_food, path: ModulePaths.moving_food},
      {:food, path: ModulePaths.food},
      {:food_bucketizer, path: ModulePaths.food_bucketizer},
      {:world, path: ModulePaths.world}
    ]
  end
end
