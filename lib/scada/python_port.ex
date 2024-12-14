defmodule Scada.PythonPort do
  use GenServer

  @python_env "venv/Scripts/python"
  @ads_service "priv/python/ads_service.py"
  @retry_interval 3_000
  @heartbeat_interval 5_000

  @ams_net_id "192.168.56.1.1.1"
  @port "851"

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    # Initial state setup
    state = %{
      port: nil,
      connected: false,
      result: %{"status" => "waiting", "message" => "Not connected to machine"}
    }

    # Start the retry connection loop
    schedule_retry()
    {:ok, state}
  end

  def handle_info(:retry_connection, state) do
    unless state.connected do
      GenServer.cast(__MODULE__, {:connect, @ams_net_id, @port})
    end

    # Schedule the next retry
    schedule_retry()
    {:noreply, state}
  end

  def handle_info(:heartbeat, state) do
    if state.connected do
      GenServer.cast(__MODULE__, {:heartbeat, @ams_net_id, @port})
    end

    # Schedule the next heartbeat check
    schedule_heartbeat()
    {:noreply, state}
  end

  # Handle response data from the Python process
  def handle_info({port, {:data, data}}, state) do
    IO.puts("Received response = #{inspect(Jason.decode(data))}")

    if port == state.port do
      case Jason.decode(data) do
        {:ok, %{"status" => "connected", "message" => message}} ->
          # Handle successful connection
          new_state = %{
            state
            | connected: true,
              result: %{"status" => "connected", "message" => message}
          }

          schedule_heartbeat()
          broadcast_status(new_state.result)
          {:noreply, new_state}

        {:ok, %{"status" => "error", "message" => error_message}} ->
          # Handle connection error
          new_state = %{
            state
            | connected: false,
              result: %{"status" => "error", "message" => error_message}
          }

          broadcast_status(new_state.result)
          {:noreply, new_state}

        {:error, _reason} ->
          # Handle unexpected data format
          new_state = %{
            state
            | result: %{"status" => "error", "message" => "Invalid data from Python"}
          }

          broadcast_status(new_state.result)
          {:noreply, new_state}
      end
    else
      {:noreply, state}
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

    # Start the Python process for connecting
    port = Port.open({:spawn_executable, @python_env}, [:binary, args: command])

    # Update state while connecting
    new_state = %{
      state
      | result: %{"status" => "connecting", "message" => "Attempting to connect to machine..."}
    }

    broadcast_status(new_state.result)
    {:noreply, %{new_state | port: port}}
  end

  def handle_cast({:heartbeat, ams_net_id, ams_port}, %{port: port} = state) do
    IO.puts("Sending heartbeat to Python...")

    command = [
      @ads_service,
      "--ams_net_id",
      ams_net_id,
      "--ams_port",
      ams_port,
      "--command",
      "heartbeat"
    ]

    Port.open({:spawn_executable, @python_env}, [:binary, args: command])

    {:noreply, state}
  end

  def handle_cast({:heartbeat, ams_net_id, ams_port}, %{port: port} = state) do
    IO.puts("Sending heartbeat to Python using the existing port...")

    # Prepare the heartbeat command for the existing port
    command = [
      "--command",
      "heartbeat"
    ]

    # Send the heartbeat command via the existing port
    Port.command(port, command)

    {:noreply, state}
  end

  defp schedule_retry do
    Process.send_after(self(), :retry_connection, @retry_interval)
  end

  # Utility to schedule heartbeat check every 10 seconds
  defp schedule_heartbeat do
    Process.send_after(self(), :heartbeat, @heartbeat_interval)
  end

  # Utility to broadcast status updates using PubSub
  defp broadcast_status(status) do
    Phoenix.PubSub.broadcast(Scada.PubSub, "connection_status", status)
  end
end
