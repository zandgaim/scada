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
       status: state[:status] || "waiting",
       message: state[:message] || "Not connected to machine",
       tcp_status: state[:tcp_status] || "Not established",
       tcp_message: state[:tcp_message] || "",
       data: state[:data] || nil,
       field_name: "",
       last_status: nil,
       last_message: nil,
       form_data: %{"field_name" => ""},
       containers: get_containers()
     )}
  end

  def render(assigns) do
    ~H"""
    <div id="connection-status" class="flex flex-col items-center p-4 bg-gray-100 min-h-screen">
      <!-- Connection Status -->
      <.live_component
        module={ConnectionStatusComponent}
        id="connection_status"
        status={@status}
        message={@message}
        tcp_status={@tcp_status}
        tcp_message={@tcp_message}
      />
      
    <!-- Main Content -->
      <div class="w-full max-w-screen-xl mt-16 bg-white rounded-lg shadow-md p-6 text-center">
        <!-- Field Input Form -->
        <.form
          for={@form_data}
          phx-submit="fetch_data"
          class="flex flex-col sm:flex-row items-center justify-center gap-4"
        >
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
          <button
            type="submit"
            class="bg-teal-700 hover:bg-teal-800 text-white font-semibold px-6 py-2 rounded-lg transition duration-300"
          >
            Query
          </button>
        </.form>
        
    <!-- Data Display Section -->
        <div class="mt-6">
          <%= if @data do %>
            <ul class="space-y-2 text-gray-700">
              <%= for {key, value} <- @data do %>
                <li class="flex justify-between border-b pb-1">
                  <span class="font-semibold">{key}:</span> <span>{value}</span>
                </li>
              <% end %>
            </ul>
          <% else %>
            <p class="text-gray-500 italic">No data available</p>
          <% end %>
        </div>
        
    <!-- Containers -->
        <div class="grid grid-cols-4 gap-6 relative mt-8">
          <%= for container <- @containers do %>
            <.live_component
              module={ContainerComponent}
              id={container.title |> String.downcase() |> String.replace(" ", "_")}
              title={container.title}
              status_indicator={container.status_indicator}
              items={container.items}
            />
          <% end %>
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

  defp get_state do
    Scada.PythonPort.get_state()
  end

  defp get_containers do
    Scada.Containers.get_containers()
  end
end
