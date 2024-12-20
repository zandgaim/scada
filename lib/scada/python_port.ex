defmodule Scada.PythonPort do
  use GenServer

  @python_env Application.compile_env(:scada, :python_env)
  @ads_service Application.compile_env(:scada, :ads_service)

  @ams_net_id Application.compile_env(:scada, :ams_net_id)
  @ams_port Application.compile_env(:scada, :ams_port)

  @retry_interval 5_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    state = %{
      connected: false,
      port: nil,
      status: "waiting",
      message: "Not connected to machine",
      data: nil
    }

    connect()
    {:ok, state}
  end

  def handle_info(:connect, %{connected: true} = state) do
    {:noreply, state}
  end

  def handle_info(:connect, %{connected: false} = state) do
    GenServer.cast(__MODULE__, :connect_to_ads)
    connect()
    {:noreply, state}
  end

  def handle_info({port, {:data, data}}, state) do
    IO.puts("Received response = #{inspect(Jason.decode(data))}")

    case Jason.decode(data) do
      {:ok, %{"routing_key" => routing_key} = response} ->
        handle_routing_key(port, routing_key, response, state)

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

  def handle_info({:EXIT, port, reason}, state) do
    IO.puts("Received exit signal from port: #{inspect(port)} with reason: #{inspect(reason)}")

    {:noreply, state}
  end

  def handle_cast(:connect_to_ads, state) do
    port =
      %{command: "connect"}
      |> connect_to_ads()

    IO.puts("ACHTUNG port = #{inspect(port)}")

    {:noreply, %{state | port: port}}
  end

  def handle_call({:fetch_data, data}, _from, state) do
    if state.connected do
      IO.puts("Fetching field #{inspect(data)}...")

      %{
        command: "fetch_data",
        data: data
      }
      |> send_to_ads()

      {:reply, %{"status" => "fetching", "message" => "Request sent to fetch"}, state}
    else
      {:reply, %{"status" => "error", "message" => "Not connected to machine"}, state}
    end
  end

  def fetch_data(fields) do
    GenServer.call(__MODULE__, {:fetch_data, fields})
  end

  defp connect_to_ads(request) do
    request =
      %{
        ams_net_id: @ams_net_id,
        ams_port: @ams_port
      }
      |> Map.merge(request)
      |> Jason.encode!()

    command = [
      @ads_service,
      "--loop",
      "--request",
      request
    ]

    Port.open({:spawn_executable, @python_env}, [:binary, args: command])
  end

  defp send_to_ads(request) do
    request =
      %{
        ams_net_id: @ams_net_id,
        ams_port: @ams_port
      }
      |> Map.merge(request)
      |> Jason.encode!()

    command = [
      @ads_service,
      "--request",
      request
    ]

    Port.open({:spawn_executable, @python_env}, [:binary, args: command])
  end

  defp handle_routing_key(port, "connect", %{"status" => "connected", "message" => message}, state) do
    new_state = %{
      state
      | port: port,
        connected: true,
        status: "connected",
        message: message
    }

    broadcast(new_state)
    {:noreply, new_state}
  end

  defp handle_routing_key(_, "connect", %{"status" => "error", "message" => error_message}, state) do
    new_state = %{
      state
      | port: nil,
        connected: false,
        status: "error",
        message: error_message
    }

    broadcast(new_state)
    {:noreply, new_state}
  end

  defp handle_routing_key(_, "fetch_data", %{"message" => message, "data" => data}, state) do
    new_state = %{state | message: message, data: data}

    broadcast(new_state)
    {:noreply, new_state}
  end

  defp handle_routing_key(_, "fetch_data", %{"message" => message}, state) do
    new_state = %{state | message: message, data: nil}

    broadcast(new_state)
    {:noreply, new_state}
  end

  defp handle_routing_key(_, _unknown_key, %{"message" => message}, state) do
    new_state = %{
      state
      | status: "error",
        message: "Unhandled routing key: #{message}"
    }

    broadcast(new_state)
    {:noreply, new_state}
  end

  defp connect do
    Process.send_after(self(), :connect, @retry_interval)
  end

  defp broadcast(state) do
    combined_result = %{
      :status => state.status,
      :message => state.message,
      :data => state.data
    }

    Phoenix.PubSub.broadcast(
      Scada.PubSub,
      "connection_status",
      combined_result
    )
  end
end
