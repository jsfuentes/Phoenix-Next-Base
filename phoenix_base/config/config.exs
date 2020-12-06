# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phoenix_base,
  ecto_repos: [PhoenixBase.Repo]

config :phoenix_base, PhoenixBase.Repo,
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_DATABASE"),
  hostname: System.get_env("DB_HOSTNAME"),
  show_sensitive_data_on_connection_error: true,
  migration_timestamps: [type: :utc_datetime_usec],
  pool_size: 5,
  ssl: true,
  ssl_opts: [
    versions: [:"tlsv1.2"]
  ]

config :phoenix_base, node_server: "http://localhost:3000"

# Configures the endpoint
config :phoenix_base, PhoenixBaseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aeRDA4ILZ2CAdBQqjGvivWPnP7z3nkT7Y30FS6jRT8M0QY97wMSZ7S3YeuLJoSL6",
  render_errors: [view: PhoenixBaseWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PhoenixBase.PubSub,
  live_view: [signing_salt: "nA7fvsAL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_base,
  daily_api: "d973f2b982953d4f582a8f6b5c25cdc04564e902301fa6554964d999d2c5f2c5"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
