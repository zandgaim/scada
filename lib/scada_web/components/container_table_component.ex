defmodule ScadaWeb.Components.ContainerTableComponent do
  use ScadaWeb, :live_component

  def render(assigns) do
    ~H"""
    <div
      id="container-overlay"
      phx-click="hide_table"
      phx-target={@myself}
      class="fixed inset-0 right-0 bg-black bg-opacity-40 z-40 flex justify-end transition-opacity duration-300"
    >
      <div
        phx-click="stop-propagation"
        phx-target={@myself}
        class="relative h-full w-1/3 bg-gray-900 p-6 rounded-l-2xl shadow-2xl"
      >
        <div class="flex justify-between items-center border-b border-gray-700 pb-4">
          <h2 class="text-2xl font-semibold text-white">
            <%= id_to_title(@container_name) %>
          </h2>

          <button phx-click="hide_table" phx-target={@myself} class="text-white text-2xl">
            ✖
          </button>
        </div>

        <div class="flex gap-2 my-4">
          <button
            phx-click="switch_view"
            phx-target={@myself}
            phx-value-mode="view"
            class={"px-4 py-2 rounded " <> if @config_mode, do: "bg-blue-600 text-white", else: "bg-gray-600 text-gray-300"}
            disabled={!@config_mode}
          >
            View
          </button>

          <button
            phx-click="switch_view"
            phx-target={@myself}
            phx-value-mode="config"
            class={"px-4 py-2 rounded " <> if @config_mode, do: "bg-gray-600 text-gray-300", else: "bg-blue-600 text-white"}
            disabled={@config_mode}
          >
            Config
          </button>
        </div>

        <!-- DATA TABLE -->
        <div class="overflow-y-auto max-h-[75vh]">
          <table class="w-full text-white">
            <thead>
              <tr>
                <th class="py-2 px-4 text-left">Label</th>
                <th class="py-2 px-4 text-left">Value</th>
              </tr>
            </thead>
            <tbody>
              <%= for {label, key, unit, value} <- @items do %>
                <tr class="border-b border-gray-700">
                  <td class="py-2 px-4 text-gray-300"><%= label %></td>

                  <td class="py-2 px-4">
                    <%= if @config_mode do %>
                      <input type="text"
                        phx-change="edit_value"
                        phx-target={@myself}
                        phx-value-key={key}
                        value={Map.get(@edited_values, key, value)}
                        class="bg-gray-800 text-white border border-gray-600 p-1 rounded w-full"
                      />
                    <% else %>
                      <span><%= value %> <%= unit %></span>
                    <% end %>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>

        <!-- SAVE BUTTON (Only in Config Mode) -->
        <%= if @config_mode do %>
          <button phx-click="save_values" phx-target={@myself} class="mt-4 px-4 py-2 bg-blue-600 text-white rounded">
            Save
          </button>
        <% end %>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
     assign(socket,
       container_name: assigns.container_name,
       items: assigns.items,
       config_mode: false,
       edited_values: %{}
     )}
  end

  def handle_event("switch_view", %{"mode" => "view"}, socket) do
    {:noreply, assign(socket, config_mode: false)}
  end

  def handle_event("switch_view", %{"mode" => "config"}, socket) do
    {:noreply, assign(socket, config_mode: true)}
  end

  def handle_event("edit_value", %{"key" => key, "value" => value}, socket) do
    edited_values = Map.put(socket.assigns.edited_values, key, value)
    {:noreply, assign(socket, edited_values: edited_values)}
  end

  def handle_event("save_values", _, socket) do
    # send(self(), {:update_values, socket.assigns.edited_values})
    {:noreply, socket}
  end

  def handle_event("hide_table", _, socket) do
    send(self(), {:hide_table})
    {:noreply, socket}
  end

  def handle_event("stop-propagation", _, socket) do
    {:noreply, socket}
  end

  defp id_to_title(str) do
    str |> String.replace("_", " ")
  end
end
