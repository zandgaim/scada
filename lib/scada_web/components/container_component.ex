defmodule ScadaWeb.Components.ContainerComponent do
  use Phoenix.LiveComponent

  @doc """
  Renders a styled container with a title, optional status indicator, and a grid of key-value pairs.
  """
  def render(assigns) do
    ~H"""
    <div class="bg-gray-900 p-4 rounded-lg shadow-lg text-white w-full">
      <!-- Title and Status Indicator -->
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-lg font-semibold truncate">{@title}</h3>
        <%= if @status_indicator do %>
          <div class="flex items-center">
            <div class={
              if @status_indicator == "Operational",
                do: "w-3 h-3 bg-green-500 rounded-full",
                else: "w-3 h-3 bg-red-500 rounded-full"
            }>
            </div>
            <span class="ml-2 text-sm text-gray-300">{@status_indicator}</span>
          </div>
        <% end %>
      </div>
      
    <!-- Grid of Key-Value Pairs -->
      <div class="grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
        <%= for {label, value} <- @items do %>
          <div class="col-span-1 text-gray-400 truncate">{label}</div>
          <div class="col-span-1 text-right font-semibold truncate">{value}</div>
        <% end %>
      </div>
    </div>
    """
  end
end
