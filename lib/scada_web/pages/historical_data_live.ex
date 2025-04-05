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
       container_title: "",
       item_key: "",
       from_time: nil,
       to_time: DateTime.utc_now(),
       tracking_time: nil,
       historical_data: nil,
       container_titles: container_titles,
       parameters: parameters,
       form_data: %{"container_title" => "", "item_key" => "", "limit" => "100"}
     )}
  end

  def render(assigns) do
    ~H"""
    <div
      id="connection-status"
      class="flex flex-col min-h-screen bg-gradient-to-b from-gray-300 to-gray-200"
    >
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
              <label for="tracking_time" class="block text-gray-700 font-medium mb-2">
                Tracking Time (Minutes, Hours, Days):
              </label>
              <input
                type="text"
                id="tracking_time"
                name="tracking_time"
                value={@form_data["tracking_time"]}
                phx-change="update_tracking_time"
                placeholder="e.g., 30m, 2h, 5d"
                class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-teal-500 w-full sm:w-36"
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

  def handle_event("update_tracking_time", %{"tracking_time" => tracking_time}, socket) do
    parsed_time = parse_tracking_time(tracking_time)

    {:noreply, assign(socket, tracking_time: parsed_time)}
  end

  def handle_event(
        "fetch_historical_data",
        %{
          "container_title" => container_title,
          "item_key" => item_key,
          "tracking_time" => tracking_time
        },
        socket
      ) do
    parsed_time = parse_tracking_time(tracking_time)
    fetch_and_update_chart(socket, container_title, item_key, parsed_time)
    {:noreply, assign(socket, tracking_time: parsed_time)}
  end

  def handle_info(:fetch_historical_data, socket) do
    case {socket.assigns.container_title, socket.assigns.item_key, socket.assigns.tracking_time} do
      {container_title, item_key, tracking_time}
      when container_title != "" and item_key != "" and tracking_time != nil ->
        fetch_and_update_chart(socket, container_title, item_key, socket.assigns.tracking_time)

      _ ->
        {:noreply, socket}
    end
  end

  defp fetch_and_update_chart(socket, container_title, item_key, tracking_time) do
    interval = 5

    # Round 'now' down to the nearest 5-second mark
    now =
      DateTime.utc_now()
      |> DateTime.add(2, :hour)
      |> round_to_nearest_5s()

    # Calculate from_time (rounded too, to keep timeline clean)
    from_time = DateTime.add(now, -tracking_time, :second)

    # Fetch already-rounded data from DB
    data =
      DataFetcher.get_historical_data(container_title, item_key,
        from_time: from_time,
        to_time: now
      )

    # Build full timeline every 5s between from_time and now
    timeline =
      Stream.iterate(from_time, &DateTime.add(&1, interval, :second))
      |> Enum.take_while(&(DateTime.compare(&1, now) != :gt))

    # Index data by ISO timestamp for lookup
    data_map =
      data
      |> Enum.map(fn %{recorded_at: dt, value: value} ->
        {DateTime.to_iso8601(dt), value}
      end)
      |> Map.new()

    # Merge data into timeline
    {labels, raw_times, values} =
      Enum.reduce(timeline, {[], [], []}, fn dt, {l_acc, r_acc, v_acc} ->
        iso = DateTime.to_iso8601(dt)

        {
          [Calendar.strftime(dt, "%Y-%m-%d %H:%M:%S") | l_acc],
          [iso | r_acc],
          [Map.get(data_map, iso) | v_acc]
        }
      end)
      |> then(fn {l, r, v} -> {Enum.reverse(l), Enum.reverse(r), Enum.reverse(v)} end)

    # Push to frontend
    chart_data = %{
      labels: labels,
      values: values,
      raw_times: raw_times,
      label: "#{container_title} - #{item_key}"
    }

    socket
    |> assign(historical_data: data, container_title: container_title, item_key: item_key)
    |> push_event("update-chart", chart_data)
    |> then(&{:noreply, &1})
  end

  defp round_to_nearest_5s(dt) do
    dt
    |> Map.update!(:second, &(div(&1, 5) * 5))
    |> Map.put(:microsecond, {0, 6})
  end

  defp parse_tracking_time(input) do
    case Regex.run(~r/^(\d+)([mhd])$/, input) do
      [_, value, unit] ->
        multiplier =
          case unit do
            # Convert minutes to seconds
            "m" -> 60
            # Convert hours to seconds
            "h" -> 3600
            # Convert days to seconds
            "d" -> 86400
          end

        seconds = String.to_integer(value) * multiplier
        # 14 days in seconds
        max_seconds = 14 * 86400

        if seconds > max_seconds do
          max_seconds
        else
          seconds
        end

      # Default to 24h if input is invalid
      _ ->
        86400
    end
  end
end
