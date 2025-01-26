# Use the latest Elixir image
FROM elixir:latest

# Expose the Phoenix default port
EXPOSE 4020

# Install system dependencies (PostgreSQL client, inotify-tools, Node.js, npm, Python, pip, and additional tools)
RUN apt-get update && \
    apt-get install -y \
    postgresql-client inotify-tools nodejs python3 python3-pip python3-venv build-essential libpcap-dev && \
    curl -L https://npmjs.org/install.sh | sh

# Create a Python virtual environment and install pyads
RUN python3 -m venv /opt/pyenv && \
    /opt/pyenv/bin/pip install --upgrade pip && \
    /opt/pyenv/bin/pip install pyads==3.4.2

# Add the virtual environment's Python and pip to PATH
ENV PATH="/opt/pyenv/bin:$PATH"

# Install Elixir and Phoenix tools
RUN mix local.hex --force && \
    mix archive.install hex phx_new 1.7.18 --force && \
    mix local.rebar --force

# Symlink python3 to python for compatibility
RUN ln -s /usr/bin/python3 /usr/bin/python

# Cleanup
RUN rm -rf /var/lib/apt/lists/*
# Set the working directory inside the container
WORKDIR /app

# Copy the project files into the container
COPY . .

# Install Elixir/Phoenix dependencies
RUN mix deps.get

# Install npm dependencies for assets (optional for Phoenix projects)
WORKDIR /app/assets
RUN npm install

# Compile the Phoenix app and prepare assets
WORKDIR /app
RUN mix assets.deploy && mix compile

# Default command to run the Phoenix server
CMD ["mix", "phx.server"]
