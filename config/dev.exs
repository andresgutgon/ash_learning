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

# GitHub OAuth Configuration
# Make sure to set these environment variables or source .env.development
config :ash_learning, :github,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITHUB_REDIRECT_URI")

config :ash_learning, :google,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :ash_learning, AshLearningWeb.Endpoint,
  # Binding to 0.0.0.0 to allow access from other containers (Traefik)
  http: [ip: {0, 0, 0, 0}, port: 4004],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "ejlJNJBwDB+4eF4Pi3lyu8MLBxNwYPhxeICB9GEER/WBoOiFIFez3AeqP83Naofi",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:ash_learning, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:ash_learning, ~w(--watch)]}
  ]

config :ash_learning, AshLearning.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: System.get_env("MAILPIT_SMTP_HOST") || "mailpit",
  port: String.to_integer(System.get_env("MAILPIT_SMTP_PORT") || "1025"),
  username: "",
  password: "",
  tls: :if_available,
  auth: :never

# Reload browser tabs when matching files change.
config :ash_learning, AshLearningWeb.Endpoint,
  live_reload: [
    web_console_logger: true,
    patterns: [
      # Static assets, except user uploads
      ~r"priv/static/(?!uploads/).*\.(js|css|png|jpeg|jpg|gif|svg)$",
      # Gettext translations
      ~r"priv/gettext/.*\.po$",
      # Router, Controllers, LiveViews and LiveComponents
      ~r"lib/ash_learning_web/router\.ex$",
      ~r"lib/ash_learning_web/(controllers|live|components)/.*\.(ex|heex)$"
    ]
  ]

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
