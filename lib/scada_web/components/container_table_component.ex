defmodule ScadaWeb.ContainerTableComponent do
  use ScadaWeb, :live_component

  def render(assigns) do
    ~H"""
    <div
      id="container-overlay"
      phx-click="hide_table"
      phx-target={@myself}
      class="fixed inset-0 right-3 bg-black bg-opacity-40 z-40 flex justify-end transition-opacity duration-300"
      onwheel="if (event.ctrlKey) { event.preventDefault(); }"
    >
      <!-- Sidebar Panel -->
      <div
        phx-click="stop-propagation"
        phx-target={@myself}
        class="relative h-full w-1/3 bg-gray-900 bg-opacity-90 shadow-2xl backdrop-blur-lg
                  transition-transform transform translate-x-0 p-6 rounded-l-2xl z-50"
      >
        <!-- Header -->
        <div class="flex justify-between items-center border-b border-gray-700 pb-4">
          <h2 class="text-2xl font-semibold text-white">
            {id_to_title(@container_name)}
          </h2>
          <button
            phx-click="hide_table"
            phx-target={@myself}
            class="text-gray-400 hover:text-white transition duration-300
         text-2xl p-2 rounded-full hover:bg-gray-700"
            style="color: white;"
          >
            ✖
          </button>
        </div>
        
    <!-- Table Content -->
        <div class="mt-4 overflow-y-auto max-h-[75vh] custom-scrollbar">
          <table class="w-full text-white border-collapse">
            <thead class="bg-gray-800 text-gray-300">
              <tr>
                <th class="py-3 px-4 text-left">Label</th>
                <th class="py-3 px-4 text-left">Value</th>
              </tr>
            </thead>
            <tbody>
              <%= for {label, _, unit, value} <- @items do %>
                <tr class="border-b border-gray-700 hover:bg-gray-800 transition duration-200">
                  <td class="py-3 px-4 text-gray-300">{label}</td>
                  <td class="py-3 px-4 text-gray-100 font-medium">{value || "N/A"} {unit}</td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("hide_table", _, socket) do
    send(self(), {:hide_table})
    {:noreply, socket}
  end

  def handle_event("stop-propagation", _, socket) do
    {:noreply, socket}
  end

  defp id_to_title(str) do
    str
    |> String.replace("_", " ")
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
