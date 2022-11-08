Code.require_file("../../module_paths.exs")

defmodule Peek.Mixfile do
  use Mix.Project

  def project do
    [
      app: :peek,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_path: "_build",
      deps_path: "deps",
      lockfile: "mix.lock",
      start_permanent: Mix.env == :prod
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

end
