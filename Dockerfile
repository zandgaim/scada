# Stage 1: Build the Phoenix app
FROM elixir:1.15 AS builder

# Install Node.js, Python, and other necessary dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    git \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean

# Set the working directory for the Phoenix app
WORKDIR /app

# Install Elixir dependencies
COPY mix.exs mix.lock ./ 
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get --only dev

# Copy the Phoenix application files
COPY . .

# Install dependencies for the Phoenix app in production mode
RUN MIX_ENV=dev mix deps.get
RUN MIX_ENV=dev mix compile

# Build assets for Phoenix
RUN MIX_ENV=dev mix phx.digest

# Set up the Python virtual environment
WORKDIR /app/priv/python

# Create a virtual environment and install Python dependencies
RUN python3 -m venv /app/priv/python/venv
RUN /app/priv/python/venv/bin/pip install --no-cache-dir -r requirements.txt

# Ensure the virtual environment's binary folder is in the PATH
ENV PATH="/app/priv/python/venv/bin:$PATH"

# Set the working directory back to the app root
WORKDIR /app

# Expose the Phoenix app port
EXPOSE 4000

# Start the Phoenix app
CMD ["mix", "phx.server"]
