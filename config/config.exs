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

# CORS Plug
config :cors_plug,
  origin: ["*"],
  max_age: 86_400

# Ueberauth Config
config :ueberauth, Ueberauth,
  providers: [
    facebook:
      {Ueberauth.Strategy.Facebook,
       [
         profile_fields: "id,email,name,first_name,last_name,gender,location",
         default_scope: "email,public_profile"
       ]}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "1921038801247765",
  client_secret: "0b45c319eddc4279a92b0b5b0eb2b597"

# Guardian Config
config :travenger, Travenger.Guardian,
  issuer: "Travenger",
  secret_key: "L91+fAdDt3+Sxl+VDtPrOCM1MLG3WbRACYl3o6n9w8niR/t+LOh+LKWsVIGtUMjL"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
