import Config
config :ash, policies: [show_policy_breakdowns?: true]

# Configure your database
config :ash_learning, AshLearning.Repo,
  username: "ash_learning",
  password: "secret",
  hostname: "db",
  database: "ash_learning_development",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :ash_learning, AshLearningWeb.Endpoint,
  # Binding to 0.0.0.0 to allow access from other containers (Traefik)
  http: [ip: {0, 0, 0, 0}, port: 4004],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  watchers: [
    pnpm: ["run", "dev", cd: Path.expand("../assets", __DIR__)]
  ]

config :ash_learning, AshLearning.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: System.get_env("MAILPIT_SMTP_HOST") || "mailpit",
  port: String.to_integer(System.get_env("MAILPIT_SMTP_PORT") || "1025"),
  username: "",
  password: "",
  tls: :if_available,
  auth: :never

# Enable dev routes for dashboard and mailbox
config :ash_learning, dev_routes: true, token_signing_secret: "COcv8F14gQqwmVxOrfhRvSurF17nj9bH"

# Do not include metadata nor timestamps in development logs
config :logger, :default_formatter, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Include debug annotations and locations in rendered markup.
  # Changing this configuration will require mix clean and a full recompile.
  debug_heex_annotations: true,
  debug_attributes: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
