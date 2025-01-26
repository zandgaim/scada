# Stage 1: Build Stage
FROM elixir:latest AS builder

ENV MIX_ENV=prod
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client inotify-tools nodejs python3 python3-pip python3-venv build-essential libpcap-dev && \
    curl -L https://npmjs.org/install.sh | sh

# Install dependencies for Elixir and Phoenix
RUN mix local.hex --force && \
    mix archive.install hex phx_new 1.7.18 --force && \
    mix local.rebar --force

# Copy app files
COPY . .

# Install app dependencies and build the release
RUN mix deps.get --only prod && \
    mix assets.deploy && \
    mix release

# Stage 2: Final Runtime Image
FROM elixir:latest

ENV MIX_ENV=prod PORT=4020
EXPOSE $PORT

# Copy the release from the build stage
COPY --from=builder /app/_build/prod/rel/scada /app

CMD ["/app/bin/scada", "start"]
