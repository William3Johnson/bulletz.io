Code.require_file("../../module_paths.exs")

defmodule Bot.MixProject do
  use Mix.Project

  def project do
    [
      app: :bot,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Bot, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:game_config, path: ModulePaths.config},
      {:player, path: ModulePaths.player},
      {:peek, path: ModulePaths.peek},
      {:collisions, path: ModulePaths.collisions},
      {:name_gen, path: ModulePaths.name_gen()}
    ]
  end
end
