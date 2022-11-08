Code.require_file("../../module_paths.exs")

defmodule Scoreboard.Mixfile do
  use Mix.Project

  def project do
    [
      app: :scoreboard,
      version: "0.1.0",
      elixir: "~> 1.6",
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
      {:phoenix_html, "~> 2.10"},
      {:game_config, path: ModulePaths.config},
      {:peek, path: ModulePaths.peek},
    ]
  end
end
