defmodule Scada.DataPoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "data_points" do
    field(:container_title, :string)
    field(:key, :string)
    field(:value, :float)
    field(:recorded_at, :utc_datetime_usec)

    timestamps()
  end

  def changeset(data_point, attrs) do
    data_point
    |> cast(attrs, [:container_title, :key, :value, :recorded_at])
    |> validate_required([:container_title, :key, :value, :recorded_at])
  end
end
