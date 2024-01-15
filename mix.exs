defmodule CloudfrontSigner.MixProject do
  use Mix.Project

  def project do
    [
      app: :cloudfront_signer,
      version: "0.2.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {CloudfrontSigner.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:timex, "~> 3.7"}
    ]
  end
end
