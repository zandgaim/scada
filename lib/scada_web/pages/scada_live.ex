defmodule ScadaWeb.Pages.ScadaLive do
  use Phoenix.LiveView

  import Phoenix.Component

  alias Phoenix.PubSub

  alias Scada.ContainersData
  alias Scada.DataManager
  alias Scada.Ads.AdsMenager

  alias ScadaWeb.Components.{
    ConnectionStatusComponent,
    ContainerComponent,
    ContainerTableComponent
  }

  @scada_transport "scada_pub_sub"
  @update_containers :update_containers
  @scada_status :scada_status
  @set_data_status :set_data_status

  def mount(_params, _session, socket) do
    PubSub.subscribe(Scada.PubSub, @scada_transport)
    state = get_state()

    {:ok,
     assign(socket,
       current_tab: "dashboard",
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
       selected_container: nil,
       fetch_interval: "2",
       selected_label: nil,
       config_mode: false,
       edited_values: %{},
       field_messages: %{},
       general_message: nil
     )}
  end

  def render(assigns) do
    ~H"""
    <div
      id="connection-status"
      class="flex flex-col min-h-screen bg-gradient-to-b from-gray-300 to-gray-200"
    >
      <header class="w-full bg-gray-700 text-white p-4 flex justify-between items-center shadow-md">
        <div class="flex items-center justify-between w-full">
          <h1 class="text-xl font-bold">SCADA Web</h1>

          <div class="flex items-center gap-6">
            <div class="flex items-center gap-2">
              <label for="fetch_interval" class="text-base">Fetch interva:</label>
              <form phx-change="update_interval">
                <select
                  id="fetch_interval"
                  name="fetch_interval"
                  class="bg-gray-600 text-white text-base rounded-md px-2 py-1 border border-gray-500 focus:outline-none focus:ring-2 focus:ring-white"
                >
                  <option value="1" selected={@fetch_interval == "1"}>1s</option>
                  <option value="2" selected={@fetch_interval == "2"}>2s</option>
                  <option value="5" selected={@fetch_interval == "5"}>5s</option>
                </select>
              </form>
            </div>

            <nav class="flex space-x-4">
              <a
                href="/"
                class={"text-white px-3 py-1 rounded-md #{if @current_tab == "dashboard", do: "bg-gray-500", else: "hover:bg-gray-600"}"}
              >
                Dashboard
              </a>

              <a
                href="/historical"
                class={"text-white px-3 py-1 rounded-md #{if @current_tab == "historical_data", do: "bg-gray-500", else: "hover:bg-gray-600"}"}
              >
                Historical Data
              </a>
            </nav>
          </div>
        </div>
      </header>

    <!-- Main Content -->
      <main class="flex flex-col items-center mt-4 px-6">
        <!-- Status Section -->
        <.live_component
          id="scada_status"
          module={ConnectionStatusComponent}
          status={@status}
          message={@message}
          tcp_status={@tcp_status}
          tcp_message={@tcp_message}
        />

    <!-- Containers -->
        <.live_component id="containers_main" module={ContainerComponent} containers={@containers} />

        <%= if @selected_container do %>
          <.live_component
            module={ContainerTableComponent}
            id="container-table"
            container_name={@selected_container}
            items={@selected_items}
            field_messages={@field_messages}
            general_message={@general_message}
          />
        <% end %>
      </main>
    </div>
    """
  end

  def handle_event("show_table", %{"id" => container_id}, socket) do
    container_id = denormalize_id(container_id)
    items = Map.get(socket.assigns.containers, container_id, %{items: []}).items
    {:noreply, assign(socket, selected_container: container_id, selected_items: items)}
  end

  def handle_event("hide_table", _, socket) do
    {:noreply, assign(socket, selected_container: nil, selected_items: nil)}
  end

  def handle_event("validate_field", %{"field_name" => field_name}, socket) do
    {:noreply, assign(socket, field_name: field_name)}
  end

  def handle_event("update_interval", %{"fetch_interval" => fetch_interval}, socket) do
    fetch_interval
    |> String.to_integer()
    |> DataManager.update_interval()

    {:noreply, assign(socket, fetch_interval: fetch_interval)}
  end

  def handle_event("fetch_data", %{"field_name" => field_name}, socket) do
    if field_name != "" do
      field_list =
        field_name
        |> String.split(",")
        |> Enum.map(&String.trim/1)

      AdsMenager.fetch_data(field_list)

      {:noreply, assign(socket, message: "Fetching data...")}
    else
      {:noreply, assign(socket, message: "Field name cannot be empty.")}
    end
  end

  def handle_event("edit_data", %{"data" => data}, socket) do
    {key_with_unit, value} = Enum.at(data, 0)
    [key, unit] = String.split(key_with_unit, ":", parts: 2)

    new_data = %{key => {value, unit}}

    updated_values = Map.merge(socket.assigns.edited_values, new_data)

    {:noreply, assign(socket, edited_values: updated_values)}
  end

  def handle_event("set_data", _, socket) do
    data = socket.assigns.edited_values
    DataManager.set_data(data)

    {:noreply, assign(socket, edited_values: %{})}
  end

  def handle_info({@scada_status, attrs}, socket) do
    {:noreply,
     assign(socket,
       status: attrs.status,
       message: attrs.message,
       last_status: attrs.status,
       last_message: attrs.message,
       data: attrs.data,
       tcp_status: attrs.tcp_status,
       tcp_message: attrs.tcp_message
     )}
  end

  def handle_info({@update_containers, containers}, socket) do
    selected_items =
      case socket.assigns.selected_container do
        nil -> nil
        selected_container -> Map.get(containers, selected_container, %{items: []}).items
      end

    {:noreply, assign(socket, containers: containers, selected_items: selected_items)}
  end

  def handle_info({@set_data_status, message}, socket) do
    socket =
      case message do
        {status, details} ->
          updated_field_messages =
            Enum.reduce(details, socket.assigns.field_messages || %{}, fn {key, msg}, acc ->
              Map.put(acc, key, "#{status}: #{msg}")
            end)

          Process.send_after(self(), :clear_field_messages, 3000)

          socket
          |> assign(:field_messages, updated_field_messages)

        message ->
          Process.send_after(self(), :clear_general_message, 3000)

          socket
          |> assign(:general_message, message)
      end

    {:noreply, socket}
  end

  def handle_info(:clear_field_messages, socket) do
    {:noreply, assign(socket, :field_messages, %{})}
  end

  def handle_info(:clear_general_message, socket) do
    {:noreply, assign(socket, :general_message, nil)}
  end

  defp denormalize_id(title),
    do: title |> to_string() |> String.replace("_", " ")

  defp get_state do
    AdsMenager.get_state()
  end

  defp get_containers do
    ContainersData.get_containers()
    |> Enum.reduce(%{}, fn %{title: title} = map, acc ->
      Map.put(acc, title, Map.delete(map, :title))
    end)
  end
end
