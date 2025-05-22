defmodule Scada.DataManager do
  use GenServer
  require Logger

  alias Scada.ContainersData
  alias Scada.ADSMenager
  alias Scada.DBManager

  @scada_transport "scada_pub_sub"
  @update_containers :update_containers
  @set_data_status :set_data_status
  @default_interval 2_000
  @db_insert_interval 5_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def store_data(data) do
    GenServer.cast(__MODULE__, {:store_data, data})
  end

  def set_data(data) do
    GenServer.cast(__MODULE__, {:set_data, data})
  end

  def update_interval(interval) when interval in [1, 2, 5] do
    GenServer.cast(__MODULE__, {:update_interval, interval * 1000})
  end

  def update_interval(_) do
    :ignore
  end

  def update_db_interval(interval) when interval in [1, 2, 5, 10] do
    GenServer.cast(__MODULE__, {:update_db_interval, interval * 1000})
  end

  def update_db_interval(_) do
    :ignore
  end

  def init(:ok) do
    state = %{
      data: initial_state(),
      interval: @default_interval,
      db_interval: @db_insert_interval
    }

    schedule_fetch(state.interval)
    schedule_broadcast(state.interval)
    schedule_db_insert(state.db_interval)
    {:ok, state}
  end

  # Handle fetching data
  def handle_info(:fetch_data, state) do
    get_parameter_map()
    |> Enum.each(fn {_key, params} ->
      params
      |> Map.values()
      |> ADSMenager.fetch_data()
    end)

    schedule_fetch(state.interval)
    schedule_broadcast(state.interval)

    {:noreply, state}
  end

  def handle_info(:broadcast_data, state) do
    state.data
    |> data_to_map()
    |> broadcast(@update_containers)

    {:noreply, state}
  end

  def handle_info(:db_insert, state) do
    DBManager.insert_containers_data(state.data)
    schedule_db_insert(state.db_interval)
    {:noreply, state}
  end

  def handle_cast({:store_data, data}, state) do
    new_data = update_state_data(state.data, data)
    new_state = %{state | data: new_data}

    {:noreply, new_state}
  end

  def handle_cast({:set_data, data}, state) do
    try do
      converted_data =
        data
        |> Enum.map(fn {key, value} -> {key, parse_value(value)} end)
        |> Enum.into(%{})

      ADSMenager.set_data(converted_data)
    rescue
      _exception ->
        "⚠️ Invalid data"
        |> broadcast(@set_data_status)
    end

    {:noreply, state}
  end

  def handle_cast({:update_interval, interval}, state) do
    new_state = %{state | interval: interval}

    {:noreply, new_state}
  end

  defp schedule_fetch(interval) do
    Process.send_after(self(), :fetch_data, interval)
  end

  defp schedule_broadcast(interval) do
    Process.send_after(self(), :broadcast_data, interval)
  end

  defp schedule_db_insert(interval) do
    Process.send_after(self(), :db_insert, interval)
  end

  defp broadcast(data, @update_containers) do
    Phoenix.PubSub.broadcast(
      Scada.PubSub,
      @scada_transport,
      {@update_containers, data}
    )
  end

  defp broadcast(data, @set_data_status) do
    Phoenix.PubSub.broadcast(
      Scada.PubSub,
      @scada_transport,
      {@set_data_status, data}
    )
  end

  def get_parameter_map do
    ContainersData.get_containers()
    |> Enum.reduce(%{}, fn container, acc ->
      Map.put(
        acc,
        container.title,
        container.items
        |> Enum.into(%{}, fn {_label, key, _type, _value} -> {key, key} end)
      )
    end)
  end

  defp initial_state do
    ContainersData.get_containers()
    |> Enum.map(fn %{title: title, items: items} ->
      %{
        title: title,
        items:
          Enum.map(items, fn {label, key, type, value} ->
            {label, key, type, number_format(value)}
          end)
      }
    end)
  end

  defp update_state_data(existing_data, new_data) do
    Enum.map(existing_data, fn container ->
      updated_items =
        Enum.map(container.items, fn {label, key, type, value} ->
          new_value = Map.get(new_data, key, value)
          {label, key, type, number_format(new_value)}
        end)

      %{container | items: updated_items}
    end)
  end

  defp data_to_map(data) do
    Enum.reduce(data, %{}, fn %{title: title} = map, acc ->
      Map.put(acc, title, Map.delete(map, :title))
    end)
  end

  defp number_format(value) do
    case value do
      v when is_float(v) -> Float.round(v, 3)
      _ -> value
    end
  end

  defp parse_value({value, "double"}) when is_binary(value) do
    {double_value, ""} =
      value
      |> Float.parse()

    double_value
  end

  defp parse_value({"true", "bool"}), do: true
  defp parse_value({"false", "bool"}), do: false
  defp parse_value({value, "string"}) when is_binary(value), do: value

  defp parse_value({value, "int"}) when is_binary(value) do
    {int_value, ""} =
      value
      |> Integer.parse()

    int_value
  end
end
