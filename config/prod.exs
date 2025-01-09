import Config

# Configure the endpoint for production
config :scada, ScadaWeb.Endpoint,
  # Binding to a public IP address and setting the port (e.g., 80 for HTTP or 443 for HTTPS)
  http: [ip: {0, 0, 0, 0}, port: 4000],
  # Enable SSL if required (uncomment and configure below)
  # https: [
  #   port: 443,
  #   cipher_suite: :strong,
  #   keyfile: System.get_env("SSL_KEY_PATH"),
  #   certfile: System.get_env("SSL_CERT_PATH")
  # ],
  # Disable code reloader and debugging in production
  code_reloader: false,
  check_origin: false,  # Consider enabling proper origin checks in production
  debug_errors: false,
  server: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),  # Always use environment variables in production

  # Use a cache for better performance in production
  cache_static_manifest: "priv/static/cache_manifest.json",

  # Serve static files from priv/static

  # Enable watchers for compiling assets in production (e.g., esbuild, tailwind)
  watchers: [
  ]

# Disable live_reload for production as it is for development
config :scada, ScadaWeb.Endpoint, live_reload: []

# Enable production-specific features
config :scada, dev_routes: false  # Disable development routes (e.g., dashboard, mailbox) in production

# Configure logging for production (minimal logs)
config :logger, :console,
  format: "[$level] $message\n",
  metadata: [:request_id]  # Only include minimal metadata in production logs

# Production-specific settings for Phoenix
config :phoenix, :stacktrace_depth, 5  # Limit stacktrace depth in production (higher values are costly)
config :phoenix, :plug_init_mode, :compile  # Initialize plugs at compile time for faster execution

# Disable expensive checks in Phoenix LiveView
config :phoenix_live_view,
  debug_heex_annotations: false,  # Disable HEEx debug annotations in production
  enable_expensive_runtime_checks: false  # Disable expensive runtime checks in production

# Configure the production email system (if applicable, e.g., Swoosh)
config :swoosh, :api_client, true  # Enable the email client for production adapters
