defmodule Scada.DataManager do
  use GenServer
  require Logger

  @fetch_interval 5_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def store_data(data) do
    GenServer.cast(__MODULE__, {:store_data, data})
  end

  def init(:ok) do
    state = %{data: initial_state()}

    schedule_update()
    {:ok, state}
  end

  def handle_info(:update_data, state) do
    fetched_data =
      get_parameter_map()
      |> Enum.flat_map(fn {_key, params} -> Map.values(params) end)
      |> Scada.PythonPort.fetch_data()

    Logger.debug("Fetched data: #{inspect(fetched_data)}")

    schedule_update()
    {:noreply, state}
  end

  def handle_cast({:store_data, data}, state) do
    Logger.debug("Data successfully stored: #{inspect(data)}")

    new_data = update_state_data(state.data, data)

    new_state = %{state | data: new_data}
    Logger.debug("Updated state: #{inspect(new_state)}")

    {:noreply, new_state}
  end

  defp schedule_update do
    Process.send_after(self(), :update_data, @fetch_interval)
  end

  def get_parameter_map do
    Scada.ContainersData.get_containers()
    |> Enum.reduce(%{}, fn container, acc ->
      Map.put(
        acc,
        container.title,
        container.items
        |> Enum.into(%{}, fn {_label, key, _type} -> {key, key} end)
      )
    end)
  end

  defp initial_state do
    Scada.ContainersData.get_containers()
    |> Enum.map(fn %{title: title, status_indicator: status, items: items} ->
      %{
        title: title,
        status_indicator: status,
        items: Enum.map(items, fn {label, key, type} ->
          {label, key, type, nil}
        end)
      }
    end)
  end

  defp update_state_data(existing_data, new_data) do
    Enum.map(existing_data, fn container ->
      updated_items =
        Enum.map(container.items, fn {label, key, type, _value} ->
          new_value = Map.get(new_data, key, nil)
          {label, key, type, new_value}
        end)

      %{container | items: updated_items}
    end)
  end
end
