defmodule Scada.DBManager do
  alias Scada.Repo

  require Logger

  def insert(data) do
    now = DateTime.utc_now()

    rounded_now = round_to_nearest_5s(now)

    Enum.each(data, fn %{title: title, items: items} ->
      Enum.each(items, fn {_label, key, _unit, value} ->
        unless value == "N/A" or is_binary(value) do
          try do
            Repo.insert!(%Scada.DataPoint{
              container_title: title,
              key: prepare_key(key),
              value: to_float(value),
              recorded_at: rounded_now
            })
          rescue
            e ->
              Logger.error("Failed to save data: #{inspect(e)}")
          end
        end
      end)
    end)
  end

  defp round_to_nearest_5s(dt) do
    dt
    |> Map.update!(:second, &(div(&1, 5) * 5))
    |> Map.put(:microsecond, {0, 6})
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
