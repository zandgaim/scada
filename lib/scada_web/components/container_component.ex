defmodule ScadaWeb.Components.ContainerComponent do
  use Phoenix.LiveComponent

  @doc """
  Renders a generic container with a title and a list of key-value pairs.
  """
  def render(assigns) do
    ~H"""
    <div class="bg-gray-800 p-4 rounded-lg shadow-md">
      <h3 class="text-lg font-semibold mb-2">{@title}</h3>
      
      <ul class="text-sm">
        <%= for {label, value} <- @items do %>
          <li>{label}: <span class="font-bold">{value}</span></li>
        <% end %>
      </ul>
    </div>
    """
  end
end
