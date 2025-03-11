# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :full_plate,
  ecto_repos: [FullPlate.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :full_plate, FullPlateWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: FullPlateWeb.ErrorHTML, json: FullPlateWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: FullPlate.PubSub,
  live_view: [signing_salt: "P1UeW/z8"],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :full_plate, FullPlate.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  full_plate: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  full_plate: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :full_plate, FullPlateWeb.Guardian,
  issuer: "full_plate",
  secret_key: "mix guardian.gen.secret"

config :tesla, adapter: Tesla.Adapter.Hackney

config :full_plate, :mock_system, FullPlate.Payments.AdapterMock
