# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :internet_of_mills,
  ecto_repos: [InternetOfMills.Repo]

# Configures the endpoint
config :internet_of_mills, InternetOfMillsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tI/Km3VPOZ5Fhwax13NPFXq4LAKOBIldyAiV8KJs/B6uAk03S3koY2KbnDWiR5xa",
  render_errors: [view: InternetOfMillsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: InternetOfMills.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :internet_of_mills, mill_io: InternetOfMills.Peripheral.MillIO

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
