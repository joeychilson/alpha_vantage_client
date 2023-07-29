defmodule AlphaVantage.MixProject do
  use Mix.Project

  @version "0.1.0"
  @description "An Elixir-based HTTP Client for the Alpha Vantage API."

  def project do
    [
      app: :alpha_vantage_client,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      description: @description,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      mod: {AlphaVantage, []},
      extra_applications: [:logger, :req, :jason, :simple_rate_limiter]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.3.11"},
      {:simple_rate_limiter, "~> 1.0"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joeychilson/alpha_vantage_client"},
      maintainers: ["Joey Chilson"]
    ]
  end
end
