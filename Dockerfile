# Stage 1: Build Stage
FROM elixir:1.15.0 AS builder

# Set build environment
ENV MIX_ENV=prod
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs python3 python3-pip python3-venv build-essential libpcap-dev && \
    npm install -g npm@9.8.1 && \
    rm -rf /var/lib/apt/lists/*

# Install Elixir and Phoenix dependencies
RUN mix local.hex --force && \
    mix archive.install hex phx_new 1.7.18 --force && \
    mix local.rebar --force

# Copy app files to the container
COPY . .

# Install app dependencies and build the release
RUN mix deps.get --only prod && \
    mix assets.deploy && \
    mix release

# Create a Python virtual environment and install pyads
RUN python3 -m venv /opt/pyenv && \
    /opt/pyenv/bin/pip install --upgrade pip && \
    /opt/pyenv/bin/pip install pyads==3.4.2

# Add the virtual environment's Python and pip to PATH
ENV PATH="/opt/pyenv/bin:$PATH"

# Stage 2: Final Runtime Image
FROM elixir:1.15.0

# Set runtime environment
ENV MIX_ENV=prod \
    PORT=4020

WORKDIR /app

# Expose the Phoenix app port
EXPOSE $PORT

# Copy the release built in the first stage
COPY --from=builder /app/_build/prod/rel/scada /app

# Entrypoint script to ensure all runtime variables are set
COPY priv/scripts/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Default command to start the release
ENTRYPOINT ["/app/entrypoint.sh"]
