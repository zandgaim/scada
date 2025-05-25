defmodule Scada.Repo.Migrations.CreateFetchngTime do
  use Ecto.Migration

  def change do
    create table(:fetching_times) do
      add :fetching_time, :integer, null: false

      timestamps()
    end
  end
end
