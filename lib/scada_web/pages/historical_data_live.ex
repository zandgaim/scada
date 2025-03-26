defmodule ScadaWeb.Pages.HistoricalDataLive do
  use Phoenix.LiveView
  import Phoenix.Component

  alias Scada.DataFetcher

  @update_interval 5_000

  def mount(_params, _session, socket) do
    if connected?(socket),
      do: :timer.send_interval(@update_interval, self(), :fetch_historical_data)

    container_titles = DataFetcher.list_container_titles()
    parameters = DataFetcher.list_parameters()

    {:ok,
     assign(socket,
       current_tab: "historical_data",
       selections: [%{container_title: "", item_key: "", id: 1}],
       from_time: nil,
       to_time: DateTime.utc_now(),
       limit: "100",
       charts_data: [],
       container_titles: container_titles,
       parameters: parameters,
       form_data: %{"limit" => "100"}
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
          <.form for={@form_data} phx-submit="fetch_historical_data" class="space-y-6">
            <div class="space-y-4">
              <%= for selection <- @selections do %>
                <div
                  class="flex flex-col sm:flex-row items-center justify-center gap-4"
                  id={"selection-#{selection.id}"}
                >
                  <div class="flex flex-col text-left w-full sm:w-auto">
                    <label
                      for={"container_title_#{selection.id}"}
                      class="block text-gray-700 font-medium mb-2"
                    >
                      Container Title {selection.id}:
                    </label>
                    <select
                      id={"container_title_#{selection.id}"}
                      name={"container_title_#{selection.id}"}
                      phx-change="update_container"
                      phx-value-id={selection.id}
                      class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-teal-500 w-full sm:w-64"
                    >
                      <option value="">Select a container</option>
                      <%= for title <- @container_titles do %>
                        <option value={title} selected={selection.container_title == title}>
                          {title}
                        </option>
                      <% end %>
                    </select>
                  </div>
                  <div class="flex flex-col text-left w-full sm:w-auto">
                    <label
                      for={"item_key_#{selection.id}"}
                      class="block text-gray-700 font-medium mb-2"
                    >
                      Item Key {selection.id}:
                    </label>
                    <select
                      id={"item_key_#{selection.id}"}
                      name={"item_key_#{selection.id}"}
                      phx-change="update_key"
                      phx-value-id={selection.id}
                      class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-teal-500 w-full sm:w-64"
                    >
                      <option value="">Select an item</option>
                      <%= for param <- @parameters, param.container_title == selection.container_title do %>
                        <option value={param.key} selected={selection.item_key == param.key}>
                          {param.key}
                        </option>
                      <% end %>
                    </select>
                  </div>
                </div>
              <% end %>
              <%= if length(@selections) < 4 do %>
                <button
                  type="button"
                  phx-click="add_selection"
                  class="text-teal-700 hover:text-teal-800 font-semibold"
                >
                  + Add Another Chart
                </button>
              <% end %>
            </div>
            <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
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
            </div>
          </.form>
        </section>
        <%= if @charts_data != [] do %>
          <section class="bg-white w-full max-w-screen-xl p-6 mt-6 rounded-lg shadow-md">
            <h2 class="text-xl font-semibold text-gray-700 mb-4">Historical Data</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <%= for {chart_data, index} <- Enum.with_index(@charts_data) do %>
                <div class="w-full h-[400px] relative">
                  <h3 class="text-lg font-medium text-gray-600 mb-2">
                    {chart_data.container_title} - {chart_data.item_key}
                  </h3>
                  <canvas
                    id={"historical-chart-#{index}"}
                    phx-hook="ChartHook"
                    class="absolute inset-0"
                    data-chart={Jason.encode!(chart_data.chart)}
                  >
                  </canvas>
                </div>
              <% end %>
            </div>
          </section>
        <% end %>
      </main>
    </div>
    """
  end

  def handle_event("update_container", %{"_target" => target, "id" => id} = params, socket) do
    container_title = params[target]
    id = String.to_integer(id)

    selections =
      update_selection(socket.assigns.selections, id, :container_title, container_title)

    parameters = DataFetcher.list_parameters(container_title)

    {:noreply, assign(socket, selections: selections, parameters: parameters, charts_data: [])}
  end

  def handle_event("update_key", %{"_target" => target, "id" => id} = params, socket) do
    item_key = params[target]
    id = String.to_integer(id)
    selections = update_selection(socket.assigns.selections, id, :item_key, item_key)

    {:noreply, assign(socket, selections: selections)}
  end

  def handle_event("update_limit", %{"limit" => limit}, socket) do
    {:noreply, assign(socket, limit: limit)}
  end

  def handle_event("add_selection", _, socket) do
    new_id = length(socket.assigns.selections) + 1

    new_selections =
      socket.assigns.selections ++ [%{container_title: "", item_key: "", id: new_id}]

    {:noreply, assign(socket, selections: new_selections)}
  end

  def handle_event("fetch_historical_data", params, socket) do
    limit = params["limit"] || socket.assigns.limit
    charts_data = fetch_all_charts_data(socket.assigns.selections, limit)

    socket =
      Enum.reduce(charts_data, socket, fn chart_data, acc ->
        push_event(acc, "update-chart-#{chart_data.index}", chart_data.chart)
      end)

    {:noreply, assign(socket, charts_data: charts_data)}
  end

  def handle_info(:fetch_historical_data, socket) do
    if any_selection_complete?(socket.assigns.selections) do
      charts_data = fetch_all_charts_data(socket.assigns.selections, socket.assigns.limit)

      socket =
        Enum.reduce(charts_data, socket, fn chart_data, acc ->
          push_event(acc, "update-chart-#{chart_data.index}", chart_data.chart)
        end)

      {:noreply, assign(socket, charts_data: charts_data)}
    else
      {:noreply, socket}
    end
  end

  defp fetch_all_charts_data(selections, limit) do
    selections
    |> Enum.filter(fn s -> s.container_title != "" and s.item_key != "" end)
    |> Enum.with_index()
    |> Enum.map(fn {selection, index} ->
      opts = [limit: String.to_integer(limit)]

      raw_data =
        DataFetcher.get_historical_data(selection.container_title, selection.item_key, opts)

      reversed_data = Enum.reverse(raw_data)

      %{
        container_title: selection.container_title,
        item_key: selection.item_key,
        index: index,
        chart: %{
          labels: Enum.map(reversed_data, &Calendar.strftime(&1.recorded_at, "%Y-%m-%d %H:%M")),
          values: Enum.map(reversed_data, & &1.value),
          label: "#{selection.container_title} - #{selection.item_key}"
        }
      }
    end)
  end

  defp update_selection(selections, id, key, value) do
    Enum.map(selections, fn s ->
      if s.id == id, do: Map.put(s, key, value), else: s
    end)
  end

  defp any_selection_complete?(selections) do
    Enum.any?(selections, fn s -> s.container_title != "" and s.item_key != "" end)
  end
end
