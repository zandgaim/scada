defmodule ScadaWeb.Pages.HistoricalDataLive do
  use Phoenix.LiveView
  import Phoenix.Component

  def mount(_params, _session, socket) do
    grafana_url = Application.get_env(:scada, :grafana_url, "http://localhost:3000")

    {:ok,
     assign(socket,
       current_tab: "historical_data",
       grafana_url: grafana_url
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="h-screen flex flex-col bg-gradient-to-b from-gray-300 to-gray-200">
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

      <div class="w-full" style="height: calc(100vh - 4rem);">
        <iframe src={"#{@grafana_url}/d/scada-dashboard"} class="w-full h-full" frameborder="0">
        </iframe>
      </div>
    </div>
    """
  end
end
