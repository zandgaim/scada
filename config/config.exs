import Config

config :scada,
  generators: [timestamp_type: :utc_datetime],
  python_env: "venv/Scripts/python",
  ads_service: "priv/python/ads_service.py",
  tcp_host: "127.0.0.1",
  tcp_port: 8888,
  # Targetr Device id
  ams_net_id: "39.133.74.23.1.1",
  # Targetr Device port
  ams_port: 853,
  # Targetr Device IP
  target_ip: "192.168.56.101",
  # Target Device IP + 2 digits of custom id
  sender_ams: "192.168.56.101.1.1",
  # Targetr Device username
  plc_username: "Administrator",
  # Targetr Device password
  plc_password: "1",
  # Route Name
  route_name: "SCADA_ROUTE",
  # Local IP, should be same as the TwinCat routing
  hostname: "192.168.56.1",
  grafana_url: "http://192.168.56.103:3000"

config :scada, ecto_repos: [Scada.Repo]

config :scada, Scada.Repo,
  database: "scada_repo",
  username: "postgres",
  password: "pass",
  hostname: "localhost",
  log: false

config :scada, Scada.PromEx,
  manual_metrics_start: false,
  plugins: [
    PromEx.Plugins.Beam,
    PromEx.Plugins.Phoenix,
    PromEx.Plugins.Ecto,
    PromEx.Plugins.PlugCowboy
  ],
  grafana_agent: [
    port: 4020,
    bind_address: "0.0.0.0"
  ]

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
