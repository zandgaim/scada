defmodule Scada.DBManager do
  alias Scada.Repo
  alias Scada.Metrics
  alias Scada.FetchingTime

  require Logger

  def insert_containers_data(data) do
    now = DateTime.utc_now()
    rounded_time = round_to_nearest_5s(now)

    valid_points =
      for %{title: title, items: items} <- data,
          {_label, key, _unit, value} <- items,
          value != "N/A" and not is_binary(value) do
        %{
          container_title: title,
          key: prepare_key(key),
          value: to_float(value),
          recorded_at: rounded_time,
          inserted_at: NaiveDateTime.utc_now(),
          updated_at: NaiveDateTime.utc_now()
        }
      end

    result = Repo.insert_all("data_points", valid_points)
    Logger.info("Inserted #{length(valid_points)} data points at #{DateTime.to_string(now)}")
    result
  end

  def insert_metrics(%{
        container_title: title,
        cpu_utilization_percent: cpu,
        memory_usage_mb: mem,
        memory_working_set_mb: working_set,
        rx_bytes_mb: rx,
        tx_bytes_mb: tx
      }) do
    now = DateTime.utc_now()
    rounded_time = round_to_nearest_5s(now)

    %Metrics{}
    |> Metrics.changeset(%{
      container_title: title,
      cpu_utilization_percent: cpu,
      memory_usage_mb: mem,
      memory_working_set_mb: working_set,
      rx_bytes_mb: rx,
      tx_bytes_mb: tx,
      recorded_at: rounded_time
    })
    |> Repo.insert()
  end

  defp round_to_nearest_5s(dt) do
    dt
    |> Map.update!(:second, &(div(&1, 5) * 5))
    |> Map.put(:microsecond, {0, 6})
  end

  def insert_fetching_time(fetching_time) do
    %FetchingTime{}
    |> FetchingTime.changeset(%{
      fetching_time: fetching_time
    })
    |> Repo.insert()
  end

  defp to_float(value) do
    case value do
      v when is_float(v) ->
        v

      v when is_integer(v) ->
        v * 1.0

      true ->
        1.0

      false ->
        0.0
    end
  end

  def prepare_key(key) do
    key
    |> String.split(".")
    |> List.last()
  end
end
