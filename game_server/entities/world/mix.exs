Code.require_file("../../module_paths.exs")

defmodule World.Mixfile do
  use Mix.Project

  def project do
    [
      app: :world,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_path: "_build",
      deps_path: "deps",
      lockfile: "mix.lock",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:ticks,  path: ModulePaths.ticks},
      {:game_config, path: ModulePaths.config},
      {:peek, path: ModulePaths.peek}
    ]
  end

end
