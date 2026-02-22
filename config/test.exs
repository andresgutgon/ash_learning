import Config
config :ash_learning, token_signing_secret: "jGuPrTa+tduE7obfw5Vfz5oDNJcxFtY1"
config :bcrypt_elixir, log_rounds: 1
config :ash, policies: [show_policy_breakdowns?: true], disable_async?: true

# Test hosts for router host constraints - use dev domains for Vite HMR
config :ash_learning, AshLearningWeb,
  main_host: "ashlearning.dev",      # Use dev domain
  app_host: "app.ashlearning.dev",   # Use dev domain for Vite HMR
  site_url: "https://ashlearning.dev",
  app_url: "https://app.ashlearning.dev"

System.put_env("VITE_HOST", "localhost:5173")

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ash_learning, AshLearning.Repo,
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PASSWORD") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  database: "ash_learning_development", # Use dev DB for E2E tests
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :ash_learning, AshLearningWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4002],  # Bind to all interfaces for Docker access
  server: true

config :phoenix_test,
  otp_app: :ash_learning,
  playwright: [
    ws_endpoint: "ws://playwright:3000"
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
