import Config

config :ash,
  allow_forbidden_field_for_relationships_by_default?: true,
  include_embedded_source_by_default?: false,
  show_keysets_for_all_actions?: false,
  default_page_type: :keyset,
  policies: [no_filter_static_forbidden_reads?: false],
  keep_read_action_loads_when_loading?: false,
  default_actions_require_atomic?: true,
  read_action_after_action_hooks_in_order?: true,
  bulk_actions_default_to_errors?: true,
  transaction_rollback_on_error?: true

config :spark,
  formatter: [
    remove_parens?: true,
    "Ash.Resource": [
      section_order: [
        :postgres,
        :resource,
        :attributes,
        :relationships,
        :aggregates,
        :multitenancy,
        :policies,
        :identities,
        :field_policies,
        :code_interface,
        :authentication,
        :actions,
        :preparations,
        :changes,
        :validations,
        :calculations,
        :pub_sub
      ]
    ],
    "Ash.Domain": [
      section_order: [
        :resources,
        :policies,
        :authorization,
        :domain,
        :execution
      ]
    ]
  ]

config :ash_learning,
  ecto_repos: [AshLearning.Repo],
  generators: [timestamp_type: :utc_datetime],
  ash_domains: [AshLearning.Accounts]

phx_host = System.get_env("PHX_HOST")
app_host = System.get_env("APP_HOST")

config :ash_learning, AshLearningWeb,
  main_host: phx_host,
  app_host: app_host,
  site_url: "https://#{phx_host}",
  app_url: "https://#{app_host}"

# Configure the endpoint
config :ash_learning, AshLearningWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    # TODO: Implement intertia static SSR render errors
    formats: [html: AshLearningWeb.ErrorHTML, json: AshLearningWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AshLearning.PubSub,
  live_view: [signing_salt: "NtvF2+6g"]

config :ash_learning, AshLearning.Mailer, adapter: Swoosh.Adapters.Local

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :inertia,
  endpoint: AshLearningWeb.Endpoint,
  static_paths: ["/assets/app.js"],
  default_version: "1",
  camelize_props: false,
  history: [encrypt: false],
  ssr: true,
  raise_on_ssr_failure: config_env() != :prod

config :wayfinder_ex,
  otp_app: :ash_learning,
  router: AshLearningWeb.Router

import_config "#{config_env()}.exs"
