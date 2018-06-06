# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :travenger, ecto_repos: [Travenger.Repo]

# Configures the endpoint
config :travenger, TravengerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dLyHgcrGCKjp4cjSZ5th5hQ7DjVAG4iIyIBc1Zc1ZR5k3KscjAcfG36ev44S6K8c",
  render_errors: [view: TravengerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Travenger.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :ueberauth, Ueberauth,
  providers: [
    facebook: {Ueberauth.Strategy.Facebook, []}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "360560764434228",
  client_secret: "86c29ff1049390cbf2e0850bd90a2072"
