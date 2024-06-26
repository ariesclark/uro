# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 60 * 4, cleanup_interval_ms: 60_000 * 10]}

config :uro,
  title: "Uro",
  ecto_repos: [Uro.Repo],
  frontend_origin: "https://vsekai.local"

# Configures the endpoint
config :uro, UroWeb.Endpoint,
  load_from_system_env: true,
  secret_key_base: "bNDe+pg86uL938fQA8QGYCJ4V7fE5RAxoQ8grq9drPpO7mZ0oEMSNapKLiA48smR",
  render_errors: [view: UroWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Uro.PubSub,
  live_view: [signing_salt: "0dBPUwA2"]

config :uro, :stale_shard_cutoff,
  amount: 3,
  calendar_type: "month"

# every 30 days
config :uro, :stale_shard_interval, 30 * 24 * 60 * 60 * 1000

config :email_checker,
  default_dns: :system,
  also_dns: [],
  validations: [EmailChecker.Check.Format, EmailChecker.Check.SMTP, EmailChecker.Check.MX],
  smtp_retries: 2,
  timeout_milliseconds: 5000

config :uro, Uro.Turnstile, secret_key: System.get_env("TURNSTILE_SECRET_KEY")

config :uro, :pow,
  user: Uro.Accounts.User,
  repo: Uro.Repo,
  web_module: UroWeb,
  extensions: [PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  # mailer_backend: UroWeb.Pow.Mailer,
  routes_backend: UroWeb.Pow.Routes,
  web_mailer_module: UroWeb,
  # cache_store_backend: Pow.Store.Backend.MnesiaCache
  cache_store_backend: UroWeb.Pow.RedisCache

config :uro, :pow_assent,
  user_identities_context: Uro.UserIdentities,
  providers: [
    discord: [
      label: "Discord",
      client_id: "1253978304478974012",
      client_secret: "DSLc-oy-6Mvglw1Zn_NIhVB3aFEZppUV",
      strategy: Assent.Strategy.Discord
    ],
    github: [
      label: "GitHub",
      client_id: "Ov23li7vYcdEBxL5ybI3",
      client_secret: "bf4fbfa43a2ea8eaf9eedbc23feb7b4a046c1b80",
      strategy: Assent.Strategy.Github
    ]
  ]

config :uro, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: UroWeb.Router,
      endpoint: UroWeb.Endpoint
    ]
  }

config :phoenix_swagger, json_library: Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# config :waffle,
#   storage: Waffle.Storage.Local

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
