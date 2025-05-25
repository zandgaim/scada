defmodule Scada.Repo.Migrations.CreateMetrics do
  use Ecto.Migration

  def change do
    create table(:metrics) do
      add :container_title, :string
      add :cpu_utilization_percent, :float
      add :memory_usage_mb, :float
      add :memory_working_set_mb, :float
      add :rx_bytes_mb, :float
      add :tx_bytes_mb, :float

      timestamps()
    end

    create index(:metrics, [:container_title])
    create index(:metrics, [:inserted_at])
  end
end
