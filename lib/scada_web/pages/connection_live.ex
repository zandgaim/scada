defmodule ScadaWeb.Pages.ConnectionLive do
  use Phoenix.LiveView
  alias Phoenix.PubSub

  def mount(_params, _session, socket) do
    # Subscribe to connection_status topic for updates from PythonPort
    PubSub.subscribe(Scada.PubSub, "connection_status")

    # Initialize connection state with a default message and empty field input
    {:ok,
     assign(socket,
       status: "waiting",
       message: "Not connected to machine",
       field_name: "",
       last_status: nil,
       last_message: nil,
       data: nil,
       tcp_status: "Not established",
       tcp_message: ""
     )}
  end

  def render(assigns) do
    ~L"""
    <div id="connection-status" class="flex flex-col items-center p-4 bg-gray-100 min-h-screen">
      <!-- Header -->
      <header class="w-full bg-teal-700 text-white text-center py-6 shadow-lg rounded-lg">
        <h2 class="text-2xl font-semibold">Connection Status: <%= @status %></h2>
        <p class="text-lg text-gray-300 mt-1"><%= @message %></p>

        <!-- TCP Status and Message Section -->
        <div class="mt-4 p-4 bg-teal-800 rounded-lg shadow-md">
          <p class="text-sm font-semibold text-teal-100">TCP Status:</p>
          <p class="text-sm text-teal-200"><%= @tcp_status %></p>
        </div>
      </header>

      <!-- Main Content -->
      <div class="w-full max-w-screen-xl mt-16 bg-white rounded-lg shadow-md p-6 text-center">
        <!-- Field Input Form -->
        <form phx-submit="fetch_data" class="flex flex-col sm:flex-row items-center justify-center gap-4">
          <div class="flex flex-col text-left w-full sm:w-auto">
            <label for="field_name" class="block text-gray-700 font-medium mb-2">Enter Field Name:</label>
            <input type="text"
                   id="field_name"
                   name="field_name"
                   phx-change="validate_field"
                   value="<%= @field_name %>"
                   placeholder="e.g., field1, field2"
                   class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-teal-500 w-full sm:w-64" />
          </div>
          <button type="submit"
                  class="bg-teal-700 hover:bg-teal-800 text-white font-semibold px-6 py-2 rounded-lg transition duration-300">
            Query
          </button>
        </form>

        <!-- Data Display Section -->
        <div class="mt-6">
          <%= if @data do %>
            <ul class="space-y-2 text-gray-700">
              <%= for {key, value} <- @data do %>
                <li class="flex justify-between border-b pb-1">
                  <span class="font-semibold"><%= key %>:</span>
                  <span><%= value %></span>
                </li>
              <% end %>
            </ul>
          <% else %>
            <p class="text-gray-500 italic">No data available</p>
          <% end %>
        </div>

        <div class="relative bg-gray-900 text-white p-4 rounded-lg">
          <!-- Container for the grid layout -->
          <div class="grid grid-cols-4 gap-6 relative">
            <!-- Weather Station -->
            <div class="bg-gray-800 p-4 rounded-lg shadow-md relative">
              <h3 class="text-lg font-semibold mb-2">Stacja pogodowa</h3>
              <ul class="text-sm">
                <li>Prędkość wiatru: <span class="font-bold">0m/s</span></li>
                <li>Śr. prędkość wiatru: <span class="font-bold">0.1m/s</span></li>
                <li>Kierunek wiatru: <span class="font-bold">0°</span></li>
                <li>Śr. kierunek wiatru: <span class="font-bold">5°</span></li>
                <li>Temperatura: <span class="font-bold">25.3°C</span></li>
              </ul>
            </div>

            <!-- PV Section -->
            <div class="bg-gray-800 p-4 rounded-lg shadow-md relative">
              <h3 class="text-lg font-semibold mb-2">PV</h3>
              <ul class="text-sm">
                <li>Napięcie: <span class="font-bold">760V</span></li>
                <li>Moc 1: <span class="font-bold">8kW</span></li>
                <li>Moc 2: <span class="font-bold">7kW</span></li>
                <li>Moc 3: <span class="font-bold">0kW</span></li>
              </ul>
              <!-- Horizontal line -->
              <div class="absolute left-1/2 top-full w-0.5 h-6 bg-gray-500"></div>
              <!-- <div class="absolute left-full top-1/2 w-6 h-0.5 bg-gray-500"></div> -->
            </div>

            <!-- Battery Li-Ion -->
            <div class="bg-gray-800 p-4 rounded-lg shadow-md relative">
              <h3 class="text-lg font-semibold mb-2">Bateria Li-Ion</h3>
              <ul class="text-sm">
                <li>Naładowanie: <span class="font-bold">93%</span></li>
                <li>Moc: <span class="font-bold">15kW</span></li>
                <li>Napięcie zmienne: <span class="font-bold">488V</span></li>
                <li>Temperatura: <span class="font-bold">70°C</span></li>
              </ul>
              <!-- Line extending downward -->
              <div class="absolute left-1/2 top-full w-0.5 h-6 bg-gray-500"></div>
            </div>

            <!-- Battery AGM -->
              <div class="bg-gray-800 p-4 rounded-lg shadow-md relative">
              <h3 class="text-lg font-semibold mb-2">Bateria AGM</h3>
              <ul class="text-sm">
                <li>Naładowanie: <span class="font-bold">93%</span></li>
                <li>Moc: <span class="font-bold">15kW</span></li>
                <li>Napięcie zmienne: <span class="font-bold">488V</span></li>
                <li>Temperatura: <span class="font-bold">70°C</span></li>
              </ul>
              <!-- Line extending downward -->
              <div class="absolute left-1/2 top-full w-0.5 h-6 bg-gray-500"></div>
            </div>

            <!-- Weather Station -->
            <div class="bg-gray-800 p-4 rounded-lg shadow-md relative">
              <h3 class="text-lg font-semibold mb-2">Stacja pogodowa</h3>
              <ul class="text-sm">
                <li>Prędkość wiatru: <span class="font-bold">0m/s</span></li>
                <li>Śr. prędkość wiatru: <span class="font-bold">0.1m/s</span></li>
                <li>Kierunek wiatru: <span class="font-bold">0°</span></li>
                <li>Śr. kierunek wiatru: <span class="font-bold">5°</span></li>
                <li>Temperatura: <span class="font-bold">25.3°C</span></li>
              </ul>
              <!-- Line extending downwards -->
              <div class="absolute left-1/2 top-full w-0.5 h-6 bg-gray-500"></div>
            </div>

            <!-- DC przekształtnik 1 -->
            <div class="bg-gray-800 p-4 rounded-lg shadow-md relative">
              <h3 class="text-lg font-semibold mb-2">Przekształtnik DC</h3>
              <ul class="text-sm">
                <li>Napięcie: <span class="font-bold">760V</span></li>
                <li>Moc 1: <span class="font-bold">8kW</span></li>
                <li>Moc 2: <span class="font-bold">7kW</span></li>
                <li>Moc 3: <span class="font-bold">0kW</span></li>
              </ul>
              <!-- Horizontal line -->
              <div class="absolute left-1/2 top-full w-0.5 h-6 bg-gray-500"></div>
              <!-- <div class="absolute left-full top-1/2 w-6 h-0.5 bg-gray-500"></div> -->
            </div>

            <!-- DC przekształtnik 2 -->
              <div class="bg-gray-800 p-4 rounded-lg shadow-md relative">
              <h3 class="text-lg font-semibold mb-2">Przekształtnik DC</h3>
              <ul class="text-sm">
                <li>Napięcie: <span class="font-bold">760V</span></li>
                <li>Moc 1: <span class="font-bold">8kW</span></li>
                <li>Moc 2: <span class="font-bold">7kW</span></li>
                <li>Moc 3: <span class="font-bold">0kW</span></li>
              </ul>
              <!-- Horizontal line -->
              <div class="absolute left-1/2 top-full w-0.5 h-6 bg-gray-500"></div>
              <!-- <div class="absolute left-full top-1/2 w-6 h-0.5 bg-gray-500"></div> -->
            </div>

            <!-- Rozdzielnica RG1 -->
            <div class="bg-gray-800 p-4 rounded-lg shadow-md relative">
              <h3 class="text-lg font-semibold mb-2">Rozdzielnica RG1</h3>
              <ul class="text-sm">
                <li>Temperatura: <span class="font-bold">42°C</span></li>
                <li>Wentylacja: <span class="font-bold">30%</span></li>
                <li>Radiator: <span class="font-bold">200RPM</span></li>
                <li>Potrzeby własne: <span class="font-bold">3kWh</span></li>
              </ul>
              <!-- Horizontal line -->
              <div class="absolute left-1/2 top-full w-0.5 h-6 bg-gray-500"></div>
              <!-- <div class="absolute left-full top-1/2 w-6 h-0.5 bg-gray-500"></div> -->
            </div>

        </div>

      </div>
    </div>
    """
  end

  def handle_event("validate_field", %{"field_name" => field_name}, socket) do
    {:noreply, assign(socket, field_name: field_name)}
  end

  def handle_event("fetch_data", %{"field_name" => field_name}, socket) do
    if field_name != "" do
      # Split the field_name string by commas and trim any extra spaces
      field_list =
        field_name
        |> String.split(",")
        |> Enum.map(&String.trim/1)

      # Call the fetch_data function with the list of fields
      Scada.PythonPort.fetch_data(field_list)

      {:noreply, assign(socket, message: "Fetching data...")}
    else
      {:noreply, assign(socket, message: "Field name cannot be empty.")}
    end
  end

  def handle_info(
        %{
          :status => status,
          :message => message,
          :data => data,
          :tcp_status => tcp_status,
          :tcp_message => tcp_message
        },
        socket
      ) do
    # Prevent unnecessary state updates
    {:noreply,
     assign(socket,
       status: status,
       message: message,
       last_status: status,
       last_message: message,
       data: data,
       tcp_status: tcp_status,
       tcp_message: tcp_message
     )}
  end
end
