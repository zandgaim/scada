defmodule Scada.FetchingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fetching_times" do
    field(:fetching_time, :integer)
    timestamps()
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:fetching_time])
    |> validate_required([:fetching_time])
  end
end
