defmodule CloudfrontSigner.MixProject do
  use Mix.Project

  @source_url "https://github.com/podium/cloudfront-signer"
  @version "0.2.0"

  def project do
    [
      app: :cloudfront_signer,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      source_url: @source_url,
      deps: deps(),
      docs: docs(),
      dialyzer: [
        ignore_warnings: ".dialyzer.ignore-warnings",
        list_unused_filters: true,
        plt_add_apps: [:mix],
        plt_file: {:no_warn, "priv/plts/project.plt"},
        plt_core_path: "priv/plts/core.plt"
      ],
      package: package(),
      description: "Signs URLs for CloudFront distributions"
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
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.36", only: [:dev], runtime: false},
      {:jason, "~> 1.4"},
      {:timex, "~> 3.7"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        {:"README.md", title: "Readme"},
        "CHANGELOG.md"
      ],
      source_url: @source_url,
      source_ref: "v#{@version}",
      homepage_url: @source_url
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Podium"],
      links: %{
        "GitHub" => @source_url,
        "Docs" => "https://hexdocs.pm/cloudfront_signer/#{@version}/",
        "Changelog" => "#{@source_url}/blob/master/CHANGELOG.md"
      }
    ]
  end
end
