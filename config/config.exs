# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :plugoid_demo, PlugoidDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JK1qfrvct/iUJk4gpwwzN0AZLcA5xAToN8fo6EKVDedDUsD4dI8aPFxGKbhAg/91",
  render_errors: [view: PlugoidDemoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PlugoidDemo.PubSub,
  live_view: [signing_salt: "9sc1ePDE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :filter_parameters, ["id_token", "code", "token"]

config :plugoid, :state_cookie_store_opts, [
  signing_salt: "ExQ8h7F48E9j4MML7J8C4sjBLdAu+Wy4DE9MOPrUPl9XLGnNvFmtPbYTy58TCF7j"
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
