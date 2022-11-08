Code.require_file("../../module_paths.exs")

defmodule Ticks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ticks,
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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:game_config, path: ModulePaths.config}
    ]
  end
end
