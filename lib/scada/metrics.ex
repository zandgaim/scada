defmodule Scada.Metrics do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :container_title,
    :cpu_utilization_percent,
    :memory_usage_mb,
    :memory_working_set_mb,
    :rx_bytes_mb,
    :tx_bytes_mb
  ]

  schema "metrics" do
    field(:container_title, :string)
    field(:cpu_utilization_percent, :float)
    field(:memory_usage_mb, :float)
    field(:memory_working_set_mb, :float)
    field(:rx_bytes_mb, :float)
    field(:tx_bytes_mb, :float)

    timestamps()
  end

  @doc false
  def changeset(metrics, attrs) do
    metrics
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
