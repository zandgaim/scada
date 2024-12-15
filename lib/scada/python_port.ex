defmodule Scada.PythonPort do
  use GenServer

  @python_env "venv/Scripts/python"
  @ads_service "priv/python/ads_service.py"
  @retry_interval 5_000

  @ams_net_id "192.168.56.1.1.1"
  @port "851"

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    state = %{
      connected: false,
      status: "waiting",
      message: "Not connected to machine",
      data: nil
    }

    check_connection()
    {:ok, state}
  end

  def handle_info(:check_connection, state) do
    GenServer.cast(__MODULE__, {:connect, @ams_net_id, @port})
    check_connection()
    {:noreply, state}
  end

  def handle_info({_port, {:data, data}}, state) do
    IO.puts("Received response = #{inspect(Jason.decode(data))}")

    case Jason.decode(data) do
      {:ok, %{"routing_key" => routing_key} = response} ->
        handle_routing_key(routing_key, response, state)

      {:error, _reason} ->
        new_state = %{
          state
          | status: "error",
            message: "Invalid data from Python"
        }

        broadcast(new_state)
        {:noreply, new_state}
    end
  end

  def handle_cast({:connect, ams_net_id, ams_port}, state) do
    command = [
      @ads_service,
      "--ams_net_id",
      ams_net_id,
      "--ams_port",
      ams_port,
      "--command",
      "connect"
    ]

    Port.open({:spawn_executable, @python_env}, [:binary, args: command])
    {:noreply, state}
  end

  def handle_call({:fetch_data, fields}, _from, state) do
    if state.connected do
      IO.puts("Fetching field #{fields}...")

      command = [
        @ads_service,
        "--ams_net_id",
        @ams_net_id,
        "--ams_port",
        @port,
        "--command",
        "fetch_data",
        "--data",
        fields
      ]

      Port.open({:spawn_executable, @python_env}, [:binary, args: command])
      {:reply, %{"status" => "fetching", "message" => "Request sent to fetch"}, state}
    else
      {:reply, %{"status" => "error", "message" => "Not connected to machine"}, state}
    end
  end

  def fetch_data(fields) do
    GenServer.call(__MODULE__, {:fetch_data, fields})
  end

  defp handle_routing_key("connect", %{"status" => "connected", "message" => message}, state) do
    new_state = %{
      state
      | connected: true,
        status: "connected",
        message: message
    }

    broadcast(new_state)
    {:noreply, new_state}
  end

  defp handle_routing_key("connect", %{"status" => "error", "message" => error_message}, state) do
    new_state = %{
      state
      | connected: false,
        status: "error",
        message: error_message
    }

    broadcast(new_state)
    {:noreply, new_state}
  end

  # Handling fetch data updates that should not affect the status
  defp handle_routing_key("fetch_data", %{"message" => message}, state) do
    new_state = %{
      state
      | # Only update the message, not the status
        message: message
    }

    broadcast(new_state)
    {:noreply, new_state}
  end

  defp handle_routing_key(_unknown_key, %{"message" => message}, state) do
    new_state = %{
      state
      | status: "error",
        message: "Unhandled routing key: #{message}"
    }

    broadcast(new_state)
    {:noreply, new_state}
  end

  defp check_connection do
    Process.send_after(self(), :check_connection, @retry_interval)
  end

  defp broadcast(state) do
    combined_result = %{
      :status => state.status,
      :message => state.message
    }

    Phoenix.PubSub.broadcast(
      Scada.PubSub,
      "connection_status",
      combined_result
    )
  end
end
