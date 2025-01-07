# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :scada,
  generators: [timestamp_type: :utc_datetime],
  python_env: "venv/Scripts/python",
  ads_service: "priv/python/ads_service.py",
  ams_net_id: "192.168.56.1.1.1",
  ams_port: 851,
  tcp_host: "127.0.0.1",
  tcp_port: 8888

# Configures the endpoint
config :scada, ScadaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ScadaWeb.ErrorHTML, json: ScadaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Scada.PubSub,
  live_view: [signing_salt: "B96JDybz"]

config :scada, Scada.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  scada: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  scada: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger,
  backends: [:console, {LoggerFileBackend, :file_log}]

# Configure the console logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure the file logger
config :logger, :file_log,
  path: "logs/app.log",
  level: :info,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :file, :line]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
