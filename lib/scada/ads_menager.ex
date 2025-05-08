defmodule Scada.ADSMenager do
  use GenServer
  require Logger

  alias Scada.DataManager
  alias Scada.PubSub

  @scada_transport "scada_pub_sub"
  @scada_status :scada_status
  @set_data_status :set_data_status

  @tcp_host Application.compile_env(:scada, :tcp_host)
  @tcp_port Application.compile_env(:scada, :tcp_port)
  @ads_service Application.compile_env(:scada, :ads_service)
  @ams_net_id Application.compile_env(:scada, :ams_net_id)
  @ams_port Application.compile_env(:scada, :ams_port)
  @target_ip Application.compile_env(:scada, :target_ip)
  @sender_ams Application.compile_env(:scada, :sender_ams)
  @plc_username Application.compile_env(:scada, :plc_username)
  @plc_password Application.compile_env(:scada, :plc_password)
  @route_name Application.compile_env(:scada, :route_name)
  @hostname Application.compile_env(:scada, :hostname)

  @retry_interval 10_000

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def fetch_data(fields) do
    GenServer.call(__MODULE__, {:fetch_data, fields})
  end

  def set_data(data) do
    GenServer.cast(__MODULE__, {:set_data, data})
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
      tcp_message: "",
      tcp_buffer: ""
    }

    broadcast(@scada_status, state)
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

  def handle_info({:tcp, socket, data}, %{tcp_buffer: buffer} = state) do
    new_buffer = buffer <> data
    {decoded_messages, remaining_buffer} = extract_complete_chunks(new_buffer)

    case decoded_messages do
      [] ->
        {:noreply, %{state | tcp_buffer: remaining_buffer}}

      messages ->
        case Jason.decode(messages) do
          {:ok, %{"routing_key" => routing_key} = response} ->
            {:noreply,
             handle_routing_key(socket, routing_key, response, %{
               state
               | tcp_buffer: remaining_buffer
             })}

          {:error, reason} ->
            updated_state = %{state | message: "Invalid data from Python service", tcp_buffer: ""}
            broadcast(@scada_status, updated_state)
            Logger.error("JSON decoding error: #{inspect(reason)} | Data: #{messages}")
            {:noreply, updated_state}
        end
    end
  end

  def handle_info({:tcp, _socket, _data}, state) do
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

    broadcast(@scada_status, new_state)
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

  def handle_call({rout, _data}, _from, %{connected: false} = state) do
    Logger.warning("Trying to #{rout} while not connected to Python service")

    {:reply, %{"status" => "error", "message" => "Not connected to Python service"}, state}
  end

  def handle_call({:fetch_data, data}, _from, %{connected: true, socket: socket} = state) do
    tcp_send(socket, "fetch_data", data)

    {:reply, %{"status" => "fetching", "message" => "Request sent to fetch"}, state}
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

  def handle_cast({:set_data, data}, %{connected: true, socket: socket} = state) do
    Logger.info("Setting data..")
    tcp_send(socket, "set_data", data)

    {:noreply, state}
  end

  def handle_cast({:set_data, _data}, %{connected: false, socket: _socket} = state) do
    Logger.info("Trying to set_data while not connected to Python service")
    broadcast(@set_data_status, "⚠️ Not connected to Python service")
    {:noreply, state}
  end

  defp handle_routing_key(
         _socket,
         "connect",
         %{"status" => "connected", "message" => message},
         state
       ) do
    new_state = %{state | connected: true, status: "Connected", message: message}
    broadcast(@scada_status, new_state)
    Logger.info("Connection established successfully: #{message}")
    new_state
  end

  defp handle_routing_key(
         _socket,
         "connect",
         %{"status" => "error", "message" => error_message},
         state
       ) do
    new_state = %{state | connected: false, message: error_message}
    broadcast(@scada_status, new_state)
    Logger.error("Error during connection: #{error_message}")
    new_state
  end

  defp handle_routing_key(_socket, "fetch_data", %{"message" => message, "data" => data}, state) do
    new_state = %{state | message: message, data: data}
    DataManager.store_data(data)
    broadcast(@scada_status, new_state)
    # Logger.info("Fetch data response: #{message}, data: #{inspect(data)}")
    new_state
  end

  defp handle_routing_key(_socket, "fetch_data", %{"message" => message}, state) do
    Logger.error("Fetch data failing: #{message}")

    if String.contains?(message, "ADS Server not started (6)") do
      new_state = %{
        state
        | connected: false,
          status: "Not connected",
          data: nil
      }

      connect()
      broadcast(@scada_status, new_state)
      new_state
    else
      new_state = %{state | data: nil}
      broadcast(@scada_status, new_state)
      new_state
    end
  end

  defp handle_routing_key(_socket, "set_data", %{"message" => message, "data" => data}, state) do
    broadcast(@set_data_status, {message, data})
    state
  end

  defp handle_routing_key(_socket, "set_data", %{"message" => message}, state) do
    broadcast(@set_data_status, message)
    state
  end

  defp handle_routing_key(_socket, key, %{"message" => message}, state) do
    Logger.error("Unknown routing key received: #{key}. Message: #{message}")

    new_state = %{
      state
      | status: "error",
        message: "Unknown command: #{key}"
    }

    broadcast(@scada_status, new_state)
    {:noreply, new_state}
  end

  defp connect_to_ads(socket, request) do
    encoded_request =
      %{
        ams_net_id: @ams_net_id,
        ams_port: @ams_port,
        target_ip: @target_ip,
        sender_ams: @sender_ams,
        plc_username: @plc_username,
        plc_password: @plc_password,
        route_name: @route_name,
        hostname: @hostname
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

  defp connect do
    Logger.info("Retrying connection in #{@retry_interval / 1000} seconds...")
    Process.send_after(self(), :connect, @retry_interval)
  end

  defp start_python_script do
    spawn(fn ->
      System.cmd("python", [@ads_service])
      Logger.info("Python script started for ADS service")
    end)
  end

  defp tcp_send(socket, command, data) do
    message = Jason.encode!(%{command: command, data: data}) <> "\n"
    :gen_tcp.send(socket, message)
  end

  defp broadcast(@scada_status, state) do
    attrs = %{
      status: state.status,
      message: state.message,
      data: state.data,
      tcp_status: state.tcp_status,
      tcp_message: state.tcp_message
    }

    Phoenix.PubSub.broadcast(
      PubSub,
      @scada_transport,
      {@scada_status, attrs}
    )
  end

  defp broadcast(@set_data_status, data) do
    Phoenix.PubSub.broadcast(
      PubSub,
      @scada_transport,
      {@set_data_status, data}
    )
  end

  defp extract_complete_chunks(buffer) do
    messages = String.split(buffer, "\n", trim: true)

    case List.pop_at(messages, -1) do
      {nil, _} ->
        {[], buffer}

      {last, rest} ->
        if String.ends_with?(buffer, "\n") do
          {messages, ""}
        else
          {rest, last}
        end
    end
  end
end
