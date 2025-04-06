defmodule Scada.DBManager do
  alias Scada.{Repo, DataPoint}
  import Ecto.Query

  def get_historical_data(container_title, item_key, opts \\ []) do
    from_time = Keyword.get(opts, :from_time)
    to_time = Keyword.get(opts, :to_time, DateTime.utc_now())
    limit = Keyword.get(opts, :limit)

    query =
      from(dp in DataPoint,
        where: dp.container_title == ^container_title and dp.key == ^item_key,
        where: dp.recorded_at <= ^to_time,
        order_by: [asc: dp.recorded_at],
        select: %{
          value: dp.value,
          value_type: dp.value_type,
          recorded_at: dp.recorded_at
        }
      )

    query =
      if from_time do
        from(dp in query, where: dp.recorded_at >= ^from_time)
      else
        query
      end

    query =
      if limit do
        from(dp in query, limit: ^limit)
      else
        query
      end

    data = Repo.all(query)
    Enum.map(data, &deserialize_value/1)
  end

  # Fetch unique container titles
  def list_container_titles do
    Repo.all(
      from(dp in DataPoint,
        distinct: dp.container_title,
        select: dp.container_title
      )
    )
  end

  # Fetch parameters filtered by container title
  def list_parameters(container_title \\ nil) do
    query =
      from(dp in DataPoint,
        distinct: [dp.container_title, dp.key],
        select: %{container_title: dp.container_title, key: dp.key}
      )

    query =
      if container_title do
        from(dp in query, where: dp.container_title == ^container_title)
      else
        query
      end

    Repo.all(query)
  end

  # Deserialize the binary value based on its value_type
  defp deserialize_value(%{value: value, value_type: type, recorded_at: recorded_at}) do
    deserialized_value = :erlang.binary_to_term(value)

    %{
      value: deserialized_value,
      value_type: type,
      recorded_at: recorded_at
    }
  end
end
