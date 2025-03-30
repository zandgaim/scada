import Config

config :scada, ecto_repos: [Scada.Repo]

config :scada, Scada.Repo,
  database: "scada_repo",
  username: "postgres",
  password: "pass",
  hostname: "localhost",
  log: false

config :scada,
  generators: [timestamp_type: :utc_datetime],
  python_env: "venv/Scripts/python",
  ads_service: "priv/python/ads_service.py",
  tcp_host: "127.0.0.1",
  tcp_port: 8888,

  ams_net_id: "39.133.74.23.1.1",     # Targetr Device id
  ams_port: 853,                      # Targetr Device port
  target_ip: "192.168.56.101",        # Targetr Device ip
  sender_ams: "192.168.56.101.1.1",   # Targetr Device id (custom)
  plc_username: "Administrator",      # Targetr Device username
  plc_password: "1",                  # Targetr Device password
  route_name: "SCADA_ROUTE",          # Route name
  hostname: "192.168.56.1"            # Local ip

# Configures the endpoint
config :scada, ScadaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ScadaWeb.ErrorHTML, json: ScadaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Scada.PubSub,
  cache_static_manifest: "priv/static/cache_manifest.json",
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
