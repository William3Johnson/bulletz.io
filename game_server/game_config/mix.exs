Code.require_file("../module_paths.exs")

defmodule GameConfig.Mixfile do
  use Mix.Project

  def project do
    [
      app: :game_config,
      version: "0.1.0",
      build_path: "_build",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GameConfig, []}
    ]
  end

  defp deps do
    [
      {:powerup, path: ModulePaths.powerup()},
    ]
  end
end
