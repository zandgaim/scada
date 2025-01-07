defmodule Scada.PythonPort do
  use GenServer
  require Logger

  @tcp_host Application.compile_env(:scada, :tcp_host)
  @tcp_port Application.compile_env(:scada, :tcp_port)

  @python_env Application.compile_env(:scada, :python_env)
  @ads_service Application.compile_env(:scada, :ads_service)

  @ams_net_id Application.compile_env(:scada, :ams_net_id)
  @ams_port Application.compile_env(:scada, :ams_port)

  @retry_interval 10_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    start_python_script()

    state = %{
      connected: false,
      socket: nil,
      data: nil,
      status: "waiting",
      message: "Not connected to machine",
      tcp_status: "Not established",
      tcp_message: ""
    }

    connect()
    {:ok, state}
  end

  def handle_info(:connect, %{connected: true} = state) do
    {:noreply, state}
  end

  def handle_info(:connect, %{connected: false} = state) do
    case :gen_tcp.connect(String.to_charlist(@tcp_host), @tcp_port, [:binary, active: true]) do
      {:ok, socket} ->
        connect_to_ads(socket, %{command: "connect"})
        new_state = %{state | socket: socket, tcp_status: "Established"}
        Logger.info("TCP connection established to #{@tcp_host}:#{@tcp_port}")
        {:noreply, new_state}

      {:error, reason} ->
        Logger.error("Failed to connect, reason: #{inspect(reason)}")
        connect()
        {:noreply, state}
    end
  end

  def handle_info({:tcp, socket, data}, state) do
    case Jason.decode(data) do
      {:ok, %{"routing_key" => routing_key} = response} ->
        Logger.info("Received data: #{inspect(response)}")
        handle_routing_key(socket, routing_key, response, state)

      {:error, _reason} ->
        new_state = %{state | status: "error", message: "Invalid data from Python service"}
        broadcast(new_state)
        Logger.error("Invalid JSON data received from Python service")
        {:noreply, new_state}
    end
  end

  def handle_info({:tcp_closed, _socket}, state) do
    new_state = %{
      state
      | connected: false,
        socket: nil,
        tcp_status: "Disconnected",
        tcp_message: "Retrying connection"
    }

    broadcast(new_state)
    connect()
    Logger.warn("TCP connection closed. Retrying...")
    {:noreply, new_state}
  end

  def handle_info({:tcp_error, _socket, reason}, state) do
    new_state = %{
      state
      | connected: false,
        socket: nil,
        tcp_status: "Error",
        tcp_message: "TCP error: #{inspect(reason)}"
    }

    broadcast(new_state)
    connect()
    Logger.error("TCP error encountered: #{inspect(reason)}")
    {:noreply, new_state}
  end

  def handle_call({:fetch_data, data}, _from, %{connected: true, socket: socket} = state) do
    request = Jason.encode!(%{command: "fetch_data", data: data})
    :gen_tcp.send(socket, request <> "\n")

    Logger.info("Fetch data request sent: #{inspect(data)}")
    {:reply, %{"status" => "fetching", "message" => "Request sent to fetch"}, state}
  end

  def handle_call({:fetch_data, _data}, _from, %{connected: false} = state) do
    {:reply, %{"status" => "error", "message" => "Not connected to Python service"}, state}
  end

  def fetch_data(fields) do
    GenServer.call(__MODULE__, {:fetch_data, fields})
  end

  defp connect_to_ads(socket, request) do
    encoded_request =
      %{
        ams_net_id: @ams_net_id,
        ams_port: @ams_port
      }
      |> Map.merge(request)
      |> Jason.encode!()

    :gen_tcp.send(socket, encoded_request <> "\n")
    Logger.info("Request sent to ADS: #{inspect(encoded_request)}")
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

    Logger.info("Sending request to ADS service: #{inspect(command)}")
    Port.open({:spawn_executable, @python_env}, [:binary, args: command])
  end

  defp handle_routing_key(
         socket,
         "connect",
         %{"status" => "connected", "message" => message},
         state
       ) do
    new_state = %{state | socket: socket, connected: true, status: "connected", message: message}
    broadcast(new_state)
    Logger.info("Connection established successfully: #{message}")
    {:noreply, new_state}
  end

  defp handle_routing_key(
         _socket,
         "connect",
         %{"status" => "error", "message" => error_message},
         state
       ) do
    new_state = %{state | connected: false, status: "error", message: error_message}
    broadcast(new_state)
    Logger.error("Error during connection: #{error_message}")
    {:noreply, new_state}
  end

  defp handle_routing_key(_socket, "fetch_data", %{"message" => message, "data" => data}, state) do
    new_state = %{state | message: message, data: data}
    broadcast(new_state)
    Logger.info("Fetch data response: #{message}, data: #{inspect(data)}")
    {:noreply, new_state}
  end

  defp handle_routing_key(_socket, "fetch_data", %{"message" => message}, state) do
    new_state = %{state | message: message, data: nil}
    broadcast(new_state)
    Logger.warn("Fetch data response without data: #{message}")
    {:noreply, new_state}
  end

  defp handle_routing_key(_socket, _unknown_key, %{"message" => message}, state) do
    new_state = %{state | status: "error", message: "Unhandled routing key: #{message}"}
    broadcast(new_state)
    Logger.error("Unhandled routing key: #{message}")
    {:noreply, new_state}
  end

  defp connect do
    Process.send_after(self(), :connect, @retry_interval)
  end

  defp start_python_script do
    spawn(fn ->
      System.cmd("py", [@ads_service])
      Logger.info("Python script started for ADS service")
    end)
  end

  defp broadcast(state) do
    combined_result = %{
      status: state.status,
      message: state.message,
      data: state.data,
      tcp_status: state.tcp_status,
      tcp_message: state.tcp_message
    }

    Phoenix.PubSub.broadcast(
      Scada.PubSub,
      "connection_status",
      combined_result
    )

    Logger.info("Broadcasting connection status: #{inspect(combined_result)}")
  end
end
