defmodule AshLearning.MixProject do
  use Mix.Project

  def project do
    [
      app: :ash_learning,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      compilers: [:phoenix_live_view] ++ Mix.compilers(),
      listeners: [Phoenix.CodeReloader],
      consolidate_protocols: Mix.env() != :dev,
      dialyzer: [
        plt_local_path: "priv/plts",
        plt_core_path: "priv/plts"
      ]
    ]
  end

  def application do
    [
      mod: {AshLearning.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  def cli do
    [
      preferred_envs: [precommit: :test]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:picosat_elixir, "~> 0.2"},
      {:sourceror, "~> 1.8", only: [:dev, :test]},
      {:usage_rules, "~> 0.1", only: [:dev]},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ash_authentication, "~> 5.0.0-rc.0"},
      {:ash_authentication_phoenix, "~> 3.0.0-rc.0"},
      {:eqrcode, "~> 0.1"},
      {:ash_postgres, "~> 2.0"},
      {:ash_phoenix, "~> 2.0"},
      {:ash, "~> 3.11.2"},
      {:igniter, "~> 0.6", only: [:dev, :test]},
      {:phoenix, "~> 1.8.2"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.13"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 1.1.0"},
      {:phoenix_test, "~> 0.9", only: :test},
      {:phoenix_test_playwright, "~> 0.12", only: :test, runtime: false},
      {:websockex, "~> 0.4", only: :test},
      {:lazy_html, ">= 0.1.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:swoosh, "~> 1.16"},
      {:gen_smtp, "~> 1.2"},
      {:req, "~> 0.5"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.2.0"},
      {:bandit, "~> 1.5"},
      {:wayfinder_ex, "~> 0.1.6"},
      path_dep(:inertia, "inertia-phoenix"),
      path_dep(:vitex, "vitex")
    ]
  end

  defp path_dep(app, app_folder) do
    dev_machine_path = Path.join(System.get_env("HOME"), "code/opensource/#{app_folder}")
    ci_path = "vendor/#{app_folder}"

    cond do
      File.dir?(dev_machine_path) ->
        {app, path: dev_machine_path, override: true}

      File.dir?(ci_path) ->
        {app, path: ci_path, override: true}

      true ->
        raise """
        Missing #{app} dependency.

        Expected one of:
          - #{dev_machine_path}
          - #{ci_path}
        """
    end
  end

  defp aliases do
    [
      setup: ["deps.get", "ash.setup", "assets.setup", "assets.build", "run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ash.setup --quiet", "test"],
      check: [
        "format --check-formatted",
        "credo --strict",
        "cmd mix dialyzer --halt-exit-status"
      ],
      "assets.build": ["wayfinder.generate", "cmd pnpm --dir assets run build"],
      "assets.deploy": ["assets.build", "phx.digest"]
    ]
  end
end
