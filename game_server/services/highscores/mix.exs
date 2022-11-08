defmodule Highscores.MixProject do
  use Mix.Project

  def project do
    [
      app: :highscores,
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
      {:google_api_firestore, "~> 0.8"},
      {:goth, "~> 1.2.0"}
    ]
  end
end
