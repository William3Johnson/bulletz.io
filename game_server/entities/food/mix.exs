Code.require_file("../../module_paths.exs")

defmodule Food.Mixfile do
  use Mix.Project

  def project do
    [
      app: :food,
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
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:uuid,   "~> 1.1" },
      {:game_config, path: ModulePaths.config},
      {:world, path: ModulePaths.world},
      {:color_gen, path: ModulePaths.color_gen},
      {:food_bucketizer, path: ModulePaths.food_bucketizer},
    ]
  end
end
