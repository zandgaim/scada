#!/bin/sh
set -e

# Wait for PostgreSQL to be ready
until PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -d $POSTGRES_DB -c '\q' 2>/dev/null; do
  echo "Waiting for database connection..."
  sleep 1
done

# Debug paths
echo "Checking available files:"
ls -l /app/releases/0.1.0/

# Ensure SECRET_KEY_BASE is set
if [ -z "$SECRET_KEY_BASE" ]; then
  echo "Generating SECRET_KEY_BASE..."
  export SECRET_KEY_BASE=$(elixir --eval "IO.puts(:crypto.strong_rand_bytes(64) |> Base.encode64 |> binary_part(0, 64))")
  echo "Generated SECRET_KEY_BASE: $SECRET_KEY_BASE"
fi

# Run migrations
echo "Running database migrations..."
/app/bin/scada eval "Scada.Release.migrate"

# Start the application
exec "/app/bin/scada" "start"