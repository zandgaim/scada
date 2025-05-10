defmodule Scada.Repo.Migrations.CreateDataPoints do
  use Ecto.Migration

  def change do
    create table(:data_points) do
      add :container_title, :string, null: false
      add :key, :string, null: false
      add :value, :float, null: false
      add :value_type, :string
      add :recorded_at, :utc_datetime_usec, null: false

      timestamps()
    end

    create index(:data_points, [:container_title, :key])
    create index(:data_points, [:key, :recorded_at])
  end
end
