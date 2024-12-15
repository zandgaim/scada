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
    # Initial state setup
    state = %{
      connected: false,
      result: %{"status" => "waiting", "message" => "Not connected to machine"}
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
          | result: %{"status" => "error", "message" => "Invalid data from Python"}
        }

        broadcast_status(new_state.result)
        {:noreply, new_state}
    end
  end

  def handle_cast({:connect, ams_net_id, ams_port}, state) do
    IO.puts("Trying to connect...")

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

  # Routing key handlers
  defp handle_routing_key("connect", %{"status" => "connected", "message" => message}, state) do
    new_state = %{
      state
      | connected: true,
        result: %{"status" => "connected", "message" => message}
    }

    broadcast_status(new_state.result)
    {:noreply, new_state}
  end

  defp handle_routing_key("connect", %{"status" => "error", "message" => error_message}, state) do
    new_state = %{
      state
      | connected: false,
        result: %{"status" => "error", "message" => error_message}
    }

    broadcast_status(new_state.result)
    {:noreply, new_state}
  end

  defp handle_routing_key(
         "fetch_data",
         %{"status" => status, "message" => message, "data" => data},
         state
       ) do
    new_state = %{
      state
      | result: %{"status" => status, "message" => message, "data" => data}
    }

    broadcast_status(new_state.result)
    {:noreply, new_state}
  end

  defp handle_routing_key(_unknown_key, %{"message" => message}, state) do
    new_state = %{
      state
      | result: %{"status" => "error", "message" => "Unhandled routing key: #{message}"}
    }

    broadcast_status(new_state.result)
    {:noreply, new_state}
  end

  defp check_connection do
    Process.send_after(self(), :check_connection, @retry_interval)
  end

  defp broadcast_status(status) do
    Phoenix.PubSub.broadcast(Scada.PubSub, "connection_status", status)
  end
end
