import Config
config :ash_learning, token_signing_secret: "jGuPrTa+tduE7obfw5Vfz5oDNJcxFtY1"
config :bcrypt_elixir, log_rounds: 1
config :ash, policies: [show_policy_breakdowns?: true], disable_async?: true

# Test database configuration - use dedicated test DB
config :ash_learning, AshLearning.Repo,
  username: System.get_env("DB_USER") || "ash_learning",
  password: System.get_env("DB_PASSWORD") || "secret",
  hostname: System.get_env("DB_HOST") || "localhost",
  # Docker postgres port
  port: System.get_env("DB_PORT") || "5436",
  # Use dedicated test database
  database: "ash_learning_test",
  # Keep sandbox for unit tests
  pool: Ecto.Adapters.SQL.Sandbox,
  # Better for concurrent tests
  pool_size: System.schedulers_online() * 2

config :ash_learning, AshLearningWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4005],  # Use different port to avoid conflict
  server: false,  # Never start server in test environment - use background server
  secret_key_base: "3p13l2oHifykkF/elLvNvwON0SbALfKF7PL0KegqnizwbgKSedLMWRtTOQ7NswJI",
  watchers: []  # No watchers needed - using built assets

config :phoenix_test,
  otp_app: :ash_learning,
  endpoint: AshLearningWeb.Endpoint,
  base_url: "https://app.ashlearning.dev",  # Point to Traefik SSL endpoint
  playwright: [
    ws_endpoint: System.get_env("PLAYWRIGHT_WS_ENDPOINT")
  ]

# In test we don't send emails
config :ash_learning, AshLearning.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :ash_learning,
  test_dev_mode: true

config :phoenix_live_view,
  enable_expensive_runtime_checks: true
