defmodule ScadaWeb.Components.ContainerComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="relative w-[1640px] h-[1250px]">
      <svg class="absolute w-full h-full pointer-events-none" xmlns="http://www.w3.org/2000/svg">
        <line x1="175" y1="490" x2="175" y2="810" stroke="#1989ac" stroke-width="6" />
        <line x1="175" y1="810" x2="398" y2="810" stroke="#1989ac" stroke-width="6" />
        <line x1="395" y1="810" x2="395" y2="1130" stroke="#1989ac" stroke-width="6" />
        <line x1="175" y1="170" x2="2325" y2="170" stroke="#1989ac" stroke-width="6" />
        <line x1="820" y1="490" x2="2325" y2="490" stroke="#1989ac" stroke-width="6" />
        <line x1="490" y1="810" x2="2325" y2="810" stroke="#1989ac" stroke-width="6" />
        <line x1="175" y1="1130" x2="2325" y2="1130" stroke="#1989ac" stroke-width="6" />
        <line x1="820" y1="50" x2="820" y2="1250" stroke="#be3144" stroke-width="8" />
      </svg>

      <%= for {title, container} <- @containers do %>
        <% id = normalize_id(title)
        {top, left} = position_coordinates(id) %>
        <div
          id={id}
          class="container-box absolute cursor-pointer bg-gray-800 rounded-lg shadow-lg"
          style={"top: #{top}px; left: #{left}px; width: 350px; height: 240px;"}
          phx-click="show_table"
          phx-value-id={id}
        >
          <div class="flex p-2">
            <div class="flex-shrink-0 flex flex-col items-center mr-3">
              <div class="w-14 h-14 bg-gray-600 rounded-full flex items-center justify-center">
                <img
                  src={ScadaWeb.Endpoint.static_path("/images/containers/#{normalize_string(id)}.png")}
                  alt="Status Icon"
                  class="w-10 h-10 object-contain"
                  onerror="this.onerror=null; this.src='/images/default_icon.png';"
                />
              </div>

              <div class="mt-2">
                <div class={"w-3 h-3 rounded-full #{status_class(container)}"}></div>
              </div>
            </div>

            <div class="flex-grow">
              <h3 class="text-xl font-bold text-white mb-2">
                {normalize_string(title) || "Untitled"}
              </h3>

              <div class="grid grid-cols-2 gap-y-2 text-sm">
                <%= for {label, _, symb, value} <- Enum.take(container.items, 3) do %>
                  <div class="col-span-2 border-t border-gray-600"></div>

                  <div class="col-span-1 text-gray-400 font-semibold text-wrap flex items-center">
                    <span class="w-2 h-2 rounded-full mr-1"></span>
                    {label}
                  </div>
                  <div class="col-span-1 text-right font-semibold text-gray-200 text-wrap">
                    {value || "No data"} {if symb, do: symb, else: ""}
                  </div>
                <% end %>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event("show_table", %{"id" => container_id}, socket) do
    {:noreply, assign(socket, selected_container: container_id)}
  end

  defp normalize_id(title),
    do: title |> to_string() |> String.replace(" ", "_")

  defp normalize_string(id), do: id |> String.replace(~r/\d|\//, "")

  defp position_coordinates(id) do
    position_map = %{
      "EV_Charger" => {0, 0},
      "DC_Converter_1" => {0, 1},
      "DC_Converter_2" => {0, 2},
      "PV" => {0, 3},
      # ---------------------------
      "RG_1" => {1, 0},
      "Weather_Station" => {1, 1},
      "DC_Converter_3" => {1, 2},
      "Li-Ion_Battery" => {1, 3},
      # ---------------------------
      "Self_Power" => {2, 0},
      "RG_2" => {2, 1},
      "DC_Converter_4" => {2, 2},
      "AGM_Battery" => {2, 3},
      # ---------------------------
      "AC_Grid" => {3, 0},
      "AC/DC_Converter" => {3, 1},
      "DC_Converter_5" => {3, 2},
      "SCAP_Battery" => {3, 3}
    }

    {row, col} = Map.get(position_map, id, {0, 0})
    row_offset = 320
    col_offset = 430
    margin = 50
    top = row * row_offset + margin
    left = col * col_offset
    {top, left}
  end

  defp get_connection(data) do
    data.items
    |> Enum.find(fn {label, _, _, _} -> label == "Connections [true/false]" end)
    |> case do
      {_, _, _, value} -> value
      nil -> nil
    end
  end

  defp status_class(data) do
    case get_connection(data) do
      true ->
        "bg-green-500"

      _ ->
        "bg-red-500"
    end
  end
end
