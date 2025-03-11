defmodule Scada.Repo do
  use Ecto.Repo,
    otp_app: :scada,
    adapter: Ecto.Adapters.Postgres
end
