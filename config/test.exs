import Config

is_e2e = System.get_env("E2E") == "true"
config :ash_learning, token_signing_secret: "jGuPrTa+tduE7obfw5Vfz5oDNJcxFtY1"
config :bcrypt_elixir, log_rounds: 1
config :ash, policies: [show_policy_breakdowns?: true], disable_async?: true

config :ash_learning, AshLearning.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST"),
  port: String.to_integer(System.get_env("DB_PORT") || "5432"),
  database: System.get_env("DB_NAME"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :ash_learning, AshLearningWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4004],
  url: [host: System.get_env("PHX_HOST") || "app.ashlearning.dev", scheme: "https", port: 443],
  # Only start server for E2E tests. Controller tests will use Phoenix.ConnTest
  # without starting the server.
  server: is_e2e,
  secret_key_base: "3p13l2oHifykkF/elLvNvwON0SbALfKF7PL0KegqnizwbgKSedLMWRtTOQ7NswJI",
  # No watchers needed - using built assets
  watchers: []

# Always configure phoenix_test (required for compilation)
config :phoenix_test,
  otp_app: :ash_learning,
  endpoint: AshLearningWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  playwright: [
    ws_endpoint: System.get_env("PLAYWRIGHT_WS_ENDPOINT")
  ]

config :ash_learning, AshLearning.Mailer, adapter: Swoosh.Adapters.Test
config :swoosh, :api_client, false
config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  enable_expensive_runtime_checks: true
