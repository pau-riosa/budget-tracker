# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :money,
  default_currency: :USD,
  separator: ",",
  delimiter: ".",
  symbol: true,
  symbol_on_right: false,
  symbol_space: true,
  fractional_unit: true,
  strip_insignificant_zeros: true,
  code: false,
  minus_sign_first: true,
  strip_insignificant_fractional_unit: false

config :budget_tracker,
  ecto_repos: [BudgetTracker.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :budget_tracker, BudgetTrackerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: BudgetTrackerWeb.ErrorHTML, json: BudgetTrackerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: BudgetTracker.PubSub,
  live_view: [signing_salt: "AlPQlexN"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :budget_tracker, BudgetTracker.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  budget_tracker: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  budget_tracker: [
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
