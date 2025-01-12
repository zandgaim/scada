defmodule Scada.DataManager do
  use GenServer
  require Logger

  @broadcast_interval 2_000
  @fetch_interval 2_500

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def store_data(data) do
    GenServer.cast(__MODULE__, {:store_data, data})
  end

  def init(:ok) do
    state = %{data: initial_state()}
    schedule_fetch()
    {:ok, state}
  end

  def handle_info(:fetch_data, state) do
    get_parameter_map()
    |> Enum.each(fn {_key, params} ->
      params
      |> Map.values()
      |> Scada.PythonPort.fetch_data()
    end)

    schedule_fetch()
    schedule_broadcast()

    {:noreply, state}
  end

  def handle_info(:broadcast_data, state) do
    broadcast_data(state.data)
    {:noreply, state}
  end

  def handle_cast({:store_data, data}, state) do
    new_data = update_state_data(state.data, data)
    new_state = %{state | data: new_data}

    {:noreply, new_state}
  end

  defp schedule_fetch do
    Process.send_after(self(), :fetch_data, @fetch_interval)
  end

  defp schedule_broadcast do
    Process.send_after(self(), :broadcast_data, @broadcast_interval)
  end

  defp broadcast_data(data) do
    Phoenix.PubSub.broadcast(Scada.PubSub, "connection_status", {:update_containers, data})
  end

  def get_parameter_map do
    Scada.ContainersData.get_containers()
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
    Scada.ContainersData.get_containers()
    |> Enum.map(fn %{title: title, status_indicator: status, items: items} ->
      %{
        title: title,
        status_indicator: status,
        items:
          Enum.map(items, fn {label, key, type, value} ->
            {label, key, type, value}
          end)
      }
    end)
  end

  defp update_state_data(existing_data, new_data) do
    Enum.map(existing_data, fn container ->
      updated_items =
        Enum.map(container.items, fn {label, key, type, value} ->
          new_value = Map.get(new_data, key, value)
          {label, key, type, new_value}
        end)

      %{container | items: updated_items}
    end)
  end
end
