defmodule ScadaWeb.Components.ContainerComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="relative w-[1600px] h-[1450px]">
      <%= for {title, container} <- @containers do %>
        <% id = normalize_id(title)
        {top, left} = position_coordinates(id) %>
        <div
          id={id}
          class="absolute bg-gray-800 p-4 rounded-lg shadow-md text-white flex items-start"
          style={"top: #{top}px; left: #{left}px; width: 350px; height: 240px;"}
        >
          <!-- Icon and Status -->
          <div class="flex-shrink-0 flex flex-col items-center mr-4">
            <div class="w-14 h-14 bg-gray-600 rounded-full flex items-center justify-center">
              <img
                src={"/images/containers/#{id}.png"}
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
            <h3 class="text-xl font-bold text-white">{title || "Untitled"}</h3>
            
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

  defp position_coordinates(id) do
    position_map = %{
      "weather_station" => {0, 0},
      "pv" => {0, 1},
      "li-ion_battery" => {0, 2},
      "agm_battery" => {0, 3},
      "dc_converter" => {1, 1},
      "dc_converter_2" => {1, 2},
      "rg1" => {1, 3},
      "dc_bus" => {1.5, 0},
      "dc_converter_3" => {2, 1},
      "ac/dc_converter" => {2, 2},
      "rg2" => {2, 3},
      "dc_charger" => {3, 1},
      "wind_turbine" => {3, 2},
      "scap_battery" => {3, 3}
    }

    {row, col} = Map.get(position_map, id, {0, 0})

    # Adjust these values for padding and margin
    row_offset = 320
    col_offset = 400
    margin = 50

    # Position calculation
    top = row * row_offset + margin
    left = col * col_offset

    {top, left}
  end

  defp status_class("Operational"), do: "bg-green-500"
  defp status_class(_), do: "bg-red-500"
end
