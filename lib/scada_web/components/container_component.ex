defmodule ScadaWeb.Components.ContainerComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="relative w-[2500px] h-[1450px]">
      <svg class="absolute w-full h-full pointer-events-none" xmlns="http://www.w3.org/2000/svg">
        <!-- Connecting lines -->
        <line x1="1250" y1="50" x2="1250" y2="1250" stroke="red" stroke-width="6" />
        <line x1="175" y1="170" x2="175" y2="490" stroke="blue" stroke-width="4" />
        <line x1="175" y1="490" x2="395" y2="490" stroke="blue" stroke-width="4" />
        <line x1="395" y1="490" x2="395" y2="810" stroke="blue" stroke-width="4" />
        <line x1="1465" y1="170" x2="2325" y2="170" stroke="blue" stroke-width="4" />
        <line x1="1035" y1="490" x2="2325" y2="490" stroke="blue" stroke-width="4" />
        <line x1="175" y1="810" x2="2325" y2="810" stroke="blue" stroke-width="4" />
        <line x1="175" y1="1130" x2="2325" y2="1130" stroke="blue" stroke-width="4" />
      </svg>
      <%= for {title, container} <- @containers do %>
        <% id = normalize_id(title)
        {top, left} = position_coordinates(id) %>
        <div
          id={id}
          class="container-box"
          style={"top: #{top}px; left: #{left}px; width: 350px; height: 240px;"}
        >
          <!-- Icon and Status -->
          <div class="flex-shrink-0 flex flex-col items-center mr-4">
            <div class="w-14 h-14 bg-gray-600 rounded-full flex items-center justify-center">
              <img
                src={"/images/containers/#{normalize_string(id)}.png"}
                alt="Status Icon"
                class="w-10 h-10 object-contain"
                onerror="this.onerror=null; this.src='/images/default_icon.png';"
              />
            </div>

            <%= if container.status_indicator do %>
              <div class="mt-2">
                <div class={"w-3 h-3 rounded-full #{status_class(container.status_indicator)}"}></div>
              </div>
            <% end %>
          </div>

    <!-- Title and Key-Value Grid -->
          <div class="flex-grow">
            <h3 class="text-xl font-bold text-white">{normalize_string(title) || "Untitled"}</h3>

            <div class="grid grid-cols-2 gap-y-3 text-m">
              <%= for {label, _, symb, value} <- container.items do %>
                <div class="col-span-1 text-gray-400">{label}</div>

                <div class="col-span-1 text-right font-semibold text-gray-100">
                  {value || "N/A"} {symb}
                </div>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp normalize_id(title) do
    title
    |> to_string()
    |> String.downcase()
    |> String.replace(" ", "_")
  end

  defp normalize_string(id) do
    id
    |> String.replace(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "/"], "")
  end

  defp position_coordinates(id) do
    position_map = %{
      "rg_1" => {0, 0},
      "weather_station" => {0, 1},
      "dc_meter_1" => {0, 3},
      "dc_converter_1" => {0, 4},
      "li-ion_battery" => {0, 5},
      "rg_2" => {1, 2},
      "dc_meter_2" => {1, 3},
      "dc_converter_2" => {1, 4},
      "agm_battery" => {1, 5},
      "ac_bus" => {2, 0},
      "ac/dc_converter" => {2, 1},
      "dc_meter_3" => {2, 2},
      "dc_meter_4" => {2, 3},
      "dc_converter_3" => {2, 4},
      "scap_battery" => {2, 5},
      "dc_meter_5" => {3, 0},
      "dc_converter_4" => {3, 1},
      "dc_meter_6" => {3, 2},
      "dc_meter_7" => {3, 3},
      "dc_converter_5" => {3, 4},
      "pv" => {3, 5}
    }

    {row, col} = Map.get(position_map, id, {0, 0})

    # Adjust these values for padding and margin
    row_offset = 320
    col_offset = 430
    margin = 50

    # Position calculation
    top = row * row_offset + margin
    left = col * col_offset

    {top, left}
  end

  defp status_class("Operational"), do: "bg-green-500"
  defp status_class(_), do: "bg-red-500"
end
