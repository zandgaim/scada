import Config

# Configure the endpoint for production
config :scada, ScadaWeb.Endpoint,
  # Binding to a public IP address and setting the port (e.g., 80 for HTTP or 443 for HTTPS)
  http: [ip: {0, 0, 0, 0}, port: 4020],
  # Enable SSL if required (uncomment and configure below)
  # https: [
  #   port: 443,
  #   cipher_suite: :strong,
  #   keyfile: System.get_env("SSL_KEY_PATH"),
  #   certfile: System.get_env("SSL_CERT_PATH")
  # ],
  # Disable code reloader and debugging in production
  code_reloader: false,
  # Consider enabling proper origin checks in production
  check_origin: false,
  debug_errors: false,
  server: true,
  # Always use environment variables in production
  secret_key_base: System.get_env("SECRET_KEY_BASE"),

  # Use a cache for better performance in production
  cache_static_manifest: "priv/static/cache_manifest.json",

  # Serve static files from priv/static

  # Enable watchers for compiling assets in production (e.g., esbuild, tailwind)
  watchers: []

# Disable live_reload for production as it is for development
config :scada, ScadaWeb.Endpoint, live_reload: []

# Enable production-specific features
# Disable development routes (e.g., dashboard, mailbox) in production
config :scada, dev_routes: false

# Configure logging for production (minimal logs)
config :logger, :console,
  format: "[$level] $message\n",
  # Only include minimal metadata in production logs
  metadata: [:request_id]

# Production-specific settings for Phoenix
# Limit stacktrace depth in production (higher values are costly)
config :phoenix, :stacktrace_depth, 5
# Initialize plugs at compile time for faster execution
config :phoenix, :plug_init_mode, :compile

# Disable expensive checks in Phoenix LiveView
config :phoenix_live_view,
  # Disable HEEx debug annotations in production
  debug_heex_annotations: false,
  # Disable expensive runtime checks in production
  enable_expensive_runtime_checks: false

# Configure the production email system (if applicable, e.g., Swoosh)
# Enable the email client for production adapters
config :swoosh, :api_client, true
