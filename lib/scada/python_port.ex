defmodule Scada.PythonPort do
  use GenServer
  require Logger

  @tcp_host Application.compile_env(:scada, :tcp_host)
  @tcp_port Application.compile_env(:scada, :tcp_port)
  @ads_service Application.compile_env(:scada, :ads_service)
  @ams_net_id Application.compile_env(:scada, :ams_net_id)
  @ams_port Application.compile_env(:scada, :ams_port)
  @retry_interval 10_000

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def fetch_data(fields) do
    GenServer.call(__MODULE__, {:fetch_data, fields})
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    start_python_script()

    state = %{
      connected: false,
      socket: nil,
      data: nil,
      status: "Waiting",
      message: "Not connected to machine",
      tcp_status: "Not established",
      tcp_message: ""
    }

    broadcast(state)
    connect()
    {:ok, state}
  end

  def handle_info(:connect, %{connected: true} = state) do
    {:noreply, state}
  end

  def handle_info(:connect, %{connected: false} = state) do
    case :gen_tcp.connect(String.to_charlist(@tcp_host), @tcp_port, [
           :binary,
           packet: :line,
           active: true,
           reuseaddr: true
         ]) do
      {:ok, socket} ->
        connect_to_ads(socket, %{command: "connect"})
        new_state = %{state | socket: socket, tcp_status: "Established"}
        Logger.info("TCP: connection established to #{@tcp_host}:#{@tcp_port}")
        {:noreply, new_state}

      {:error, reason} ->
        Logger.error("TCP: failed to connect, reason: #{inspect(reason)}")
        connect()
        {:noreply, state}
    end
  end

  def handle_info({:tcp, socket, data}, %{socket: socket} = state) do
    case Jason.decode(data) do
      {:ok, %{"routing_key" => routing_key} = response} ->
        handle_routing_key(socket, routing_key, response, state)

      {:error, _reason} ->
        new_state = %{state | message: "Invalid data from Python service"}
        broadcast(new_state)
        Logger.error("Invalid JSON data received from Python service")
        {:noreply, new_state}
    end
  end

  def handle_info({:tcp, _socket, data}, state) do
    Logger.warning("Received TCP message from unknown socket")
    {:noreply, state}
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
    Logger.warning("TCP connection closed. Retrying...")
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

    connect()
    Logger.error("TCP error encountered: #{inspect(reason)}")
    {:noreply, new_state}
  end

  def handle_call({:fetch_data, _data}, _from, %{connected: false} = state) do
    Logger.warning("Trying to fetch_data while not connected to Python service")

    {:reply, %{"status" => "error", "message" => "Not connected to Python service"}, state}
  end

  def handle_call({:fetch_data, data}, _from, %{connected: true, socket: socket} = state) do
    Logger.info("Fetching data..")

    request = Jason.encode!(%{command: "fetch_data", data: data})
    :gen_tcp.send(socket, request <> "\n")

    {:reply, %{"status" => "fetching", "message" => "Request sent to fetch"}, state}
  end

  def handle_call({:fetch_data, _data}, _from, %{connected: false} = state) do
    {:reply, %{"status" => "error", "message" => "Not connected to Python service"}, state}
  end

  def handle_call(:get_state, _from, state) do
    attrs = %{
      status: state.status,
      message: state.message,
      data: state.data,
      tcp_status: state.tcp_status,
      tcp_message: state.tcp_message
    }

    {:reply, attrs, state}
  end

  defp connect_to_ads(socket, request) do
    encoded_request =
      %{
        ams_net_id: @ams_net_id,
        ams_port: @ams_port
      }
      |> Map.merge(request)
      |> Jason.encode!()

    case :gen_tcp.send(socket, encoded_request <> "\n") do
      :ok ->
        :ok

      {:error, reason} ->
        Logger.error("Failed to send ADS request: #{inspect(reason)}")
    end
  end

  defp handle_routing_key(
         _socket,
         "connect",
         %{"status" => "connected", "message" => message},
         state
       ) do
    new_state = %{state | connected: true, status: "connected", message: message}
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
    new_state = %{state | connected: false, message: error_message}
    broadcast(new_state)
    Logger.error("Error during connection: #{error_message}")
    {:noreply, new_state}
  end

  defp handle_routing_key(_socket, "fetch_data", %{"message" => message, "data" => data}, state) do
    new_state = %{state | message: message, data: data}
    Scada.DataManager.store_data(data)
    broadcast(new_state)
    Logger.info("Fetch data response: #{message}, data: #{inspect(data)}")
    {:noreply, new_state}
  end

  defp handle_routing_key(_socket, "fetch_data", %{"message" => message}, state) do
    Logger.error("Fetch data failing: #{message}")

    if String.contains?(message, "ADS Server not started (6)") do
      new_state = %{
        state
        | connected: false,
          status: "Not connected",
          message: message,
          data: nil
      }

      connect()
      broadcast(new_state)
      {:noreply, new_state}
    else
      new_state = %{state | message: message, data: nil}
      broadcast(new_state)
      {:noreply, new_state}
    end
  end

  defp handle_routing_key(_socket, _unknown_key, %{"message" => message}, state) do
    new_state = %{state | status: "error", message: "Unhandled routing key: #{message}"}
    broadcast(new_state)
    Logger.warning("Unhandled routing key: #{message}")
    {:noreply, new_state}
  end

  defp connect do
    Process.send_after(self(), :connect, @retry_interval)
  end

  defp start_python_script do
    spawn(fn ->
      System.cmd("python", [@ads_service])
      Logger.info("Python script started for ADS service")
    end)
  end

  defp broadcast(state) do
    attrs = %{
      status: state.status,
      message: state.message,
      data: state.data,
      tcp_status: state.tcp_status,
      tcp_message: state.tcp_message
    }

    Phoenix.PubSub.broadcast(
      Scada.PubSub,
      "connection_status",
      attrs
    )
  end
end
