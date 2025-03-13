defmodule ScadaWeb.Pages.HistoricalDataLive do
  use Phoenix.LiveView
  import Phoenix.Component

  alias Scada.DataFetcher

  def mount(_params, _session, socket) do
    container_titles = DataFetcher.list_container_titles()
    parameters = DataFetcher.list_parameters()

    {:ok,
     assign(socket,
       current_tab: "historical_data",
       container_title: "",
       item_key: "",
       from_time: nil,
       to_time: DateTime.utc_now(),
       limit: "100",
       historical_data: nil,
       container_titles: container_titles,
       parameters: parameters,
       form_data: %{"container_title" => "", "item_key" => "", "limit" => "100"}
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col min-h-screen bg-gradient-to-b from-gray-300 to-gray-200">
      <header class="w-full bg-gray-700 text-white p-4 flex justify-between items-center shadow-md">
        <h1 class="text-xl font-bold">SCADA Web</h1>
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
      </header>
      <main class="flex flex-col items-center mt-4 px-6">
        <section class="bg-white w-full max-w-screen-xl p-6 mt-6 rounded-lg shadow-md text-center">
          <.form
            for={@form_data}
            phx-submit="fetch_historical_data"
            class="flex flex-col sm:flex-row items-center justify-center gap-4"
          >
            <div class="flex flex-col text-left w-full sm:w-auto">
              <label for="container_title" class="block text-gray-700 font-medium mb-2">
                Container Title:
              </label>
              <select
                id="container_title"
                name="container_title"
                phx-change="update_container"
                class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-teal-500 w-full sm:w-64"
              >
                <option value="">Select a container</option>
                <%= for title <- @container_titles do %>
                  <option value={title} selected={@container_title == title}>{title}</option>
                <% end %>
              </select>
            </div>
            <div class="flex flex-col text-left w-full sm:w-auto">
              <label for="item_key" class="block text-gray-700 font-medium mb-2">Item Key:</label>
              <select
                id="item_key"
                name="item_key"
                phx-change="update_key"
                class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-teal-500 w-full sm:w-64"
              >
                <option value="">Select an item</option>
                <%= for param <- @parameters, param.container_title == @container_title do %>
                  <option value={param.key} selected={@item_key == param.key}>{param.key}</option>
                <% end %>
              </select>
            </div>
            <div class="flex flex-col text-left w-full sm:w-auto">
              <label for="limit" class="block text-gray-700 font-medium mb-2">Record Limit:</label>
              <input
                type="number"
                id="limit"
                name="limit"
                value={@form_data["limit"]}
                phx-change="update_limit"
                placeholder="e.g., 100"
                class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-teal-500 w-full sm:w-24"
              />
            </div>
            <button
              type="submit"
              class="bg-teal-700 hover:bg-teal-800 text-white font-semibold px-6 py-2 rounded-lg transition duration-300"
            >
              Fetch Data
            </button>
          </.form>
        </section>
        <%= if @historical_data do %>
          <section class="bg-white w-full max-w-screen-xl p-6 mt-6 rounded-lg shadow-md">
            <h2 class="text-xl font-semibold text-gray-700 mb-4">
              Historical Data for {@container_title} - {@item_key}
            </h2>
            <div class="w-full h-[400px] relative">
              <canvas id="historical-chart" phx-hook="ChartHook" class="absolute inset-0"></canvas>
            </div>
          </section>
        <% end %>
      </main>
    </div>
    """
  end

  def handle_event("update_container", %{"container_title" => container_title}, socket) do
    parameters = DataFetcher.list_parameters(container_title)

    {:noreply,
     assign(socket,
       container_title: container_title,
       item_key: "",
       parameters: parameters,
       historical_data: nil
     )}
  end

  def handle_event("update_key", %{"item_key" => item_key}, socket) do
    {:noreply, assign(socket, item_key: item_key)}
  end

  def handle_event("update_limit", %{"limit" => limit}, socket) do
    {:noreply, assign(socket, limit: limit)}
  end

  def handle_event(
        "fetch_historical_data",
        %{"container_title" => container_title, "item_key" => item_key, "limit" => limit},
        socket
      ) do
    if container_title != "" and item_key != "" do
      opts = [limit: String.to_integer(limit)]
      raw_data = DataFetcher.get_historical_data(container_title, item_key, opts)

      require Logger
      Logger.info("Fetched raw data for #{container_title} - #{item_key}: #{inspect(raw_data)}")

      # Reverse the data for correct order
      reversed_data = Enum.reverse(raw_data)

      chart_data = %{
        labels: Enum.map(reversed_data, &Calendar.strftime(&1.recorded_at, "%Y-%m-%d %H:%M")),
        values: Enum.map(reversed_data, & &1.value),
        label: "#{container_title} - #{item_key}"
      }

      Logger.info("Chart data: #{inspect(chart_data)}")

      socket =
        socket
        |> assign(historical_data: raw_data, container_title: container_title, item_key: item_key)
        |> push_event("update-chart", chart_data)

      {:noreply, socket}
    else
      {:noreply,
       assign(socket, historical_data: nil, container_title: container_title, item_key: item_key)}
    end
  end
end
