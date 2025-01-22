defmodule ScadaWeb.Pages.ConnectionLive do
  use Phoenix.LiveView

  import Phoenix.Component

  alias Phoenix.PubSub
  alias ScadaWeb.Components.{ConnectionStatusComponent, ContainerComponent}

  def mount(_params, _session, socket) do
    PubSub.subscribe(Scada.PubSub, "connection_status")
    state = get_state()

    {:ok,
     assign(socket,
       status: state[:status],
       message: state[:message] || "Not connected to machine",
       tcp_status: state[:tcp_status] || "Not established",
       tcp_message: state[:tcp_message] || "",
       data: state[:data] || nil,
       field_name: "",
       last_status: nil,
       last_message: nil,
       form_data: %{"field_name" => ""},
       containers: get_containers(),
       fetch_interval: "2"
     )}
  end

  def render(assigns) do
    ~H"""
    <div
      id="connection-status"
      class="flex flex-col min-h-screen bg-gradient-to-b from-gray-600 to-gray-300"
    >
      <!-- Header -->
      <header class="w-full bg-teal-700 text-white p-4 flex justify-between items-center shadow-md">
        <h1 class="text-xl font-bold">SCADA Web</h1>

        <div class="flex items-center space-x-3">
          <label for="fetch_interval" class="text-sm font-medium">Fetch Interval:</label>
          <form phx-change="update_interval">
            <select
              id="fetch_interval"
              name="fetch_interval"
              class="bg-teal-600 text-white rounded-md pl-3 pr-8 py-1 border border-teal-500 focus:outline-none focus:ring-2 focus:ring-white focus:border-white appearance-none"
            >
              <option value="1" selected={@fetch_interval == "1"}>1s</option>

              <option value="2" selected={@fetch_interval == "2"}>2s</option>

              <option value="5" selected={@fetch_interval == "5"}>5s</option>
            </select>
          </form>
        </div>
      </header>
      
    <!-- Main Content -->
      <main class="flex flex-col items-center mt-4 px-6">
        <!-- Status Section -->
        <section class="bg-white w-full max-w-screen-xl p-6 rounded-lg shadow-md text-center">
          <div class="flex flex-col items-center">
            <div class="flex items-center space-x-4">
              <div class={"rounded-full w-4 h-4 " <> status_color(@status)}></div>

              <h2 class="text-2xl font-semibold">Connection Status: {@status}</h2>
            </div>

            <p class="text-lg text-gray-600 mt-2">{@message}</p>
          </div>
          
    <!-- TCP Status and Message -->
          <div class="mt-6 p-4 bg-gray-50 rounded-lg shadow-inner border-t">
            <h3 class="text-md font-semibold text-teal-700">TCP Details</h3>

            <p class="text-sm text-gray-700 mt-1"><strong>Status:</strong> {@tcp_status}</p>

            <p class="text-sm text-gray-700"><strong>Message:</strong> {@tcp_message}</p>
          </div>
        </section>
        
    <!-- Form Section -->
        <%!-- <section class="bg-white w-full max-w-screen-xl p-6 mt-6 rounded-lg shadow-md text-center">
          <.form
            for={@form_data}
            phx-submit="fetch_data"
            class="flex flex-col sm:flex-row items-center justify-center gap-4"
          >
            <!-- Field Name Input -->
            <div class="flex flex-col text-left w-full sm:w-auto">
              <label for="field_name" class="block text-gray-700 font-medium mb-2">
                Enter Field Name:
              </label>
              <input
                type="text"
                id="field_name"
                name="field_name"
                value={@form_data["field_name"]}
                placeholder="e.g., field1, field2"
                phx-change="validate_field"
                class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-teal-500 w-full sm:w-64"
              />
            </div>

            <!-- Query Button -->
            <button
              type="submit"
              class="bg-teal-700 hover:bg-teal-800 text-white font-semibold px-6 py-2 rounded-lg transition duration-300"
            >
              Query
            </button>
          </.form>
        </section> --%>
        
    <!-- Containers -->
        <.live_component id="containers_main" module={ContainerComponent} containers={@containers} />
      </main>
    </div>
    """
  end

  defp status_color("Connected"), do: "bg-green-500"
  defp status_color("Disconnected"), do: "bg-red-500"
  defp status_color(_), do: "bg-yellow-500"

  def handle_event("validate_field", %{"field_name" => field_name}, socket) do
    {:noreply, assign(socket, field_name: field_name)}
  end

  def handle_event("update_interval", %{"fetch_interval" => fetch_interval}, socket) do
    fetch_interval
    |> String.to_integer()
    |> Scada.DataManager.update_interval()

    {:noreply, assign(socket, fetch_interval: fetch_interval)}
  end

  def handle_event("fetch_data", %{"field_name" => field_name}, socket) do
    if field_name != "" do
      field_list =
        field_name
        |> String.split(",")
        |> Enum.map(&String.trim/1)

      Scada.PythonPort.fetch_data(field_list)

      {:noreply, assign(socket, message: "Fetching data...")}
    else
      {:noreply, assign(socket, message: "Field name cannot be empty.")}
    end
  end

  def handle_info({:update_containers, containers}, socket) do
    {:noreply, assign(socket, containers: containers)}
  end

  def handle_info(state, socket) do
    {:noreply,
     assign(socket,
       status: state.status,
       message: state.message,
       last_status: state.status,
       last_message: state.message,
       data: state.data,
       tcp_status: state.tcp_status,
       tcp_message: state.tcp_message
     )}
  end

  defp get_state do
    Scada.PythonPort.get_state()
  end

  defp get_containers do
    Scada.ContainersData.get_containers()
    |> Enum.reduce(%{}, fn %{title: title} = map, acc ->
      Map.put(acc, title, Map.delete(map, :title))
    end)
  end
end
