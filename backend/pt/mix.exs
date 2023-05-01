defmodule Pt.MixProject do
  use Mix.Project

  def project do
    [
      app: :pt,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [applications: applications(Mix.env())]

    [
      extra_applications: [:logger],
      mod: {Pt.Application, []}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger, :httpoison]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.2"},
      {:postgrex, "~> 0.15"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:recase, "~> 0.5"},
      {:remix, "~> 0.0.1", only: :dev},
      {:ex_machina, "~> 2.7.0"},
      {:absinthe, "~> 1.5"},
      {:absinthe_plug, "~> 1.5"},
      {:httpoison, "~> 2.0"},
      {:guardian, "~> 2.0"},
      {:timex, "~> 3.0"}
    ]
  end
end
