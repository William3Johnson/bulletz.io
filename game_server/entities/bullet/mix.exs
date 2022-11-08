Code.require_file("../../module_paths.exs")

defmodule Bullet.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bullet,
      version: "0.1.0",
      build_path: "_build",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Bullet.Supervisor, []}
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:uuid,   "~> 1.1" },
      {:world,  path: ModulePaths.world},
      {:ticks,  path: ModulePaths.ticks},
      {:move,   path: ModulePaths.move},
      {:collisions,  path: ModulePaths.collisions},
      {:game_config, path: ModulePaths.config}
    ]
  end

end
