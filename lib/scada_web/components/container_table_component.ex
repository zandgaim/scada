defmodule ScadaWeb.Components.ContainerTableComponent do
  use ScadaWeb, :live_component

  def render(assigns) do
    ~H"""
    <div
      id="container-overlay"
      phx-click="hide_table"
      class="fixed inset-0 right-0 bg-black bg-opacity-40 z-40 flex justify-end transition-opacity duration-300"
    >
      <div
        phx-click="stop-propagation"
        phx-target={@myself}
        class="relative h-full w-1/3 bg-gray-900 p-6 rounded-l-2xl shadow-2xl flex flex-col"
      >
        <!-- Header -->
        <div class="flex justify-between items-center border-b border-gray-700 pb-4">
          <h2 class="text-2xl font-semibold text-white">
            {id_to_title(@container_name)}
          </h2>
          
          <button phx-click="hide_table" class="text-white text-2xl hover:text-gray-300 transition">
            ✖
          </button>
        </div>
        
    <!-- Toggle View Buttons -->
        <div class="flex gap-2 my-4">
          <button
            phx-click="switch_view"
            phx-target={@myself}
            phx-value-mode="view"
            class={"px-4 py-2 rounded transition-colors " <> if @config_mode, do: "bg-blue-600 text-white", else: "bg-gray-600 text-gray-300 hover:bg-gray-500"}
            disabled={!@config_mode}
          >
            View
          </button>
          
          <button
            phx-click="switch_view"
            phx-target={@myself}
            phx-value-mode="config"
            class={"px-4 py-2 rounded transition-colors " <> if @config_mode, do: "bg-gray-600 text-gray-300 hover:bg-gray-500", else: "bg-blue-600 text-white"}
            disabled={@config_mode}
          >
            Config
          </button>
        </div>
        
    <!-- Scrollable Content -->
        <div class="flex-grow overflow-y-auto max-h-[70vh] border border-gray-700 rounded-lg p-4 bg-gray-800">
          <table class="w-full text-white">
            <thead>
              <tr>
                <th class="py-2 px-4 text-left font-semibold text-gray-200">Label</th>
                
                <th class="py-2 px-4 text-left font-semibold text-gray-200">Value</th>
              </tr>
            </thead>
            
            <tbody>
              <%= for {label, key, unit, value} <- @items do %>
                <%= cond do %>
                  <% @config_mode and String.contains?(key, "_set") -> %>
                    <tr class="border-b border-gray-700">
                      <td class="py-2 px-4 text-gray-300">{label}</td>
                      
                      <td class="py-2 px-4">
                        <form phx-change="edit_data" class="w-full">
                          <div class="flex items-center w-full">
                            <%= cond do %>
                              <% unit == "bool" -> %>
                                <div class="flex items-center space-x-2 w-full">
                                  <div class="flex w-3/4">
                                    <select
                                      name={"data[#{key}:#{unit}]"}
                                      class="w-full h-10 bg-gray-700 text-white border border-gray-600 rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                      phx-change="edit_data"
                                    >
                                      <option value="true" selected={to_string(value) == "true"}>
                                        true
                                      </option>
                                      
                                      <option value="false" selected={to_string(value) == "false"}>
                                        false
                                      </option>
                                    </select>
                                  </div>
                                   <span class="w-[2rem]"></span>
                                </div>
                              <% unit == "int" -> %>
                                <input
                                  type="number"
                                  name={"data[#{key}:#{unit}]"}
                                  phx-change="edit_data"
                                  value={Map.get(@edited_values, key, value)}
                                  class="w-4/5 h-10 bg-gray-700 text-white border border-gray-600 rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                  step="1"
                                />
                              <% unit == "string" -> %>
                                <input
                                  type="text"
                                  name={"data[#{key}:#{unit}]"}
                                  phx-change="edit_data"
                                  value={Map.get(@edited_values, key, value)}
                                  class="w-4/5 h-10 bg-gray-700 text-white border border-gray-600 rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                />
                              <% true -> %>
                                <div class="flex items-center space-x-2">
                                  <input
                                    type="number"
                                    name={"data[#{key}:double]"}
                                    phx-change="edit_data"
                                    value={Map.get(@edited_values, key, value)}
                                    class="w-full h-10 bg-gray-700 text-white border border-gray-600 rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                    step="0.1"
                                  />
                                  <span class="text-gray-400 text-sm font-medium w-12 text-center">
                                    {unit}
                                  </span>
                                </div>
                            <% end %>
                          </div>
                        </form>
                        <!-- Status Message Below the Field -->
                        <%= if Map.has_key?(@field_messages, key) do %>
                          <p class="mt-1 text-xs text-white-400 font-medium">
                            {@field_messages[key]}
                          </p>
                        <% end %>
                      </td>
                    </tr>
                  <% !@config_mode and String.contains?(key, "_read") -> %>
                    <tr class="border-b border-gray-700">
                      <td class="py-2 px-4 text-gray-300">{label}</td>
                      
                      <td class="py-2 px-4">
                        <span class="text-gray-200 font-medium">{value} {unit}</span>
                      </td>
                    </tr>
                  <% true -> %>
                    <tr></tr>
                <% end %>
              <% end %>
            </tbody>
          </table>
        </div>
        
    <!-- Save Button -->
        <%= if @config_mode do %>
          <div class="mt-4 flex items-center justify-between">
            <button
              phx-click="set_data"
              class="bg-blue-600 hover:bg-blue-700 text-white font-semibold px-4 py-2 rounded-lg shadow-md transition duration-300"
            >
              Save
            </button>
            
    <!-- Error message -->
            <%= if @general_message do %>
              <div class="ml-2 px-3 py-1 text-sm font-semibold rounded-lg bg-red-500 text-white max-w-[250px] truncate">
                {@general_message}
              </div>
            <% end %>
          </div>
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
       config_mode: socket.assigns[:config_mode] || false,
       edited_values: socket.assigns[:edited_values] || %{},
       field_messages: assigns[:field_messages] || %{},
       general_message: assigns[:general_message] || nil
     )}
  end

  def handle_event("switch_view", %{"mode" => "view"}, socket) do
    {:noreply, assign(socket, config_mode: false)}
  end

  def handle_event("switch_view", %{"mode" => "config"}, socket) do
    {:noreply, assign(socket, config_mode: true)}
  end

  def handle_event("stop-propagation", _, socket) do
    {:noreply, socket}
  end

  defp id_to_title(str) do
    str |> String.replace("_", " ")
  end
end
