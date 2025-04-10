defmodule AshBilling.MixProject do
  use Mix.Project

  @description """
  Billing extension for the Ash Framework.
  """

  @version "0.0.0"

  def project do
    [
      app: :ash_billing,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        plt_core_path: "priv/plts",
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      description: @description,
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      docs: &docs/0,
      aliases: aliases(),
      preferred_cli_env: [ci: :test]
    ]
  end

  def package do
    [
      maintainers: [
        "Chaz Watkins <chazwatkins@hey.com>"
      ],
      licenses: ["MIT"],
      links: %{
        "Source" => "https://github.com/chazwatkins/ash_billing"
      },
      source_url: "https://github.com/chazwatkins/ash_billing",
      files: ~w[lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*]
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      extras: [
        {"README.md", name: "Home"},
        "CHANGELOG.md"
      ],
      skip_undefined_reference_warnings_on: [
        "CHANGELOG.md"
      ],
      filter_modules: fn mod, _ ->
        String.starts_with?(inspect(mod), "AshBilling") ||
          String.starts_with?(inspect(mod), "Mix.Task")
      end,
      source_url_pattern: "https://github.com/chazwatkins/ash_billing/blob/main/%{path}#L%{line}"
    ]
  end

  defp aliases do
    extensions = [
      "AshBilling"
    ]

    [
      ci: [
        "format --check-formatted",
        "doctor --full --raise",
        "credo --strict",
        "dialyzer",
        "hex.audit",
        "test"
      ],
      "spark.formatter": "spark.formatter --extensions #{Enum.join(extensions, ",")}",
      "spark.cheat_sheets": "spark.cheat_sheets --extensions #{Enum.join(extensions, ",")}",
      docs: [
        "spark.cheat_sheets",
        "docs",
        "spark.replace_doc_links"
      ],
      credo: ["credo --strict"]
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
      {:req, "~> 0.5"},
      {:ash, ash_version("~> 3.0")},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.22", only: [:dev, :test]},
      {:ex_check, "~> 0.16", only: [:dev, :test]},
      {:ex_doc, "~> 0.37", only: [:dev, :test]},
      {:faker, "~> 0.18", only: [:dev, :test]},
      {:git_ops, "~> 2.7", only: [:dev, :test], runtime: false},
      {:mimic, "~> 1.11", only: [:dev, :test]},
      {:sobelow, "~> 0.13", only: [:dev, :test]},
      {:styler, "~> 1.4", only: [:dev, :test], runtime: false},
      {:sourceror, "~> 1.7", only: [:dev, :test]},
      {:igniter, "~> 0.5", only: [:dev, :test]}
    ]
  end

  defp elixirc_paths(env) when env in [:dev, :test], do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp ash_version(default_version) do
    case System.get_env("ASH_VERSION") do
      nil -> default_version
      "local" -> [path: "../ash", override: true]
      "main" -> [git: "https://github.com/ash-project/ash.git", override: true]
      version -> "~> #{version}"
    end
  end
end
