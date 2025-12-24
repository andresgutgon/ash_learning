import Config

env = config_env()
dev_mode = env == :dev
prod_mode = env == :prod
test_dev_mode = env == :test and System.get_env("CI") != "true"

config :ash_learning,
  env: env,
  dev_mode: dev_mode,
  prod_mode: prod_mode,
  test_dev_mode: test_dev_mode

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

config :ash_learning, Inertia.SSR,
  path: Path.join([Application.app_dir(:ash_learning), "priv", "ssr-js"]),
  ssr_adapter: Vitex.inertia_ssr_adapter(dev_mode: dev_mode or test_dev_mode),
  esm: true

# The secret key base is used to sign/encrypt cookies and other secrets.
# A default value is used in config/dev.exs and config/test.exs but you
# want to use a different value for prod and you most likely don't want
# to check this value into version control, so we use an environment
# variable instead.
secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :ash_learning, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

config :ash_learning, AshLearningWeb.Endpoint,
  url: [host: System.get_env("PHX_HOST"), scheme: "https", port: 443],
  http: [
    # Enable IPv6 and bind on all interfaces.
    # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
    # See the documentation on https://hexdocs.pm/bandit/Bandit.html#t:options/0
    # for details about using IPv6 vs IPv4 and loopback vs public addresses.
    ip: {0, 0, 0, 0, 0, 0, 0, 0}
  ],
  secret_key_base: secret_key_base

if config_env() == :prod do
  # force_ssl is set at compile-time in prod.exs, but we need hsts at runtime too
  config :ash_learning, AshLearningWeb.Endpoint, force_ssl: [hsts: true]
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :ash_learning, AshLearning.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    # For machines with several cores, consider starting multiple pools of `pool_size`
    # pool_count: 4,
    socket_options: maybe_ipv6

  config :ash_learning,
    token_signing_secret:
      System.get_env("TOKEN_SIGNING_SECRET") ||
        raise("Missing environment variable `TOKEN_SIGNING_SECRET`!")

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Here is an example configuration for Mailgun:
  #
  #     config :ash_learning, AshLearning.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # Most non-SMTP adapters require an API client. Swoosh supports Req, Hackney,
  # and Finch out-of-the-box. This configuration is typically done at
  # compile-time in your config/prod.exs:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Req
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
